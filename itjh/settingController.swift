//
//  settingController.swift
//  东正oa
//
//  Created by apple on 15/3/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

class settingController: UIViewController,UITextFieldDelegate {
    //global params
    let topblackview = UIView(frame: CGRectZero)
    let midview = UIView(frame: CGRectZero)
    let font1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var label = UITextField(frame: CGRectZero)
    var label1 = UITextField(frame: CGRectZero)
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        widthSetting()
        topviewSetting()
        midviewSetting()
        getdefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: WIDTH HEIGHT SETTING
    func widthSetting(){
        width = self.view.bounds.size.width
        height = self.view.bounds.size.height
    }
    
    //MARK: VIEW SETTING
    func topviewSetting(){
        var frame = CGRectMake(0, 0, width, 20)
        self.topblackview.frame = frame
        self.topblackview.backgroundColor = _globalBgcolor
        self.view.addSubview(topblackview)
    }
    
    func midviewSetting(){
        let frame = CGRectMake(0, 20, width, height-20)
        self.midview.frame = frame
        self.midview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(midview)
        //topview back
        let view4 = UIView(frame: CGRectMake(0, 0, width, 50))
        view4.backgroundColor = bgcolorall
            let buttonback = UIButton(frame: CGRectMake(10, 10, 20, 25))
            buttonback.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
            buttonback.addTarget(self, action: "pressback:", forControlEvents: UIControlEvents.TouchUpInside)
        view4.addSubview(buttonback)
            let label1 = UILabel(frame: CGRectMake(width/2-100, 10, 200, 25))
            label1.text = "服务器设置"
            label1.font = font1
        view4.addSubview(label1)
        self.midview.addSubview(view4)
        //ip & port
        //LOYGEC(outside view includes two small views)
        let midbigview = UIView(frame: CGRectMake(width/6, 120, width/3*2, 71))
        midbigview.backgroundColor = UIColor.whiteColor()
        midbigview.layer.cornerRadius = 10
        midbigview.layer.shadowColor = UIColor.blackColor().CGColor
        midbigview.layer.shadowOffset = CGSize(width: 2, height: 2)
        midbigview.layer.shadowRadius = 10
        midbigview.layer.shadowOpacity = 0.5
        self.midview.addSubview(midbigview)
        label = UITextField(frame: CGRectMake(0, 0, width/3*2, 35))
        label.delegate = self
        let leftpic = UILabel(frame: CGRectMake(3, 2, 50, 30))
        //leftpic.image = UIImage(named: "LASTREN-41.png")
        leftpic.text = "地址:"
        leftpic.font = _globaluifont
        leftpic.textAlignment = NSTextAlignment.Center
        label.leftView = leftpic
        label.tag = 1
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
        self.label1 = UITextField(frame: CGRectMake(0, 36, width/3*2, 35))
        self.label1.delegate = self
        self.label1.tag = 2
        let leftpic1 = UILabel(frame: CGRectMake(3, 2, 50, 30))
        leftpic1.text = "端口:"
        leftpic1.font = _globaluifont
        leftpic1.textAlignment = NSTextAlignment.Center
        //leftpic1.image = UIImage(named: "LASTSUO-41.png")
        self.label1.leftView = leftpic1
        self.label1.leftViewMode = UITextFieldViewMode.Always
        self.label1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.label1.backgroundColor = UIColor.whiteColor()
        self.label1.layer.cornerRadius = 7
        self.label1.text = "password"
        self.label1.textColor = colorall
        self.label1.font = font1
        midbigview.addSubview(label)
        midbigview.addSubview(self.label1)
        //login button && clear button
        let buttonlogin = UIButton(frame: CGRectMake(width/6, 250, width/3 - 5, 30))
        buttonlogin.addTarget(self, action: "presslogin:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonlogin.backgroundColor = _globalBgcolor
        buttonlogin.setTitle("保存", forState: UIControlState.Normal)
        buttonlogin.layer.cornerRadius = 7
        self.midview.addSubview(buttonlogin)
        let buttonclear = UIButton(frame: CGRectMake(width/2 + 5  , 250, width/3 - 5, 30
            ))
        buttonclear.addTarget(self, action: "pressclear:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonclear.backgroundColor = _globalBgcolor
        buttonclear.setTitle("清空", forState: UIControlState.Normal)
        buttonclear.layer.cornerRadius = 7
        self.midview.addSubview(buttonclear)
    }
    
    //MARK: nsuserdefault setting
    //interger
    func getdefault(){
        var m = NSUserDefaults.standardUserDefaults()
        if(m.objectForKey("myipaddress") != nil){
            var k = m.objectForKey("myipaddress") as String
            var m = m.objectForKey("myportaddress") as String
            self.label.text = k
            self.label1.text = m
        }
    }
    
    //MARK: ACTION (BUTTONS)
    func presslogin(sender:UIButton){
        var s = NSUserDefaults.standardUserDefaults()
        s.setObject(self.label.text, forKey: "myipaddress")
        s.setObject(self.label1.text, forKey: "myportaddress")
        s.synchronize()
        var alertview = UIAlertView(title: "提醒", message: "以保存！", delegate: self, cancelButtonTitle: "好")
        alertview.show()
    }
    
    func pressclear(sender:UIButton){
        println("...clear...")
        self.label.text = ""
        self.label1.text = ""
    }
    
    func pressback(sender:UIButton){
        println("...back...")
        var con = loginviewcontroller()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //press "return" resignfirstresponder
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        println("...return...")
        textField.resignFirstResponder()
        return true
    }
    
    //label should editing.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if(textField.tag == 1){
            self.label.text = ""
        }else{
            self.label1.text = ""
        }
        return true
    }
    
    //async exp:
    func asy(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //这里写需要一直执行的代码（2秒扫描一次数据库）
            for var i = 0 ; i > -1 && 0 == 0 ; i++ {
                sleep(4);
                //返回主线程跳转才可以成功（UI提示也只有在主线程中才会成功）
                dispatch_async(dispatch_get_main_queue(), {
                    println("这里返回主线程，写需要主线程执行的代码")
                    if(i%2 == 0){
                        //self.picTogglenow()
                    }else{
                        //self.picTogglelater()
                    }
                })
            }
        })
    }
    
}



