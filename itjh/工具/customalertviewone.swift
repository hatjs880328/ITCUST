//
//  customalertviewone.swift
//  itjh
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 com.jndz.mrshan. All rights reserved.
//

import UIKit

class customalertviewone: UIView,UITableViewDataSource,UITableViewDelegate {

    override func drawRect(rect: CGRect) {
        var customalertviewone2 = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        self.addSubview(customalertviewone2)
        _globalcustomcellarray.append("shan")
        _globalcustomcellarray.append("wen")
        _globalcustomcellarray.append("zheng")
        var tableview = UITableView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        tableview.delegate = self
        tableview.dataSource = self
        self.addSubview(tableview)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dsfa123")
        cell.textLabel?.text = _globalcustomcellarray[indexPath.row] as String
        return cell
    }

}
