//
//  Refresh_DownLoad_View.swift
//  PullToRefresh_161102
//
//  Created by ChenLei on 16/11/5.
//  Copyright © 2016年 ChenLei. All rights reserved.
//

import UIKit

//下拉控件的协议
public protocol RefreshManageDelegate{
    func didRefresh() -> Void
}

class RefreshManage :RefreshViewDelegate{
    
    private let superScrollview:UIScrollView!
    
    var refreshView:RefreshView?
//    var downloadView:DownLoadView?
    
    var delegate:RefreshManageDelegate?

    init(scrollview:UIScrollView,refresh:Bool,refreshHeight:CGFloat){
        superScrollview = scrollview;
        //如果有 下拉刷新 的话 就初始化下拉刷新
        if refresh {
            //因为这是个UITableViewController 所以refreview加入view被下拉的时候会跟着下来
            //将refreview放到tableView的上方
            refreshView = RefreshView(refreshHeight: refreshHeight, scrollview: superScrollview)
            //设置下拉控件的委托
            refreshView!.delegate = self
            //将下拉控件添加到scrollview上
            superScrollview.insertSubview(refreshView!, atIndex: 0)
        }
//        if download {
//            //因为这是个UITableViewController 所以refreview加入view被下拉的时候会跟着下来
//            //将refreview放到tableView的上方
//            downloadView = DownLoadView(refreshHeight: downloadHeight, scrollview: superScrollview)
//            //设置下拉控件的委托
//            downloadView!.delegate = self
//            //将下拉控件添加到scrollview上
//            superScrollview.insertSubview(downloadView!, atIndex: 1)
//        }
    }
    
    //当下拉刷新或上拉加载的 位置或状态改变时 去调用下拉刷新或上拉加载的界面
    func RefreshViewUpdate(downHeight:CGFloat,status:RefreshStatus) -> Void{
        if refreshView != nil{
            refreshView?.refreshUpdateView.RefreshViewUpdate(downHeight, status: status)
            if status == .Refreshing && delegate != nil{
                delegate!.didRefresh()
            }
        }
    }
    
//    func DownLoadViewUpdate(downHeight:CGFloat,status:DownLoadStatus) -> Void{
//        if downloadView != nil{
//            downloadView?.downLoadUpdateView.RefreshViewUpdate(downHeight, status: status)
//            if status == .DownLoading{
//                //模拟2秒 结束下拉
//                let time: NSTimeInterval = 2.0
//                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)));
//                dispatch_after(delay, dispatch_get_main_queue()) {
//                    self.downloadView?.RefreshFinished()
//                }
//            }
//        }
//    }
    
    func RefreshSuccess(isSuccess:Bool){
        refreshView!.RefreshFinished()
        refreshView!.refreshUpdateView.RefreshSuccess(isSuccess)
    }

}
