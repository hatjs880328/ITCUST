//
//  AddYCYAViewController.swift
//  oa
//
//  Created by  on 15/3/20.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class AddYCYAViewController: UIViewController,UITextViewDelegate,UIAlertViewDelegate {
    //global params
    var width:CGFloat = 0
    var height:CGFloat = 0
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var receiverName = String()
    var checkerName = String()
    var receiverID = String()
    var checkerID = String()
    var selectDate = String()
    var content = String()
    //UI
    var timeBtn = UIButton(frame: CGRectZero)
    var userBtn = UIButton(frame: CGRectZero)
    var checkBtn = UIButton(frame: CGRectZero)
    var mainView = UIView(frame: CGRectZero)
    var datePick = UIDatePicker(frame: CGRectZero)
    var contentTextView = UITextView(frame: CGRectZero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        
    }
    override func viewDidAppear(animated: Bool) {
        navSetting()
        UISetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    //MARK:navSetting
    func navSetting(){
        width = self.view.bounds.size.width
        height = self.view.bounds.size.height
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        var titleLabel = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        titleLabel.text = "指令下达"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = _globaluifont
        navView.addSubview(titleLabel)
        //leftBtn
        var leftBtn = UIButton(frame: CGRectMake(10, 30, 20, 30))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        
        //rightBtn
        var rightBtn = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        rightBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "ycyasave.png"), forState: UIControlState.Normal)
        rightBtn.tag = 202
        navView.addSubview(rightBtn)
        
    }
    //MARK:navBtnClick
    func navBtnClick(sender:UIButton){
        if(sender.tag == 201){
            var vc = YCYAViewController()
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }else if(sender.tag == 202){
            content = contentTextView.text
            if(selectDate == ""){
                var alertview = UIAlertView(title: "系统提示", message: "请选择时间", delegate: self, cancelButtonTitle: "好")
                alertview.show()
                alertview.tag = 401
            }else if(receiverName == ""){
                var alertview = UIAlertView(title: "系统提示", message: "请选择执行人", delegate: self, cancelButtonTitle: "好")
                alertview.show()
                alertview.tag = 402
            }else if(checkerName == ""){
                var alertview = UIAlertView(title: "系统提示", message: "请选择检查人", delegate: self, cancelButtonTitle: "好")
                alertview.show()
                alertview.tag = 403
            }else if(content == "" || content == "请输入YCYA内容!"){
                var alertview = UIAlertView(title: "系统提示", message: "请输入内容", delegate: self, cancelButtonTitle: "好")
                alertview.show()
                alertview.tag = 404
            }else{
                let Parameters1 = ["random":"3","Instruction":"{\"RECEIVERID\":\"\(receiverID)\",\"CHECKERID\":\"\(checkerID)\",\"CONTENT\":\"\(content)\",\"COMPLETETIME\":\"\(selectDate)\"}","AttachmentList":""
                ]
                Alamofire.request(.POST,
                    "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/Add",
                    parameters: Parameters1)
                    .responseString{(request,response,string4,error) in
                        println(string4)
                        var mm = string4! as String
                        if(mm == "true"){
                            var alertview = UIAlertView(title: "系统提示", message: "保存成功", delegate: self, cancelButtonTitle: "好")
                            alertview.show()
                            alertview.tag = 405
                            alertview.delegate = self
                        }else{
                            var alertview = UIAlertView(title: "系统提示", message: "保存失败", delegate: self, cancelButtonTitle: "好")
                            alertview.show()
                            alertview.tag = 406
                            
                        }
                }
            }
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(alertView.tag == 405){
            var vc = YCYAViewController()
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:UI Setting
    func UISetting(){
        var timeLabel = UILabel(frame: CGRectMake(0, 80, width/4, 30))
        timeLabel.text = "完成时间:"
        timeLabel.font = _globaluifont
        timeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timeLabel)
        
        timeBtn.frame = CGRectMake(width/4, 80, width/4*3-10, 30)
        if(selectDate != ""){
            timeBtn.setTitle(selectDate, forState: UIControlState.Normal)
        }else{
            timeBtn.setTitle("请点击选择完成时间!", forState: UIControlState.Normal)
        }
        timeBtn.titleLabel?.font = _globaluifont
        timeBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        timeBtn.tag = 301
        timeBtn.addTarget(self, action: "selectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(timeBtn)
        var imgV = UIImageView(frame: CGRectMake(timeBtn.frame.width-40, 0, 40, 30))
        imgV.image = UIImage(named: "time.png")
        timeBtn.addSubview(imgV)
        
        
        var lineView1 = UIView(frame: CGRectMake(0, 119, width, 1))
        lineView1.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView1)
        
        var userLabel = UILabel(frame: CGRectMake(0, 130, width/4, 30))
        userLabel.text = "执行人:"
        userLabel.font = _globaluifont
        userLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(userLabel)
        
        userBtn.frame = CGRectMake(width/4, 130, width/4*3-10, 30)
        if(receiverName != ""){
            userBtn.setTitle(receiverName, forState: UIControlState.Normal)
            userBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }else{
            userBtn.setTitle("请点击选择执行人!", forState: UIControlState.Normal)
            userBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
        userBtn.titleLabel?.font = _globaluifont
        userBtn.tag = 302
        userBtn.addTarget(self, action: "selectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(userBtn)
        
        var lineView2 = UIView(frame: CGRectMake(0, 169, width, 1))
        lineView2.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView2)
        
        var checkLabel = UILabel(frame: CGRectMake(0, 180, width/4, 30))
        checkLabel.text = "检查人:"
        checkLabel.font = _globaluifont
        checkLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(checkLabel)
        
        checkBtn.frame = CGRectMake(width/4, 180, width/4*3-10, 30)
        if(checkerName != ""){
            checkBtn.setTitle(checkerName, forState: UIControlState.Normal)
        }else{
            checkBtn.setTitle("请点击选择检查人!", forState: UIControlState.Normal)
        }
        checkBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        checkBtn.titleLabel?.font = _globaluifont
        checkBtn.tag = 303
        checkBtn.addTarget(self, action: "selectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(checkBtn)
        
        var lineView3 = UIView(frame: CGRectMake(0, 219, width, 1))
        lineView3.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView3)
        
        contentTextView.frame =  CGRectMake(5, 225, width - 10, height - 230)
        if(content != ""){
            contentTextView.text = content
        }else{
            contentTextView.text = "请输入YCYA内容!"
        }
        contentTextView.font = _globaluifont
        contentTextView.textColor = UIColor.grayColor()
        contentTextView.font = UIFont.systemFontOfSize(16)
        contentTextView.delegate = self
//        var push = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//        //设置手势点击数,双击：点2下
//        push.numberOfTapsRequired = 2
//        contentTextView.addGestureRecognizer(push)
        self.view.addSubview(contentTextView)
        
        mainView.frame = CGRectMake(0, height-250, width, 250)
        mainView.backgroundColor = UIColor.whiteColor()
        mainView.hidden = true
        self.view.addSubview(mainView)
        
        datePick.frame = CGRectMake(0, 0, width, 216)
        datePick.datePickerMode = UIDatePickerMode.DateAndTime
        mainView.addSubview(datePick)
        
        var affirmBtn = UIButton(frame: CGRectMake(10, 216, width/2-15, 30))
        affirmBtn.setTitle("确认", forState: UIControlState.Normal)
        affirmBtn.addTarget(self, action: "selectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        affirmBtn.backgroundColor = bgcolorall
        affirmBtn.titleLabel?.font  = _globaluifont
        affirmBtn.tag = 304
        mainView.addSubview(affirmBtn)
        
        var cancelBtn = UIButton(frame: CGRectMake(width/2+5, 216, width/2-15, 30))
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.backgroundColor = bgcolorall
        cancelBtn.titleLabel?.font = _globaluifont
        cancelBtn.tag = 305
        cancelBtn.addTarget(self, action: "selectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        mainView.addSubview(cancelBtn)
    }
    //textView clear
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(contentTextView.text == "请输入YCYA内容!"){
            contentTextView.text = ""
        }
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    //MARK:select INFO
    func selectClick(sender:UIButton){
        if(sender.tag == 301){
            mainView.hidden = !mainView.hidden
        }else if(sender.tag == 302){
            //REVEIVER
            var con = selectUserController()
            con.modalTransitionStyle = _globalCustomviewchange
            con.personMark = 1
            con.nowCheckerName = checkerName
            con.nowCheckerID = checkerID
            con.nowSelectDate = selectDate
            con.nowReceiverName = receiverName
            con.nowReceiverID = receiverID
            con.nowContent = contentTextView.text
            self.presentViewController(con, animated: true, completion: nil)
            
        }else if(sender.tag == 303){
            //CHECKER
            var con = selectUserController()
            con.modalTransitionStyle = _globalCustomviewchange
            con.personMark = 2
            con.nowCheckerName = checkerName
            con.nowCheckerID = checkerID
            con.nowSelectDate = selectDate
            con.nowReceiverName = receiverName
            con.nowReceiverID = receiverID
            con.nowContent = contentTextView.text
            self.presentViewController(con, animated: true, completion: nil)
            
        }else if(sender.tag == 304){
            //time
            var date = datePick.date
            func stringWithFormat(_ format:String = "yyyy-MM-dd HH:mm:ss") -> String {
                var formatter = NSDateFormatter()
                formatter.dateFormat = format
                return formatter.stringFromDate(date)
            }
            selectDate = (stringWithFormat())
            timeBtn.setTitle(selectDate, forState: UIControlState.Normal)
            mainView.hidden = true
        }else if(sender.tag == 305){
            mainView.hidden = true
        }
    }
//    func handleTapGesture(sender:UITapGestureRecognizer){
// 
//        self.contentTextView.resignFirstResponder()
//    }
    //MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
