//
//  DownLoadUpdateView.swift
//  PullToRefresh_161102
//
//  Created by ChenLei on 16/11/5.
//  Copyright © 2016年 ChenLei. All rights reserved.
//

import UIKit

class DownLoadUpdateView: UIView {

    let label:UILabel!
    
    init(superView:UIView) {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: superView.bounds.width, height: 20))
        super.init(frame: CGRect(x: 0, y: 0, width: superView.bounds.width, height: superView.bounds.height))
        backgroundColor = UIColor.redColor()
        labelInit(label)
    }
    
    func RefreshViewUpdate(downHeight:CGFloat,status:DownLoadStatus) -> Void{
        switch (status){
        case .WaitDownLoad:
            label.text = "上拉加载"
            break;
        case .OpenDownLoad:
            label.text = "松手即可加载"
            break;
        case .DownLoading:
            label.text = "正在加载"
            break;
        case .Finished:
            label.text = "加载成功"
            break;
        }
        
    }
    
    func labelInit(label:UILabel){
        label.textAlignment = .Center
        insertSubview(label, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
