//
//  AppendPlanViewController.swift
//  itjh
//
//  Created by huasu on 15/3/26.
//  Copyright (c) 2015 zwb. All rights reserved.
//

import UIKit
import Alamofire
class MyPlanInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //global params
    var flag = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var stringarr = [String]()
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var dataArray:NSMutableArray = []
    var nowPage:Int = 1
    var urlParam = String()
    var statusArr = [String]()
    var nowUserID = String()
    var selectedDay = String()
    var segementItem = 0
    //UI
    var mainTableView = UITableView(frame: CGRectZero)
    var segement:UISegmentedControl = UISegmentedControl(items: ["今日结果","明日计划"])
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("........")
        //println(self.selectedDay)
    
        self.view.backgroundColor = UIColor.whiteColor()
        urlParam = "Attention"
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        flag = 0
        loadData()
    }
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        navSetting()
        tableViewSetting()
        segementSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    //MARK:LoadData
    func loadData(){
        //println(">>>>>>>>")
        //println(self.selectedDay)
        if(segementItem == 1){
            selectedDay = _globalTomorrow
        }else{
            selectedDay = _globalToday
        }
        flag = 1
        let Parameters1 = [
            "empID":nowUserID,"dayTime":"\(selectedDay)"
        ]
        //println(nowUserID)
        //println(selectedDay)
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
                    self.flag = 0
                }
        }

    }
    //MARK:BASE SETTING
    func WidthHeight_ArraySetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        
    }
    //MARK:NAV SETTING
    func navSetting(){
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        var  titleLabel = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        titleLabel.text = "今日结果与明日计划"
        titleLabel.textColor = _globalTitleColor
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = _globaluifont
        navView.addSubview(titleLabel)
        //left Button
        var leftBtn = UIButton(frame: CGRectMake(10, 35, 20, 25))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        
        //right Button
        var rightBtn = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        rightBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "emailxinzeng.png"), forState: UIControlState.Normal)
        rightBtn.tag = 202
        navView.addSubview(rightBtn)
    }
    //MARK:navBtnClick
    func navBtnClick(sender:UIButton){
        if(sender.tag == 201){
            var vc = ResultViewController();
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }else if(sender.tag == 202){
            var vc = AppendPlanViewController();
            vc.modalTransitionStyle = _globalCustomviewchange
            vc.nowDay = self.selectedDay
            vc.nowID = self.nowUserID
            vc.segementItem = self.segementItem
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    //MARK:TableView
    func tableViewSetting(){
        mainTableView.frame = CGRectMake(0, 70, width, height - 100)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = _globalBgcolor
        self.view.addSubview(mainTableView)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var dic = self.dataArray[indexPath.row] as NSDictionary
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
        
        var nameLabel = UILabel(frame: CGRectMake(20, 5, width - 40, 40))
        nameLabel.font = _globaluifont
        var nameDic = dic["CREATOR"] as NSDictionary
        var nameStr = nameDic["RealName"] as String
        nameLabel.text = "姓名: \(nameStr)"
        cell.contentView.addSubview(nameLabel)
        
        var fromLabel = UILabel(frame: CGRectMake(20, 45, width-40, 40))
        fromLabel.font = _globaluifont
        var resultStr = dic["RESULTDEFINITION"] as String
        fromLabel.text = "出自: \(resultStr)"
        cell.contentView.addSubview(fromLabel)
    
        var contentLabel = UILabel(frame: CGRectMake(20, 85, width-40, 40))
        contentLabel.font = _globaluifont
        var contentStr = dic["WORKCONTENT"] as String
        contentLabel.text = "内容: \(contentStr)"
        cell.contentView.addSubview(contentLabel)
        
        var reportLabel = UILabel(frame: CGRectMake(20, 125, width-40, 40))
        reportLabel.font = _globaluifont
        var userDic = dic["CUSTOMERNAME"] as NSDictionary
        var userStr = userDic["RealName"] as String
        reportLabel.text = "汇报: 汇报给\(userStr)"
        cell.contentView.addSubview(reportLabel)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    //MARK:Segement Setting
    func segementSetting(){
        segement.frame = CGRectMake(0, height - 30, width, 30)
        segement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        segement.selectedSegmentIndex = segementItem
        self.view.addSubview(segement)
    }
    func segementChange(sender:UISegmentedControl){
        //println(self.segement.selectedSegmentIndex)
        self.dataArray.removeAllObjects()
        segementItem = self.segement.selectedSegmentIndex
        if(flag == 0){
            loadData()
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
