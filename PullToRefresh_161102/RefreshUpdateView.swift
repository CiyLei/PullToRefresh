//
//  RefreshUpdateView.swift
//  PullToRefresh_161102
//
//  Created by ChenLei on 16/11/5.
//  Copyright © 2016年 ChenLei. All rights reserved.
//

import UIKit

class RefreshUpdateView: UIView {

    let label:UILabel!
    let labelTime:UILabel!
    
    init(superView:UIView) {
        label = UILabel(frame: CGRect(x: 0, y: 170, width: superView.bounds.width, height: 20))
        labelTime = UILabel(frame: CGRect(x: 0, y: 145, width: superView.bounds.width, height: 20))
        super.init(frame: CGRect(x: 0, y: 0, width: superView.bounds.width, height: superView.bounds.height))
        backgroundColor = UIColor.redColor()
        labelTime.text = "尚未更新"
        labelInit(label)
        labelInit(labelTime)
    }
    
    func RefreshViewUpdate(downHeight:CGFloat,status:RefreshStatus) -> Void{
        switch (status){
        case .WaitRefresh:
            label.text = "下拉刷新"
            break;
        case .OpenRefresh:
            label.text = "松手即可刷新"
            break;
        case .Refreshing:
            label.text = "正在刷新"
            break;
        case .Finished:
            //这里不应该有界面处理 关于刷新成功的界面处理由RefreshSuccess处理
            break;
        }
        
//        labelAutoSize(label)
    }
    
    
    func RefreshSuccess(isSuccess:Bool){
        if isSuccess{
            label.text = "刷新成功"
            labelTime.text = getDateTime("上次更新:yyy-MM-dd HH:mm:ss")
        }else{
            label.text = "刷新失败"
        }
    }
    
    func labelInit(label:UILabel){
        label.textAlignment = .Center
        insertSubview(label, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //lable自适应内容
    func labelAutoSize(label:UILabel){
        let text:String = self.label.text!//获取label的text
        let attributes = NSDictionary(object: self.label.font, forKey: NSFontAttributeName)//计算label的字体
        label.frame = labelSize(text, attributes: attributes as [NSObject : AnyObject])//调用计算label宽高的方法
        //处于居中下
        label.center.x = self.center.x
        label.center.y = self.bounds.height - 25
    }
    
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
        size = text.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes as? [String : AnyObject] , context: nil);
        return size
    }
    
    //获取系统时间
    func getDateTime(Format:String) -> String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = Format
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }

}
