//
//  loginviewcontroller.swift
//  oa
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class loginviewcontroller: UIViewController,UITextFieldDelegate {
    //global params
    let topblackview = UIView(frame: CGRectZero)
    let midview = UIView(frame: CGRectZero)
    let font1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var label = UITextField(frame: CGRectZero)
    var label1 = UITextField(frame: CGRectZero)
    var width:CGFloat = 0
    var height:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        widthSetting()
        topviewSetting()
        midviewSetting()
        labelSetting()
        ipAndportGetting()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: WIDTH HEIGHT SETTING
    func widthSetting(){
        width = self.view.bounds.size.width
        height = self.view.bounds.size.height
        if(height < 500){
            _globalmachinetype = "4"
        }else{
            _globalmachinetype = "5"
        }
        
    }
    
    //MARK: VIEW SETTING
    func topviewSetting(){
        var frame = CGRectMake(0, 0, width, 20)
        self.topblackview.frame = frame
        self.topblackview.backgroundColor = UIColor.clearColor()
        self.view.addSubview(topblackview)
    }
    
    func midviewSetting(){
        let frame = CGRectMake(0, 0, width, height)
        self.midview.frame = frame
        self.midview.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenpic")!)
        self.view.addSubview(midview)
        //sys icon
        let picview = UIView(frame: CGRectMake(width/2 - 60, 50, 120, 120))
        let picviewimageview = UIImageView(frame: CGRectMake(0, 0, 120, 120))
        picview.addSubview(picviewimageview)
        picviewimageview.image = UIImage(named: "dongzheng1(1).png")
        self.midview.addSubview(picview)
        picview.layer.cornerRadius = 10
        //sys content
        var contentLabel = UILabel(frame: CGRectMake(width/2 - 150, 200, 300, 20))
        contentLabel.text = "移动办公系统v1.0"
        contentLabel.backgroundColor = UIColor.clearColor()
        contentLabel.font = font1
        contentLabel.textAlignment = NSTextAlignment.Center
        self.midview.addSubview(contentLabel)
        //text label (name pwd)
        //LOYGEC(outside view includes two small views)
        let midbigview = UIView(frame: CGRectMake(width/6, 250, width/3*2, 71))
        midbigview.backgroundColor = UIColor.whiteColor()
        midbigview.layer.cornerRadius = 10
        midbigview.layer.shadowColor = UIColor.blackColor().CGColor
        midbigview.layer.shadowOffset = CGSize(width: 2, height: 2)
        midbigview.layer.shadowRadius = 10
        midbigview.layer.shadowOpacity = 0.5
        self.midview.addSubview(midbigview)
        label = UITextField(frame: CGRectMake(0, 0, width/3*2, 35))
        label.tag = 1
        label.delegate = self
        let leftpic = UIImageView(frame: CGRectMake(2, 2, 40, 30))
        leftpic.image = UIImage(named: "LASTREN-41.png")
        label.leftView = leftpic
        label.leftViewMode = UITextFieldViewMode.Always
        label.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        label.backgroundColor = UIColor.whiteColor()
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 5
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.cornerRadius = 7
        label.text = "username"
        label.textColor = colorall
        label.font = font1
        let midview2 = UIView(frame: CGRectMake(0, 35, width/3*2, 1))
        midview2.backgroundColor = colorall
        midbigview.addSubview(midview2)
        label1 = UITextField(frame: CGRectMake(0, 36, width/3*2, 35))
        label1.tag = 2
        label1.delegate = self
        let leftpic1 = UIImageView(frame: CGRectMake(2, 2, 40, 30))
        leftpic1.image = UIImage(named: "LASTSUO-41.png")
        label1.leftView = leftpic1
        label1.leftViewMode = UITextFieldViewMode.Always
        label1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        label1.backgroundColor = UIColor.whiteColor()
        label1.layer.cornerRadius = 7
        label1.text = "password"
        label1.textColor = colorall
        label1.font = font1
        midbigview.addSubview(label)
        midbigview.addSubview(label1)
        //memorise your pwd
        //login button && clear button
        let buttonlogin = UIButton(frame: CGRectMake(width/6, 350, width/3 - 5, 30))
        buttonlogin.addTarget(self, action: "presslogin:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonlogin.backgroundColor = _globalBgcolor
        buttonlogin.setTitle("登陆", forState: UIControlState.Normal)
        buttonlogin.layer.cornerRadius = 7
        self.midview.addSubview(buttonlogin)
        let buttonclear = UIButton(frame: CGRectMake(width/2 + 5 , 350, width/3 - 5, 30
            ))
        buttonclear.addTarget(self, action: "pressclear:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonclear.backgroundColor = _globalBgcolor
        buttonclear.setTitle("清空", forState: UIControlState.Normal)
        buttonclear.layer.cornerRadius = 7
        self.midview.addSubview(buttonclear)
        //setting icon
        let seticon = UIView(frame: CGRectMake(width/6*5-30, 420, 30, 30))
        let clpicview = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        clpicview.image = UIImage(named: "im_set_act.png")
        seticon.addSubview(clpicview)
        let buttoncl = UIButton(frame: CGRectMake(0, 0, 30, 30))
        buttoncl.alpha = 0.1
        seticon.addSubview(buttoncl)
        buttoncl.addTarget(self, action: "presssetting:", forControlEvents: UIControlEvents.TouchUpInside)
        self.midview.addSubview(seticon)
        //open or closed
        var switchbutton = UISwitch(frame: CGRectMake(width/6, 420, 50, 30))
        self.midview.addSubview(switchbutton)
        switchbutton.addTarget(self, action: "changeswitch:", forControlEvents: UIControlEvents.ValueChanged)
        var switchlabel = UILabel(frame: CGRectMake(width/6+52, 420, 100, 30))
        switchlabel.text = "记住密码"
        switchlabel.font = _globaluifont
        self.midview.addSubview(switchlabel)
    }
    
    //memorize ur name&pwd
    func labelSetting(){
        var m = NSUserDefaults.standardUserDefaults()
        if(m.objectForKey("loginname") != nil){
            var k = m.objectForKey("loginname") as String
            var m = m.objectForKey("loginpwd") as String
            self.label.text = k
            self.label1.text = m
        }
    }
    
    //MARK: ACTION ,(BUTTONS)
    func presslogin(sender:UIButton){
        //method1
        let Parameters1 = [
            "Account":"\(self.label.text)","Pwd":"\(self.label1.text)"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Login/CheckUserLogin",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 == "3"){
                    let con = mainController()
                    con.modalTransitionStyle = _globalCustomviewchange
                    self.presentViewController(con, animated: true, completion: nil)
                    self.loadUserID()
                    self.loadToday()
                    self.loadTomorrow()
                }else{
                    var alertview = UIAlertView(title: "提示", message: "登录失败", delegate: self, cancelButtonTitle: "好")
                    alertview.show()
                }
                if(string4 == "789"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                }
        }
    }
    
    func pressclear(sender:UIButton){
        self.label.text = ""
        self.label1.text = ""
    }
    
    func presssetting(sender:UIButton){
        var con = settingController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //press "return" resignfirstresponder
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //field should editing.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if(textField.tag == 1){
            self.label.text = ""
        }else{
            self.label1.text = ""
        }
        return true
    }
    
    //open or close
    func changeswitch(sender:UISwitch){
        if(sender.on){
            var s = NSUserDefaults.standardUserDefaults()
            s.setObject(self.label.text, forKey: "loginname")
            s.setObject(self.label1.text, forKey: "loginpwd")
            s.synchronize()
        }else{
            var s = NSUserDefaults.standardUserDefaults()
            s.setObject("username", forKey: "loginname")
            s.setObject("password", forKey: "loginpwd")
            s.synchronize()
        }
    }
    
    //MARK: IP & PORT GETTING.
    func ipAndportGetting(){
        var m = NSUserDefaults.standardUserDefaults()
        if(m.objectForKey("myipaddress") != nil){
            _globaleIpstring = m.objectForKey("myipaddress") as String
            _globalPortstring = m.objectForKey("myportaddress") as String
        }
    }
    
    func loadUserID(){
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Employee/GetUserID",
            parameters: ["":""])
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var str:NSString = string4!
                    if(str.length >= 3){
                        var range = NSMakeRange(1, str.length-2)
                        _globalUserID = str.substringWithRange(range)
                    }
                }
        }
    }
    func loadToday(){
        let Parameters1 = ["GetDate":"ToDay"]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Dayresult/GetCurrentTime",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                
                if(string4 != nil){
                    _globalToday = string4!
                }
        }
    }
    
    //the textfield should begin editting...
    func textFieldDidBeginEditing(textField: UITextField) {
        var frame = textField.frame;
        var offset:CGFloat = 120
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            if(offset > 0){
                self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height);
            }
            }, completion: nil)
    }
    //textfield should end editting..
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }, completion: nil)
    }
    
    func loadTomorrow(){
        let Parameters1 = ["GetDate":"TomorrowDay"]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Dayresult/GetCurrentTime",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    _globalTomorrow = string4!
                }
        }
    }
    
    

}
