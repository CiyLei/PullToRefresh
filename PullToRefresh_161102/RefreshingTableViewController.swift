//
//  RefreshingTableViewController.swift
//  PullToRefresh_161102
//
//  Created by ChenLei on 16/11/2.
//  Copyright © 2016年 ChenLei. All rights reserved.
//

import UIKit

class RefreshingTableViewController: UITableViewController,RefreshManageDelegate {

    var refreview:RefreshView!
    //下拉刷新的界面
    var refreshUpdateView:RefreshUpdateView!
    //上拉加载的界面
    var loadingUpdateView:RefreshUpdateView!
    
    var re_do_vi:RefreshManage!
    
    var rows:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        re_do_vi = RefreshManage(scrollview: tableView, refresh: true, refreshHeight: 70)
        re_do_vi.delegate = self
    }
    
    var i:Int = 0
    func didRefresh() -> Void{
        //模拟2秒 结束下拉
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)));
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.i++
            if self.i % 3 == 0{
                self.re_do_vi.RefreshSuccess(true)
                self.rows += 2
                self.tableView.reloadData()
            }else{
                self.re_do_vi.RefreshSuccess(false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mycell", forIndexPath: indexPath)

        cell.textLabel?.text = "第\(indexPath.row)行"

        return cell
    }

}
