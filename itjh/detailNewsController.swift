//
//  detailNewsController.swift
//  oa
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class detailNewsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //global params
    var indexnow = "mystringtype"
    var textarea = UIWebView(frame: CGRectZero)
    var topView = UIView(frame: CGRectZero)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var width:CGFloat = 0
    var height:CGFloat = 0
    var stringarr = [String]()
    var _midbigView = UIView(frame: CGRectZero)
    var newsarrayCache = [NSDictionary]()
    var newsdetail:String?
    var frozenView = UIView(frame: CGRectZero)
    
    var titlelabel = UILabel(frame: CGRectZero)
    var postPerson = UILabel(frame: CGRectZero)
    var postCompany = UILabel(frame: CGRectZero)
    var fjlabel = UILabel(frame: CGRectZero)
    var FJ = UIButton(frame: CGRectZero)
    var _webView = UIWebView(frame: CGRectZero)
    var button = UIButton(frame: CGRectMake(0, 0, 0, 0))
    var path = ""
    var fjlb:NSArray = []
    var fjlbtableview = UITableView(frame: CGRectZero)

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
        loadData()
        gobackbutton()
        setFJLBtableview()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING START.
    func loadData(){
        let Parameters1 = [
            "id":"\(indexnow)"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/PublicAffairs/CompanyNews/CompanyNewsManageDetailPhoneOA",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    //cache
                    var dicone:NSDictionary = ["\(self.indexnow)":"\(nsdata)"]
                    self.newsarrayCache.append(dicone)
                    //method2
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSArray{
                        if let aStatus = statusesArray[0] as? NSDictionary{
                            //content if the machine is 5+ can display the pic if not ,it's can't
                            var content = aStatus["CONTENT"] as? String
                            if(_globalmachinetype == "5"){
                                var mm:NSMutableString = ""
                                mm.appendString(content!)
                                var aaa = detaillpic()
                                self.textarea.loadHTMLString("\(aaa.dothePic(mm))", baseURL: nil)
                            }else{
                                self.textarea.loadHTMLString("\(content!)", baseURL: nil)
                            }
                            //title NOWTIMES  REALNAME
                            var title = aStatus["TITLE"] as String
                            self.titlelabel.text = title
                            self.titlelabel.textAlignment = NSTextAlignment.Center
                            self.titlelabel.font = _globaluifont
                            //postPerson
                            var personinfo = aStatus["REALNAME"] as String
                            var time = aStatus["NOWTIMES"] as String
                            self.postPerson.text = "发布人：\(personinfo)     \(time)"
                            self.postPerson.font = _globaluifont
                            //POSTcom
                            var postCominfo = aStatus["UNITNAME"] as String
                            self.postCompany.text = "发布单位：\(postCominfo)"
                            self.postCompany.font = _globaluifont
                            //fj
                            var fj = aStatus["UNITNAME"] as String
                            var iffj = aStatus["KEYFIELD"] as String
                            println(iffj)
                            if(iffj != "[]"){
                                self.getJF(aStatus["KEYFIELD"] as String)
                            }else{
                                self.fjlabel.text = "附件："
                            }
                            self.fjlabel.font = _globaluifont
                            self.FJ.addTarget(self, action: "fjpress:", forControlEvents: UIControlEvents.TouchUpInside)

                        }
                    }
                }
        }
    }
    func topviewSetting(){
        let frame = CGRectMake(0, 0, width, 20)
        self.topView.frame = frame
        self.topView.backgroundColor = bgcolorall
        self.view.addSubview(topView)
    }
    
    //get fj.
    func getJF(name:String){
        let Parameters1 = [
            "KEYFIELD":"\(name)","TYPE":"2"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/CompanyNews/AttachmentList",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                println(string4!)
                if(string4 != nil && string4 != "[]"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    //method2
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSArray{
                        //first one
                        if let aStatus = statusesArray[0] as? NSDictionary{
                            var name = aStatus["OLDNAME"] as? String
                            self.path = name!
                            self.fjlabel.text = "附件：\(name!)"
                            self.fjlabel.textColor = _globalBgcolor
                        }
                        //get all fj
                        self.fjlb = statusesArray
                    }
                }else{
                    self.fjlabel.text = "附件："
                }
        }
    }
    
    func setFJLBtableview(){
        var frame = CGRectMake(10, 50, width - 20, height - 100)
        //self.fjlbtableview.frame = frame
        self.fjlbtableview.delegate = self
        self.fjlbtableview.dataSource = self
        self.fjlbtableview.separatorStyle = UITableViewCellSeparatorStyle.None
        self.fjlbtableview.layer.borderWidth = 1
        self.fjlbtableview.layer.borderColor = _globalBgcolor.CGColor
        self.view.addSubview(fjlbtableview)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.fjlb.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newdetailcontrollercell")
        if(indexPath.row != self.fjlb.count && self.fjlb.count != 0){
            var data = self.fjlb[indexPath.row] as NSDictionary
            cell.textLabel?.text = data["NEWNAME"] as? String
            cell.textLabel?.font = uifont1
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.textColor = _globalBgcolor
        }else{
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.fjlb.count != 0){
            var data = self.fjlb[indexPath.row] as NSDictionary
            self.path = data["NEWNAME"] as String
            showwebView("55",id: "")
        }
    }
    
    
    func WidthHeightSetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        stringarr.append("公告")
        stringarr.append("审批")
        stringarr.append("邮件")
        stringarr.append("通讯录")
        stringarr.append("分享")
        stringarr.append("ycya")
        stringarr.append("日结果")
        stringarr.append("发文")
        stringarr.append("新闻")
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "详细页面"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //frozenview
        var frame4 = CGRectMake(0, _globalNavviewHeight, width, 150)
        self.frozenView.frame = frame4
        self._midbigView.addSubview(self.frozenView)
        self.frozenView.backgroundColor = UIColor.whiteColor()
        frozenViewSetting()
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight+150, width, height-_globalNavviewHeight-170)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
    }
    //fj tableview
    func setfjTabel(){
        
    }
    
    //frozen tableview
    func frozenViewSetting(){
        var frame0 = CGRectMake(10, 0, width, 35)
        var frame1 = CGRectMake(10, 35, width, 35)
        var frame2 = CGRectMake(10, 70, width, 35)
        var frame3 = CGRectMake(10, 105, width, 35)
        
        var fg1 = UIView(frame: CGRectMake(0, 35, width, 1))
        fg1.backgroundColor = UIColor.blackColor()
        var fg2 = UIView(frame:CGRectMake(0, 70, width, 1))
        fg2.backgroundColor = UIColor.blackColor()
        var fg3 = UIView(frame: CGRectMake(0, 105, width, 1))
        fg3.backgroundColor = UIColor.blackColor()
        var fg4 = UIView(frame: CGRectMake(0, 140, width, 1))
        fg4.backgroundColor = UIColor.blackColor()
        
        self.titlelabel.frame = frame0
        self.postPerson.frame = frame1
        self.postCompany.frame = frame2
        self.fjlabel.frame = frame3
        //self.fjlabel.backgroundColor = UIColor.redColor()
        self.FJ.frame = frame3
        self.FJ.alpha = 0.1
        self.FJ.backgroundColor = UIColor.grayColor()
        
        self.frozenView.addSubview(fg1)
        self.frozenView.addSubview(fg2)
        self.frozenView.addSubview(fg3)
        self.frozenView.addSubview(fg4)
        
        self.frozenView.addSubview(titlelabel)
        self.frozenView.addSubview(postPerson)
        self.frozenView.addSubview(postCompany)
        self.frozenView.addSubview(FJ)
        self.frozenView.addSubview(fjlabel)
    }
    
    func gobackbutton(){
        button.addTarget(self, action: "pressExit:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("退出", forState: UIControlState.Normal)
        button.backgroundColor = _globalBgcolor
        button.alpha = 0.5
        button.layer.cornerRadius = 9
    }
    
    //MARK: ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = newsController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressExit(sender:UIButton){
        var frame = CGRectZero
        var framebutton = CGRectZero
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._webView.frame = frame
            self.button.frame = framebutton
            }, completion: nil)
    }
    
    //fj press
    func fjpress(sender:UIButton){
        //showwebView("55",id: "")
        if(self.fjlb.count != 0){
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.fjlbtableview.frame = CGRectMake(25, 100, self.width - 50, self.height - 200)
            }, completion: nil)
        }else{
            var alert = UIAlertView(title: "⚠警示", message: "无附件查看！", delegate: self, cancelButtonTitle: "好")
            alert.show()
        }
    }
    
    func showwebView(url3:String,id:String)->Void{
        
        UIView.animateWithDuration(0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.fjlbtableview.frame = CGRectZero
            }, completion: nil)
        
        if(url3 != "rrr")
        {
            let framebutton = CGRectMake(width/2 - 50, height - 55, 100, 25)
            let frame = CGRectMake(0, 0, width, height)
            //println(self.path)
            var nsurl:NSURL = NSURL(string: "http://\(_globaleIpstring):\(_globalPortstring)/Content/resources/uploadfile/PublicAffairs/\(self.path)")!
            var request:NSURLRequest = NSURLRequest(URL: nsurl)
            self._webView.loadRequest(request)
            self._webView.scalesPageToFit = true
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self._webView.frame = frame
                self.button.frame = framebutton
                self.view.addSubview(self._webView)
                self.view.addSubview(self.button)
                }, completion: nil)
        }
    }
    

    

}
