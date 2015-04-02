//
//  spdetailinfoController.swift
//  itjh
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 com.jndz.mrshan. All rights reserved.
//

import UIKit
import Alamofire

class spdetailinfoController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //params
    var topdic:NSDictionary = NSDictionary()
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var textarea = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var noteid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        getdata()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SET
    func getdata(){
        let id = self.topdic["ID"] as? String
        let Parameters1 = ["ID":"\(id!)"]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/AddWorkFlow/getAddWorkFlowDetail",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil && string4 != "[]"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                    var arr = jsonObject[0] as NSDictionary
                    self.noteid = arr["UPNODEID"] as String
                    println(">>>>>")
                    self.getData2()
                }
        }
    }
    
    func getData2(){
        let id = self.noteid
        let Parameters1 = ["ID":"\(id)"]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/AddWorkFlow/GetNodeDetail",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil && string4 != "[]"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                    var ar = jsonObject[0] as NSDictionary
                    println(jsonObject)
                }
        }
    }
    
    func topviewSetting(){
        let frame = CGRectMake(0, 0, width, 20)
        self.topView.frame = frame
        self.topView.backgroundColor = bgcolorall
        self.view.addSubview(topView)
    }
    
    func WidthHeightSetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "审批详细"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
        getscrollview()
    }
    
    func getscrollview(){
        var scrollview = UIView(frame: CGRectMake(0, 0, width, height - 20 - _globalNavviewHeight))
//        scrollview.contentSize = CGSize(width: width, height: 1500)
//        scrollview.bounces = false
        scrollview.backgroundColor = _globalgraycolor
        self.textarea.addSubview(scrollview)
        //top middle whiteview 110 + 5
        var whiteview = UIView(frame: CGRectMake(2, 3, width - 4, 110))
        whiteview.layer.cornerRadius = 7
        whiteview.backgroundColor = UIColor.whiteColor()
        var label = UILabel(frame: CGRectMake(1, 5, 100, 25))
        label.text = "流水号"
        label.font = _globaluifont
        whiteview.addSubview(label)
        var label1 = UILabel(frame: CGRectMake(1, 31, 100, 50))
        label1.text = "公文名称"
        label1.font = _globaluifont
        whiteview.addSubview(label1)
        var label2 = UILabel(frame: CGRectMake(1, 82, 100, 25))
        label2.text = "当前步骤 "
        label2.font = _globaluifont
        whiteview.addSubview(label2)
        scrollview.addSubview(whiteview)
        //middle gray view
        var graytableview = UITableView(frame: CGRectMake(2, 116, width - 4, height - _globalNavviewHeight - 135 - 27))
        graytableview.delegate = self
        graytableview.dataSource = self
        graytableview.tag = 9
        graytableview.bounces = false
        graytableview.separatorColor = _globalBgcolor
        graytableview.layer.cornerRadius = 7
        graytableview.backgroundColor = UIColor.yellowColor()
        scrollview.addSubview(graytableview)
        //bot segment
        var botseg = UISegmentedControl(items: ["审批","驳回","委托"])
        botseg.frame = CGRectMake(0, height - 26, width, 25)
        botseg.addTarget(self, action: "presssegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(botseg)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "spdetailinfocontrollertableivewcell")
        if(indexPath.row == 0){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "部门所在公司"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 1){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "日期"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 2){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "姓名"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 3){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "部门"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 4){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "事由"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 5){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "部门主管意见"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 6){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "部门主管签字"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 7){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "分公司总经理意见"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 8){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "分公司总经理签字"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 9){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "分管副总意见"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 10){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "分管副总签字"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 11){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "人力资源部意见"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 12){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "人力资源部签字"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 13){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "总经理意见"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 14){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "请假天数"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 15){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "1"
            label.font = uifont1
            cell.addSubview(label)
        }
        if(indexPath.row == 16){
            var label = UILabel(frame: CGRectMake(5, 5, 150, 30))
            label.text = "2"
            label.font = uifont1
            cell.addSubview(label)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
    //MARK: ACTION (BUTTONS)
    func pressshowall(sender:UIButton){
        var con = approveController()
        con.whichsegment = 0
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func presssegment(sender:UISegmentedControl){
        println(sender.selectedSegmentIndex)
    }

}
