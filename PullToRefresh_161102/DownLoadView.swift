//
//  DownLoadView.swift
//  PullToRefresh_161102
//
//  Created by ChenLei on 16/11/5.
//  Copyright © 2016年 ChenLei. All rights reserved.
//

import UIKit

//上拉状态
public enum DownLoadStatus{
    case WaitDownLoad    //等待上拉加载
    case OpenDownLoad    //放开上拉加载
    case DownLoading     //加载中
    case Finished       //加载完毕
}

//上拉控件的协议
public protocol DownLoadViewDelegate{
    func DownLoadViewUpdate(downHeight:CGFloat,status:DownLoadStatus) -> Void
}

class DownLoadView: UIView {

    //一个弱引用的控件 防止内存泄漏 和week的区别是 这个不能为nil 比较危险
    private unowned var scrollview:UIScrollView
    //被上拉的高度
    private var downHeight:CGFloat = 0.0
    //最高的被上拉高度
    private let maxRefreshHeight:CGFloat = 100.0
    //上拉到该刷新的高度
    var refreshHeight:CGFloat = 30.0
    //上拉刷新的界面
    var downLoadUpdateView:DownLoadUpdateView!
    
    //上拉刷新的委托
    var delegate:DownLoadViewDelegate?
    
    //默认状态:等待上拉刷新
    private var status:DownLoadStatus = DownLoadStatus.WaitDownLoad
    
    init(frame: CGRect,scrollview:UIScrollView) {
        self.scrollview = scrollview
        super.init(frame: frame)
        //初始化 上拉刷新界面
        downLoadUpdateView = DownLoadUpdateView(superView: self)
        insertSubview(downLoadUpdateView, atIndex: 0)
        //updateBack()
    }
    
    init(refreshHeight:CGFloat,scrollview:UIScrollView){
        self.scrollview = scrollview
        super.init(frame: CGRect(x: 0, y: scrollview.contentSize.height + 90, width: scrollview.bounds.width, height: maxRefreshHeight))
        print(scrollview.contentSize.height)
        self.refreshHeight = refreshHeight
        //初始化 上拉刷新界面
        downLoadUpdateView = DownLoadUpdateView(superView: self)
        insertSubview(downLoadUpdateView, atIndex: 0)
    }
    
    init(scrollview:UIScrollView){
        self.scrollview = scrollview
        super.init(frame: CGRect(x: 0, y: scrollview.bounds.height, width: scrollview.bounds.width, height: maxRefreshHeight))
        //初始化 上拉刷新界面
        downLoadUpdateView = DownLoadUpdateView(superView: self)
        insertSubview(downLoadUpdateView, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //当UIScrollView被下拉时触发   应当在调用类中实现scrollViewDidScroll并调用此方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //scrollview.contentOffset.y  控件内容的偏移量  下拉是负数 所以加－成正数
        //scrollview.contentInset.top 控件的y值吧
        downHeight = max(0 , -scrollview.contentOffset.y - scrollview.contentInset.top)
        //如果现在处于 等待下拉刷新 状态并达到了下拉刷新的高度
        if downHeight >= refreshHeight && status == .WaitDownLoad{
            status = .OpenDownLoad
            //如果现在处于 放开下拉刷新 状态小于了下拉刷新的高度
        }else if downHeight < refreshHeight && status == .OpenDownLoad{
            status = .WaitDownLoad
        }
        update()
        //updateBack()
    }
    
    //当UIScrollView被松手时触发   应当在调用类中实现scrollViewWillEndDragging并调用此方法
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //如果正在刷新 当时用户手动下拉使 下拉刷新的界面被挡 应该自动弹回来（未实现）
        if status == .DownLoading && downHeight < refreshHeight{
            
        }
        //如果现在处于 放开下拉刷新 状态并达到了下拉刷新的高度
        guard downHeight >= refreshHeight && status == .OpenDownLoad else{ return }
        status = .DownLoading
        
        update()
        
        //首先改变scrollview的top值   这样scrollview回弹的时候不会倒顶部了 然后改变scrollview回弹的位置 这样弹回来的时候会流畅 最后刷新完毕就可以改变top值使scrollview弹到顶部
        UIView.animateWithDuration(0.4, delay: 0, options: .TransitionNone, animations: { () -> Void in
            self.scrollview.contentInset.top += self.refreshHeight
            },completion: nil)
        
        //设置tableview弹回的位置
        //因为这里时用偏移量 所以是负值
        targetContentOffset.memory.y = -self.scrollview.contentInset.top
    }
    
    //刷新完毕 执行回到顶部的操作
    func RefreshFinished(){
        status = .Finished
        update()
        UIView.animateWithDuration(0.4, delay: 0, options: .TransitionNone, animations: { () -> Void in
            self.scrollview.contentInset.top -= self.refreshHeight
            self.update()
            }){ (flag) -> Void in
                self.status = .WaitDownLoad
        }
    }
    
    //等待下拉刷新 和 放开下拉刷新 可以被执行多次 但是 刷新中 和 刷新完毕 我觉得应该只执行一次
    var Refreshing_flag = true     //true 第一次执行
    var Finished_flag = true
    //执行委托
    func update(){
        if delegate != nil{
            //如果是 刷新中 而且是第一次执行
            if status == .DownLoading && Refreshing_flag{
                delegate?.DownLoadViewUpdate(downHeight, status: status)
                Refreshing_flag = false
                return
            }
            //如果是 刷新完毕 而且是第一次执行
            if status == .Finished && Finished_flag{
                delegate?.DownLoadViewUpdate(downHeight, status: status)
                Finished_flag = false
                return
            }
            if status == .WaitDownLoad || status == .OpenDownLoad{
                delegate?.DownLoadViewUpdate(downHeight, status: status)
                Refreshing_flag = true;
                Finished_flag = true;
                return
            }
        }
    }

}
