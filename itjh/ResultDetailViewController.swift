//
//  ResultDetailViewController.swift
//  itjh
//
//  Created by huasu on 15/3/26.
//  Copyright (c) 2015 zwb. All rights reserved.
//

import UIKit
import Alamofire
class ResultDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //global params
    var flag = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var stringarr = [String]()
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var dataArray:NSMutableArray = []
    var empID = String()
    var dayTime = String()
    var statusArr = [String]()
    //UI
    var mainTableView = UITableView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        loadData()
    }
    func loadData(){
        let Parameters1 = [
            "empID":"\(empID)","dayTime":"\(dayTime)"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Dayresult/GetDayplans",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    var arr = result["rows"] as NSMutableArray
                    self.dataArray.addObjectsFromArray(arr)
                    self.mainTableView.reloadData()
                }
        }

    }
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        navSetting()
        tableViewSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    //MARK:BASE SETTING
    func WidthHeight_ArraySetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        
        statusArr.append("待承诺")
        statusArr.append("待汇报")
        statusArr.append("待检查")
        statusArr.append("待确认")
        statusArr.append("已完成")
        statusArr.append("未完成")
    }
    //MARK:NAV SETTING
    func navSetting(){
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        var  titleLabel = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        titleLabel.text = "结果详情"
        titleLabel.textColor = _globalTitleColor
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = _globaluifont
        navView.addSubview(titleLabel)
        //left Button
        var leftBtn = UIButton(frame: CGRectMake(10, 35, 20, 25))
        leftBtn.addTarget(self, action: "navBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
   
        navView.addSubview(leftBtn)
    
    }
    //MARK:navBtnClick
    func navBtnClick(){
        var vc = ResultViewController()
        vc.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(vc, animated: true, completion: nil)
    }
    //MARK:tableView Setting
    func tableViewSetting(){
        mainTableView.frame = CGRectMake(0, 70, width, height - 70)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = _globalBgcolor
        self.view.addSubview(mainTableView)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
        //cell didSelected color
        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
        var dic = self.dataArray[indexPath.row] as NSDictionary
        
        var nameLabel = UILabel(frame: CGRectMake(10, 5, width - 20, 30))
        var nameDic = dic["CREATOR"] as NSDictionary
        nameLabel.text = nameDic["RealName"] as NSString
        nameLabel.textColor = _globalBgcolor
        nameLabel.font = uifont2
        cell.contentView.addSubview(nameLabel)
        
        var contentLabel = UILabel(frame: CGRectMake(20, 40, width-40, 20))
        var contentStr = dic["WORKCONTENT"] as NSString
        contentLabel.text = "工作内容: \(contentStr)"
        contentLabel.font = _globaluifont
        cell.contentView.addSubview(contentLabel)

        var resultLabel = UILabel(frame: CGRectMake(20, 60, width-40, 20))
        var resultStr = dic["RESULTDEFINITION"] as NSString
        resultLabel.text = "结果定义: \(resultStr)"
        resultLabel.font = _globaluifont
        cell.contentView.addSubview(resultLabel)
        
        var userLabel = UILabel(frame: CGRectMake(20, 80, width-40, 20))
        var userDic = dic["CUSTOMERNAME"] as NSDictionary
        var userStr = userDic["RealName"] as NSString
        userLabel.text = "客户名称: \(userStr)"
        userLabel.font = _globaluifont
        cell.contentView.addSubview(userLabel)
        
        var finishLabel = UILabel(frame: CGRectMake(20, 100, width-40, 20))
        var num = dic["VISIBLERANGE"] as? Int
        var finishStr = statusArr[num!] as NSString
        finishLabel.text = "完成情况: \(finishStr)"
        finishLabel.font = _globaluifont
        cell.contentView.addSubview(finishLabel)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
