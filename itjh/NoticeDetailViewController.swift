//
//  NoticeDetailViewController.swift
//  oa
//
//  Created by  on 15/3/12.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class NoticeDetailViewController: UIViewController {
    var noticeID:String?
    var width:CGFloat = 0
    var height:CGFloat = 0
    var btnKey:String?
    var btnName = String()
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    //UI
    var titleLabel = UILabel(frame: CGRectZero)
    var typeLabel = UILabel(frame: CGRectZero)
    var name_timeLabel = UILabel(frame: CGRectZero)
    var contentWebView = UIWebView(frame: CGRectZero)
    var attachmentWebView = UIWebView(frame: CGRectZero)
    var attachmentBtn = UIButton(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        loadData()
    }
    //MARK:loadData
    func loadData(){
        let Parameters1 = ["id":self.noticeID!
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/CompanyNotice/GetCompanyNoticeDetailPhoneOA",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let result : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                if let statusesArray = result as? NSArray{
                    if let dataDic = statusesArray[0] as? NSDictionary{
                        self.titleLabel.text = dataDic["TITLE"] as? String
                        var typeStr = dataDic["NAME"] as? String
                        self.typeLabel.text = " 类  别: \(typeStr!)"
                        var str1 = dataDic["UNIT"] as? String
                        var str2 = dataDic["REALNAME"] as? String
                        var str3 = dataDic["NOWTIMES"] as? String
                        self.name_timeLabel.text = " 发布人: \(str1!) \(str2!)    \(str3!)"
                        //content if the machine is 5+ can display the pic if not ,it's can't
                        var content = dataDic["CONTENT"] as? String
                        if(_globalmachinetype == "5"){
                            var mm:NSMutableString = ""
                            mm.appendString(content!)
                            var aaa = detaillpic()
                            self.contentWebView.loadHTMLString("\(aaa.dothePic(mm))", baseURL: nil)
                        }else{
                            self.contentWebView.loadHTMLString("\(content!)", baseURL: nil)
                        }
                        if(dataDic["KEYFIELD"] != nil){
                            self.btnKey = dataDic["KEYFIELD"] as? String
                            self.backButtonName()
                        }
                    }
                }
        }
    }
    //MARK:extra File's name
    func backButtonName(){
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/CompanyNotice/AttachmentList",
            parameters: ["KEYFIELD":"\(btnKey!)"])
            .responseString{(request,response,string4,error) in
                if(string4 != nil && string4 != "[]"){
                var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let result : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                if let statusesArray = result as? NSArray{
                    if let dataDic = statusesArray[0] as? NSDictionary{
                        var title = dataDic["NAME"] as? String
                        println(self.btnKey)
                        self.attachmentBtn.setTitle(title, forState: UIControlState.Normal)
                        self.btnName = dataDic["NEWNAME"] as NSString
                    }
                }
            }
        }
    }
    //MARK:viewDidAppear
    override  func viewDidAppear(animated: Bool) {
        makeUI()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    //MARK:main UI Setting
    func makeUI(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        //nav
        let navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview(navView)
        var label = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        label.text = "详情页面"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = _globaluifont
        navView.addSubview(label)
        
        var button = UIButton(frame: CGRectMake(10, 35, 20, 30))
        button.addTarget(self, action: "backBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        navView.addSubview(button)
        
        //title
        titleLabel.frame = CGRectMake(0, 70, width, 39)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = _globaluifont
        titleLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
        //line
        var lineView1 = UIView(frame: CGRectMake(0, 109, width, 1))
        lineView1.backgroundColor = UIColor.grayColor()
        self.view.addSubview(lineView1)
        //type
        typeLabel.frame = CGRectMake(0, 110, width, 39)
        typeLabel.font = _globaluifont
        self.view.addSubview(typeLabel)
        //line
        var lineView2 = UIView(frame: CGRectMake(0, 149, width, 1))
        lineView2.backgroundColor = UIColor.grayColor()
        self.view.addSubview(lineView2)
        //publish person&TIME
        name_timeLabel.frame = CGRectMake(0, 150, width, 39)
        name_timeLabel.font = _globaluifont
        self.view.addSubview(name_timeLabel)
        //line
        var lineView3 = UIView(frame: CGRectMake(0, 189, width, 1))
        lineView3.backgroundColor = UIColor.grayColor()
        self.view.addSubview(lineView3)
        //atttachment File
        var attachmentLabel = UILabel(frame: CGRectMake(0, 190, 60, 39))
        attachmentLabel.text = " 附  件:"
        attachmentLabel.font = _globaluifont
        self.view.addSubview(attachmentLabel)
        attachmentBtn.frame =  CGRectMake(60, 190, width-60, 39)
        attachmentBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        attachmentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        attachmentBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        attachmentBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        attachmentBtn.addTarget(self, action: "attachmentBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(attachmentBtn)
        //line
        var lineView4 = UIView(frame: CGRectMake(0, 229, width, 1))
        lineView4.backgroundColor = UIColor.grayColor()
        self.view.addSubview(lineView4)
        //content
        contentWebView.frame =  CGRectMake(0, 230, width, height - 230)
        self.view.addSubview(contentWebView)
        
        attachmentWebView.frame = self.view.frame
        attachmentWebView.hidden = true
        var exitBtn = UIButton(frame: CGRectMake(width/2-50, height-50, 100, 30))
        exitBtn.backgroundColor = _globalBgcolor
        exitBtn.setTitle("退出", forState: UIControlState.Normal)
        exitBtn.addTarget(self, action: "exitBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        exitBtn.titleLabel?.font = _globaluifont
        attachmentWebView.addSubview(exitBtn)
        self.view.addSubview(attachmentWebView)
        
    }
    //MARK:BUTTON CLICK
    func backBtnClick(){
        var vc:NoticeViewController = NoticeViewController();
        vc.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func attachmentBtnClick(){
        if(self.btnName == ""){
            var alertview = UIAlertView(title: "提示", message: "无附件", delegate: self, cancelButtonTitle: "好")
            alertview.show()
        }else{
        var frameshow = self.view.frame
            self.attachmentWebView.hidden = false
            self.attachmentWebView.frame = frameshow
            var url:NSURL = NSURL(string: "http://\(_globaleIpstring):\(_globalPortstring)/Content/resources/uploadfile/MyAffairs/\(self.btnName)")!
            var request:NSURLRequest = NSURLRequest(URL: url)
            self.attachmentWebView.loadRequest(request)
    
        }
        
    }
    func exitBtnClick(){
        self.attachmentWebView.hidden = true

    }
    //MARK:didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
