//
//  emailDetailinfoController.swift
//  oa
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class emailDetailinfoController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //params
    var id = ""
    var falg = 1
    var stringarr = [String]()
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var textarea = UIView(frame: CGRectZero)
    var lastview = UITableView(frame: CGRectZero)
    var midtableview = UITableView(frame: CGRectZero)
    
    var botview = UIView(frame: CGRectZero)
    var buttonleft = UIButton(frame: CGRectZero)
    var buttonmid = UIButton(frame: CGRectZero)
    var buttonmid1 = UIButton(frame: CGRectZero)
    var buttonright = UIButton(frame: CGRectZero)
    var arraylist:NSArray = []
    var dicmain:NSDictionary = NSDictionary()
    var path = ""
    var _webView = UIWebView(frame: CGRectZero)
    var button = UIButton(frame: CGRectMake(0, 0, 0, 0))
    var loaddataflag = 0

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
        if(falg == 1){
            loadData4("NbMail/NbMailAcceeptselectOne",id:"1",parameters5:["ID":"\(self.id)"])
        }else{
            loadData4("NbMail/NbMailSendselectOne",id:"3",parameters5:["ID":"\(self.id)"])
        }
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        gobackbutton()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING .
    func loadData4(url:String,id:String,parameters5:[String:AnyObject]){
        let Parameters3 = parameters5
        loaddataflag = 1
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/\(url)",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    if(id == "1" || id == "2"){
                        self.dicmain = jsonObject as NSDictionary
                        self.midtableview.reloadData()
                    }
                    if(id == "3"){
                        self.dicmain = jsonObject as NSDictionary
                        self.midtableview.reloadData()
                    }
                    self.loaddataflag = 0
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
        label.text = "邮件详情"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //right button
        let buttonright = UIButton(frame: CGRectMake(width - 40, 10, 30, 40))
        buttonright.setImage(UIImage(named: "emailxinzeng.png"), forState: UIControlState.Normal)
        buttonright.addTarget(self, action: "pressEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(buttonright)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20 - 40)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
        midTableviewSetting()
        botViewsetting()
    }
    
    func midTableviewSetting(){
        var frame = CGRectMake(0, 0, width, height - _globalNavviewHeight - 20 - 40)
        self.midtableview.frame = frame
        self.midtableview.delegate = self
        self.midtableview.dataSource = self
        self.midtableview.tag = 99
        self.midtableview.separatorColor = _globalBgcolor
        self.textarea.addSubview(midtableview)
    }
    
    func botViewsetting(){
        var frame = CGRectMake(0, height - 40, width, 40)
        botview.frame = frame
        botview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(botview)
        if(self.falg == 1){
        //left
        var k  = (width - 14)/4
        self.buttonleft.frame = CGRectMake(1, 5, k, 30)
        buttonleft.setTitle("回复", forState: UIControlState.Normal)
        buttonleft.backgroundColor = _globalBgcolor
        buttonleft.titleLabel?.font = _globaluifont
        buttonleft.layer.cornerRadius = 7
        buttonleft.addTarget(self, action: "pressleft:", forControlEvents: UIControlEvents.TouchUpInside)
        botview.addSubview(buttonleft)
        //mid1
        self.buttonmid.frame = CGRectMake(k + 5, 5, k, 30)
        buttonmid.setTitle("回复所有人", forState: UIControlState.Normal)
        buttonmid.backgroundColor = _globalBgcolor
        buttonmid.titleLabel?.font = _globaluifont
        buttonmid.layer.cornerRadius = 7
        buttonmid.addTarget(self, action: "pressmid:", forControlEvents: UIControlEvents.TouchUpInside)
        botview.addSubview(buttonmid)
        //mid2
        self.buttonmid1.frame = CGRectMake(2 * k + 9, 5, k, 30)
        buttonmid1.setTitle("转发", forState: UIControlState.Normal)
        buttonmid1.backgroundColor = _globalBgcolor
        buttonmid1.titleLabel?.font = _globaluifont
        buttonmid1.layer.cornerRadius = 7
        buttonmid1.addTarget(self, action: "pressmid1:", forControlEvents: UIControlEvents.TouchUpInside)
        botview.addSubview(buttonmid1)
        //right
        self.buttonright.frame = CGRectMake(width - k - 1, 5, k, 30)
        buttonright.setTitle("删除", forState: UIControlState.Normal)
        buttonright.backgroundColor = _globalBgcolor
        buttonright.titleLabel?.font = _globaluifont
        buttonright.layer.cornerRadius = 7
        buttonright.addTarget(self, action: "pressDeloneinfo:", forControlEvents: UIControlEvents.TouchUpInside)
        botview.addSubview(buttonright)
        }else{
            var delbutton = UIButton(frame: CGRectMake(width/2 - 100, 5, 200, 30))
            delbutton.setTitle("删除", forState: UIControlState.Normal)
            delbutton.titleLabel?.font = uifont2
            delbutton.layer.cornerRadius = 7
            delbutton.backgroundColor = _globalBgcolor
            delbutton.addTarget(self, action: "pressDeloneinfo:", forControlEvents: UIControlEvents.TouchUpInside)
            botview.addSubview(delbutton)
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 99){
            return 6
        }else{
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 99){
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "emaildetailinfotableivewcell")
            if(indexPath.row == 0){
                //acceptperson
                let label = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                var name = self.dicmain["ACCEPTREALNAME"] as? String!
                if(name != nil){
                label.text = "收件人：\(name!)"
                }
                label.font = uifont1
                cell.addSubview(label)
            }
            if(indexPath.row == 1){
                //others
                let label = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                var name = self.dicmain["CHAOSONGREALNAME"] as? String!
                if(name != nil){
                    label.text = "抄送人：\(name!)"
                }else{
                    label.text = "抄送人："
                }
                label.font = uifont1
                cell.addSubview(label)
            }
            if(indexPath.row == 2){
                //securt others
                let label = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                var name = self.dicmain["MISONGREALNAME"] as? String!
                if(name != nil){
                    label.text = "密送人：\(name!)"
                }else{
                    label.text = "密送人："
                }
                label.font = uifont1
                cell.addSubview(label)
            }
            if(indexPath.row == 3){
                //main theme
                let label = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                var name = self.dicmain["TITLE"] as? String!
                if(name != nil){
                label.text = "主题：\(name!)"
                }
                label.font = uifont1
                cell.addSubview(label)
            }
            if(indexPath.row == 4){
                //fj
                let label = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                var name = self.dicmain["KEYFIELD"] as? String!
                if(name! != nil){
                    let params = ["ID":"\(name!)"]
                    Alamofire.request(.POST,
                        "http://\(_globaleIpstring):\(_globalPortstring)/AddWorkFlow/getWorkFlowFJList",parameters: params)
                        .responseString{(request,response,string4,error) in
                            var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                            let jsonObject = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                            if(jsonObject.count > 0 ){
                                var idc = jsonObject[0] as NSDictionary
                                var name = idc["NAME"] as String
                                label.text = "附件：\(name)"
                                self.path = idc["NEWNAME"] as String
                                label.textColor = _globalBgcolor
                            }else{
                                label.text = "附件："
                            }
                    }
                }
                label.font = uifont1
                
                cell.addSubview(label)
            }
            if(indexPath.row == 5){
                //comment
                var content = self.dicmain["CONTENT"] as? String!
                let contentWebview = UIWebView(frame: CGRectMake(5, 5, width - 10, 200 - 10))
                if(content != nil){
                contentWebview.loadHTMLString("\(content!)", baseURL: nil)
                }
                cell.addSubview(contentWebview)
            }
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "emaildetailinfotableivewcell1")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 99){
            if(indexPath.row != 5){
                return 50
            }else{
                return 200
            }
        }else{
            return 50
        }
    }
    //show the fj
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 4){
            showwebView("55",id: "")
        }
    }
    
    //set all global params null
    func setAllnull(){
         nameall.removeAllObjects()
         idall.removeAllObjects()
         nameall1.removeAllObjects()
         idall1.removeAllObjects()
         nameall2.removeAllObjects()
         idall2.removeAllObjects()
    }
    
    func gobackbutton(){
        button.addTarget(self, action: "pressExit1:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("退出", forState: UIControlState.Normal)
        button.backgroundColor = _globalBgcolor
        button.alpha = 0.5
        button.layer.cornerRadius = 9
    }
    
    //MARK:ACTION BUTTONS.
    //show the _webview
    func showwebView(url3:String,id:String)->Void{
        if(url3 != "rrr")
        {
            let framebutton = CGRectMake(width/2 - 50, height - 55, 100, 25)
            let frame = CGRectMake(0, 0, width, height)
            var nsurl:NSURL = NSURL(string: "http://\(_globaleIpstring):\(_globalPortstring)/Content/resources/uploadfile/NbMail/\(self.path)")!
            var request:NSURLRequest = NSURLRequest(URL: nsurl)
            self._webView.loadRequest(request)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self._webView.frame = frame
                self._webView.scalesPageToFit = true
                self.button.frame = framebutton
                self.view.addSubview(self._webView)
                self.view.addSubview(self.button)
                }, completion: nil)
        }
    }
    func pressshowall(sender:UIButton){
        var con = emailController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressExit1(sender:UIButton){
        var frame = CGRectZero
        var framebutton = CGRectZero
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._webView.frame = frame
            self.button.frame = framebutton
            }, completion: nil)
    }
    
    func pressEdit(sender:UIButton){
        setAllnull()
        var con = postNewEmailController()
        con.flag = 0
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    
    
    func pressleft(sender:UIButton){
        //repeat one person
        setAllnull()
        var con = postNewEmailController()
        con.flag = 1
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressmid1(sender:UIButton){
        //repeat all
        setAllnull()
        var con = postNewEmailController()
        con.flag = 3
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressmid(sender:UIButton){
        //scro post
        setAllnull()
        var con = postNewEmailController()
        con.flag = 2
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //del info
    func pressDeloneinfo(sender:UIButton){
        var url = ""
        if(self.falg == 0){
            //post al.
            url = "InfoSpeech/NbMail/NbMailSendDelByID"
        }else{
            //read & no read
            url = "InfoSpeech/NbMail/NbMailAcceptUserUpdateDelBj"
        }
        //remember the "'"
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/\(url)",parameters: ["strItem":"'\(self.id)'","keyid":"sdaf"])
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    if(string4! != "true"){
                        var alert = UIAlertView(title: "提醒", message: "删除失败！", delegate: self, cancelButtonTitle: "好")
                        alert.show()
                        var con = emailController()
                        con.modalTransitionStyle = _globalCustomviewchange
                        self.presentViewController(con, animated: true, completion: nil)
                    }else{
                        var alert = UIAlertView(title: "提醒", message: "删除成功！", delegate: self, cancelButtonTitle: "好")
                        alert.show()
                        var con = emailController()
                        con.modalTransitionStyle = _globalCustomviewchange
                        self.presentViewController(con, animated: true, completion: nil)
                    }
                }
        }
    }
    

}
