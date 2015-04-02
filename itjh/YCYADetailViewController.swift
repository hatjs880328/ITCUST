//
//  YCYADetailViewController.swift
//  oa
//
//  Created by  on 15/3/18.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class YCYADetailViewController: UIViewController,UITextViewDelegate,UIAlertViewDelegate {
    //global params
    var width:CGFloat = 0
    var height:CGFloat = 0
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var viewArr = [UIView]()
    var frontFlag :Int = 0
    var YCYAID:String?
    var dataDic:NSDictionary = NSDictionary()
    var isFinishItem1 = 0
    var isFinishItem2 = 0
    var isPunishItem = 0
    var isNewOrderItem = 0
    //UI
    var segement:UISegmentedControl = UISegmentedControl(items: ["指令内容","承诺","汇报","指令检查","完成确认"])
    var isFinishSeg1:UISegmentedControl = UISegmentedControl(items: ["未完成","完成"])
    var isFinishSeg2:UISegmentedControl = UISegmentedControl(items: ["未完成","完成"])
    var punishSegement:UISegmentedControl = UISegmentedControl(items: ["兑现自罚","免予处罚"])
    var orderSegement:UISegmentedControl = UISegmentedControl(items: ["继续承诺","取消指令"])
    var promiseTextView1 = UITextView(frame: CGRectZero)
    var promiseTextView2 = UITextView(frame: CGRectZero)
    var punishLabel = UILabel(frame: CGRectZero)
    var instructLabel = UILabel(frame: CGRectZero)
    var inspireLabel = UILabel(frame: CGRectZero)
    var inspireTextView = UITextView(frame: CGRectZero)
    var affirmLabel = UILabel(frame: CGRectZero)
    var affirmTextView = UITextView(frame: CGRectZero)
    var resultTextView = UITextView(frame: CGRectZero)
    var checkTextView = UITextView(frame: CGRectZero)
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
        let Parameters1 = ["id":self.YCYAID!
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Phone/MicroMis/GetInstructionByID",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                self.dataDic = result
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        navSetting()
        segementSetting()
        makeUI()
        self.view.bringSubviewToFront(viewArr[frontFlag])
        segement.selectedSegmentIndex = frontFlag
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    //MARK:UI Setting
    func makeUI(){
        //指令内容
        var v1 = UIView(frame: CGRectMake(0, 70, width, height - 100))
        v1.backgroundColor = UIColor.whiteColor()
        viewArr.append(v1)
        self.view.addSubview(v1)
        var timeLabel1 = UILabel(frame: CGRectMake(0, 10, width/4, 30))
        timeLabel1.text = "完成时间:"
        timeLabel1.textColor = UIColor.grayColor()
        timeLabel1.font = _globaluifont
        timeLabel1.textAlignment = NSTextAlignment.Center
        v1.addSubview(timeLabel1)
        var timeLabel2 = UILabel(frame: CGRectMake(width/4,10 , width/4*3, 30))
        timeLabel2.text = dataDic["COMPLETETIME"] as? String
        timeLabel2.font = _globaluifont
        timeLabel2.textAlignment = NSTextAlignment.Center
        v1.addSubview(timeLabel2)
        var lineView1 = UIView(frame: CGRectMake(width/4+5, 45, width/4*3-10, 1))
        lineView1.backgroundColor = UIColor.blackColor()
        v1.addSubview(lineView1)
        
        var clientLabel1 = UILabel(frame: CGRectMake(0, 51, width/4, 30))
        clientLabel1.textAlignment = NSTextAlignment.Center
        clientLabel1.text = "客户:"
        clientLabel1.textColor = UIColor.grayColor()
        clientLabel1.font = _globaluifont
        v1.addSubview(clientLabel1)
        var clientLabel2 = UILabel(frame: CGRectMake(width/4,51 , width/4*3, 30))
        if  var dic1 = dataDic["DirectorEmp"] as? NSDictionary{
            clientLabel2.text = dic1["RealName"] as? String!
        }
        clientLabel2.font = _globaluifont
        clientLabel2.textAlignment = NSTextAlignment.Center
        v1.addSubview(clientLabel2)
        var lineView2 = UIView(frame: CGRectMake(width/4+5, 86, width/4*3-10, 1))
        lineView2.backgroundColor = UIColor.blackColor()
        v1.addSubview(lineView2)
        
        var userLabel1 = UILabel(frame: CGRectMake(0, 92, width/4, 30))
        userLabel1.textAlignment = NSTextAlignment.Center
        userLabel1.text = "执行人:"
        userLabel1.textColor = UIColor.grayColor()
        userLabel1.font = _globaluifont
        v1.addSubview(userLabel1)
        var userLabel2 = UILabel(frame: CGRectMake(width/4,92 , width/4*3, 30))
        if var dic2 = dataDic["ReceiverEmp"] as? NSDictionary{
            userLabel2.text = dic2["RealName"] as? String!
        }
        userLabel2.font = _globaluifont
        userLabel2.textAlignment = NSTextAlignment.Center
        v1.addSubview(userLabel2)
        var lineView3 = UIView(frame: CGRectMake(width/4+5, 127, width/4*3-10, 1))
        lineView3.backgroundColor = UIColor.blackColor()
        v1.addSubview(lineView3)
        
        var checkLabel1 = UILabel(frame: CGRectMake(0, 133, width/4, 30))
        checkLabel1.textAlignment = NSTextAlignment.Center
        checkLabel1.text = "检查人:"
        checkLabel1.textColor = UIColor.grayColor()
        checkLabel1.font = _globaluifont
        v1.addSubview(checkLabel1)
        var checkLabel2 = UILabel(frame: CGRectMake(width/4,133 , width/4*3, 30))
        if var dic3 = dataDic["CheckerEmp"] as? NSDictionary{
            checkLabel2.text = dic3["RealName"] as? String!
        }
        checkLabel2.font = _globaluifont
        checkLabel2.textAlignment = NSTextAlignment.Center
        v1.addSubview(checkLabel2)
        var lineView4 = UIView(frame: CGRectMake(width/4+5, 169, width/4*3-10, 1))
        lineView4.backgroundColor = UIColor.blackColor()
        v1.addSubview(lineView4)
        
        var contentLabel = UILabel(frame: CGRectMake(0, 170, width/4, 30))
        contentLabel.textAlignment = NSTextAlignment.Center
        contentLabel.text = "YCYA内容:"
        contentLabel.textColor = UIColor.grayColor()
        contentLabel.font = _globaluifont
        v1.addSubview(contentLabel)
        
        var contentTextView = UITextView(frame: CGRectMake(width/4 + 10, 190, width/4*3-20, height - 340))
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = _globalBgcolor.CGColor
        contentTextView.text = dataDic["CONTENT"] as? String
        contentTextView.textColor = UIColor.lightGrayColor()
        contentTextView.font = _globaluifont
        contentTextView.editable = false
        v1.addSubview(contentTextView)
        //承诺
        var v2 = UIView(frame: CGRectMake(0, 70, width, height - 100))
        v2.backgroundColor = UIColor.whiteColor()
        viewArr.append(v2)
        self.view.addSubview(v2)
        
        var promiseLabel1 = UILabel(frame: CGRectMake(0, 10, width/4, 30))
        promiseLabel1.text = "承诺内容:"
        promiseLabel1.font = _globaluifont
        promiseLabel1.textAlignment = NSTextAlignment.Center
        v2.addSubview(promiseLabel1)
        
        
        promiseTextView1.frame = CGRectMake(width/4, 20, width/4*3-10, v2.frame.height/2 - 30)
        promiseTextView1.layer.borderWidth = 1
        promiseTextView1.layer.borderColor = _globalBgcolor.CGColor
        var promiseStr = dataDic["PROMISECONTENT"] as? String
        if(promiseStr != nil){
            promiseTextView1.text = promiseStr
        }else{
            promiseTextView1.text = "请输入..."
        }
        var receiverID = dataDic["RECEIVERID"] as? String
        var status = dataDic["STATUS"] as? Int
        if(receiverID == _globalUserID && status == 0){
            promiseTextView1.editable = true
            
        }else{
            promiseTextView1.editable = false
        }
        promiseTextView1.textColor = UIColor.lightGrayColor()
        promiseTextView1.font = _globaluifont
        promiseTextView1.delegate = self
        v2.addSubview(promiseTextView1)
        
        var promiseLabel2 = UILabel(frame: CGRectMake(0, v2.frame.height/2, width/4, 30))
        promiseLabel2.text = "承诺自罚:"
        promiseLabel2.textAlignment = NSTextAlignment.Center
        promiseLabel2.font = _globaluifont
        v2.addSubview(promiseLabel2)
        
        promiseTextView2.frame = CGRectMake(width/4, v2.frame.height/2, width/4*3-10, 40)
        promiseTextView2.layer.borderWidth = 1
        promiseTextView2.layer.borderColor = _globalBgcolor.CGColor
        
        if(receiverID == _globalUserID && status == 0){
            promiseTextView2.editable = true
        }else{
            promiseTextView2.editable = false
            
        }
        var selfStr = dataDic["SELFPUNISHSCORE"] as? String
        if(selfStr != nil){
            promiseTextView2.text = "\(selfStr!)"
        }else{
            promiseTextView2.text = "请输入..."
        }
        promiseTextView2.textColor = UIColor.lightGrayColor()
        promiseTextView2.font = _globaluifont
        promiseTextView2.delegate = self
        v2.addSubview(promiseTextView2)
        
        var v3 = UIView(frame: CGRectMake(0, 70, width, height - 100))
        v3.backgroundColor = UIColor.whiteColor()
        viewArr.append(v3)
        self.view.addSubview(v3)
        
        var caseLabel = UILabel(frame: CGRectMake(0, 20, width/4, 20))
        caseLabel.text = "完成情况:"
        caseLabel.textAlignment = NSTextAlignment.Center
        caseLabel.font = _globaluifont
        v3.addSubview(caseLabel)
        
        
        isFinishSeg1.frame = CGRectMake(width/4, 15, width/4*3-10, 30)
        isFinishSeg1.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        var isComplete = dataDic["ISCOMPLETE"] as? Int
        if(isComplete == 1){
            isFinishSeg1.selectedSegmentIndex = 1
        }else{
            isFinishSeg1.selectedSegmentIndex = 0
        }
        if(receiverID == _globalUserID && status == 1){
            isFinishSeg1.userInteractionEnabled = true
        }else{
            isFinishSeg1.userInteractionEnabled = false
        }
        isFinishSeg1.tag = 502
        v3.addSubview(isFinishSeg1)
        
        var resultLabel = UILabel(frame: CGRectMake(0, 70, width/4, 20))
        resultLabel.text = "汇报结果:"
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.font = _globaluifont
        v3.addSubview(resultLabel)
        
        resultTextView.frame = CGRectMake(width/4, 80, width/4*3-10, height-220)
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = _globalBgcolor.CGColor
        var resultStr = dataDic["WORKCONTENT"] as? String
        if(resultStr != nil){
            resultTextView.text = resultStr!
        }else{
            resultTextView.text = "请输入..."
        }
        if(receiverID == _globalUserID && status == 1){
            resultTextView.editable = true
        }else{
            resultTextView.editable = false
            
        }
        resultTextView.textColor = UIColor.lightGrayColor()
        resultTextView.font = _globaluifont
        resultTextView.delegate = self
        v3.addSubview(resultTextView)
        
        var v4 = UIView(frame: CGRectMake(0, 70, width, height - 100))
        v4.backgroundColor = UIColor.whiteColor()
        viewArr.append(v4)
        self.view.addSubview(v4)
        
        var checkLabel = UILabel(frame: CGRectMake(0, 10, width/4, 30))
        checkLabel.text = "检查结果:"
        checkLabel.textAlignment = NSTextAlignment.Center
        checkLabel.font = _globaluifont
        v4.addSubview(checkLabel)
        
        checkTextView.frame = CGRectMake(width/4, 20, width/4*3-10, height-220)
        checkTextView.layer.borderWidth = 1
        checkTextView.layer.borderColor = _globalBgcolor.CGColor
        var checkStr = dataDic["CHECKCONTENT"] as? String
        if(checkStr != nil){
            checkTextView.text = checkStr!
            checkTextView.editable = false
        }else{
            checkTextView.text = "请输入..."
            checkTextView.editable = true
        }
        var checkerID = dataDic["CHECKERID"] as? String
        if(checkerID == _globalUserID && status == 2){
            checkTextView.editable = true
        }else{
            checkTextView.editable = false
        }
        checkTextView.delegate = self
        checkTextView.textColor = UIColor.lightGrayColor()
        checkTextView.font = _globaluifont
        v4.addSubview(checkTextView)
        
        var v5 = UIView(frame: CGRectMake(0, 70, width, height - 100))
        v5.backgroundColor = UIColor.whiteColor()
        viewArr.append(v5)
        self.view.addSubview(v5)
        
        var finishLabel = UILabel(frame: CGRectMake(0, 20, width/4, 20))
        finishLabel.text = "完成情况:"
        finishLabel.font = _globaluifont
        finishLabel.textColor = UIColor.grayColor()
        finishLabel.textAlignment = NSTextAlignment.Center
        v5.addSubview(finishLabel)
        
        isFinishSeg2.frame = CGRectMake(width/4, 15, width/4*3-10, 30)
        isFinishSeg2.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        isFinishSeg2.tag = 503
        
        var isConfirmComplete = dataDic["ISCONFIRMCOMPLETE"] as? Int
        if(isConfirmComplete == 1){
            isFinishSeg2.selectedSegmentIndex = 1
        }else{
            isFinishSeg2.selectedSegmentIndex = 0
        }
        if(checkerID == _globalUserID && status == 3){
            isFinishSeg2.userInteractionEnabled = true
        }else{
            isFinishSeg2.userInteractionEnabled = false
        }
        v5.addSubview(isFinishSeg2)
        
        punishLabel.frame = CGRectMake(0, 70, width/4, 20)
        punishLabel.text = "处罚:"
        punishLabel.textAlignment = NSTextAlignment.Center
        punishLabel.textColor = UIColor.grayColor()
        punishLabel.font = _globaluifont
        v5.addSubview(punishLabel)
        
        
        punishSegement.frame = CGRectMake(width/4, 65, width/4*3-10, 30)
        punishSegement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        punishSegement.tag = 504
        var isPunish = dataDic["ISPUNISH"] as? Int
        if(isPunish == 1){
            punishSegement.selectedSegmentIndex = 1
        }else{
            punishSegement.selectedSegmentIndex = 0
        }
        if(checkerID == _globalUserID && status == 3){
            punishSegement.userInteractionEnabled = true
        }else{
            punishSegement.userInteractionEnabled = false
        }
        v5.addSubview(punishSegement)
        
        instructLabel.frame = CGRectMake(0, 120, width/4, 20)
        instructLabel.text = "指令:"
        instructLabel.textAlignment = NSTextAlignment.Center
        instructLabel.textColor = UIColor.grayColor()
        instructLabel.font = _globaluifont
        v5.addSubview(instructLabel)
        
        
        orderSegement.frame = CGRectMake(width/4, 115, width/4*3-10, 30)
        orderSegement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        orderSegement.tag = 505
        var isNewWorker = dataDic["ISNEWORDER"] as? Int
        if(isNewWorker == 1){
            orderSegement.selectedSegmentIndex = 1
        }else{
            orderSegement.selectedSegmentIndex = 0
        }
        if(checkerID == _globalUserID && status == 3){
            orderSegement.userInteractionEnabled = true
        }else{
            orderSegement.userInteractionEnabled = false
        }
        v5.addSubview(orderSegement)
        
        inspireLabel.frame = CGRectMake(0, 60, width / 4, 30)
        inspireLabel.text = "激励品牌分:"
        inspireLabel.font = _globaluifont
        inspireLabel.textColor = UIColor.grayColor()
        inspireLabel.textAlignment = NSTextAlignment.Center
        v5.addSubview(inspireLabel)
        
        inspireTextView.frame = CGRectMake(width/4, 60, width/4*3-10, 30)
        var score = dataDic["IMPELSCORE"] as? String
        if(score != nil){
            inspireTextView.text = "\(score!).0"
        }else{
            inspireTextView.text = "0"
        }
        if(checkerID == _globalUserID && status == 3){
            inspireTextView.editable = true
        }else{
            inspireTextView.editable = false
        }
        inspireTextView.delegate = self
        v5.addSubview(inspireTextView)
        
        affirmLabel.text = "确认意见:"
        affirmLabel.textAlignment = NSTextAlignment.Center
        affirmLabel.textColor = UIColor.grayColor()
        affirmLabel.font = _globaluifont
        v5.addSubview(affirmLabel)
        
        affirmTextView.layer.borderWidth = 1
        affirmTextView.layer.borderColor = _globalBgcolor.CGColor
        
        var affirmStr = dataDic["CONFIRMOPINION"] as? String
        if(affirmStr != nil){
            affirmTextView.text = affirmStr!
        }else{
            affirmTextView.text = "请输入..."
        }
        if(checkerID == _globalUserID && status == 3){
            affirmTextView.editable = true
        }else{
            affirmTextView.editable = false
        }
        affirmTextView.delegate = self
        affirmTextView.textColor = UIColor.lightGrayColor()
        affirmTextView.font = _globaluifont
        v5.addSubview(affirmTextView)
        
        if(isFinishSeg2.selectedSegmentIndex == 0){
            inspireLabel.hidden = true
            inspireTextView.hidden = true
            punishLabel.hidden = false
            punishSegement.hidden = false
            instructLabel.hidden = false
            orderSegement.hidden = false
            affirmLabel.frame = CGRectMake(0, 160, width/4, 20)
            affirmTextView.frame = CGRectMake(width/4, 180, width/4*3-10, height-180-50-100)
        }else{
            inspireLabel.hidden = false
            inspireTextView.hidden = false
            punishLabel.hidden = true
            punishSegement.hidden = true
            instructLabel.hidden = true
            orderSegement.hidden = true
            affirmLabel.frame = CGRectMake(0, 110, width/4, 20)
            affirmTextView.frame = CGRectMake(width/4, 120, width/4*3-10, height-120-50-100)
        }
    }
    //MARK:NavSetting
    func navSetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        //nav
        let navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview(navView)
        var label = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        label.text = "指令详情"
        label.textAlignment = NSTextAlignment.Center
        label.font = _globaluifont
        navView.addSubview(label)
        //leftBtn
        var leftBtn = UIButton(frame: CGRectMake(10, 30, 20, 30))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        //rightBtn
        var rightBtn = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        rightBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "save_and_send.png"), forState: UIControlState.Normal)
        rightBtn.tag = 202
        navView.addSubview(rightBtn)
    }
    //MARK:navBtn Click
    func navBtnClick(sender:UIButton){
        if(sender.tag == 201){
            var vc:YCYAViewController = YCYAViewController();
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }else if(sender.tag == 202){
            var status = dataDic["STATUS"] as? Int
            var receiverID = dataDic["RECEIVERID"] as? String
            var checkerID = dataDic["CHECKERID"] as? String
            if(status == 0 && receiverID == _globalUserID){
                //承诺
                if(promiseTextView1.text == "" || promiseTextView1.text == "请输入..."){
                    var alertview = UIAlertView(title: "系统提示", message: "请输入承诺内容", delegate: self, cancelButtonTitle: "好")
                    
                    alertview.show()
                }else if(promiseTextView2.text == "" || promiseTextView2.text == "请输入..."){
                    var alertview = UIAlertView(title: "系统提示", message: "请输入承诺自罚", delegate: self, cancelButtonTitle: "好")
                    alertview.show()
                }else{
                    status!++
                    let Parameters1 = ["operate":"UPDATEINSTRUCTION","Instruction":"{\"PROMISECONTENT\":\"\(promiseTextView1.text)\",\"SELFPUNISHSCORE\":\"\(promiseTextView2.text)\",\"Status\":\"1\"}"
                    ]
                    Alamofire.request(.POST,
                        "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/UpdateInstruction",
                        parameters: Parameters1)
                        .responseString{(request,response,string4,error) in
                             println("承诺:\(string4)")
                            var mm = string4! as String
                            if(mm == "true"){
                                
                                var alertview = UIAlertView(title: "系统提示", message: "更新成功", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                                alertview.tag = 401
                                alertview.delegate = self
                            }else{
                                var alertview = UIAlertView(title: "系统提示", message: "更新失败", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                            }
                    }
                }
            }else if(status == 1 && receiverID == _globalUserID){
                //汇报
                if(resultTextView.text == "" || resultTextView.text == "请输入..."){
                    var alertview = UIAlertView(title: "系统提示", message: "请输入汇报结果", delegate: self, cancelButtonTitle: "好")
                    alertview.show()
                }else{
                    status!++
                    let Parameters1 = ["operate":"UPDATEINSTRUCTION","Instruction":"{\"ISCOMPLETE\":\"\(isFinishItem1)\",\"WORKCONTENT\":\"\(resultTextView.text)\",\"Status\":\"\(status!)\"}"
                    ]
                    Alamofire.request(.POST,
                        "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/UpdateInstruction",
                        parameters: Parameters1)
                        .responseString{(request,response,string4,error) in
                             println("汇报:\(string4)")
                            var mm = string4! as String
                            if(mm == "true"){
                                
                                var alertview = UIAlertView(title: "系统提示", message: "更新成功", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                                alertview.tag = 402
                                alertview.delegate = self
                            }else{
                                var alertview = UIAlertView(title: "系统提示", message: "更新失败", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                            }                    }
                    
                }
            }else if(status == 2 && checkerID == _globalUserID){
                //检查
                if(checkTextView.text == "" || checkTextView.text == "请输入..."){
                    var alertview = UIAlertView(title: "系统提示", message: "请输入检查结果", delegate: self, cancelButtonTitle: "好")
                    alertview.show()
                }else{
                    status!++
                    let Parameters1 = ["operate":"UPDATEINSTRUCTION","Instruction":"{\"CHECKCONTENT\":\"\(checkTextView.text)\",\"Status\":\"\(status!)\"}"
                    ]
                    Alamofire.request(.POST,
                        "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/UpdateInstruction",
                        parameters: Parameters1)
                        .responseString{(request,response,string4,error) in
                               println("检查:\(string4)")
                            var mm = string4! as String
                            if(mm == "true"){
                                
                                var alertview = UIAlertView(title: "系统提示", message: "更新成功", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                                alertview.tag = 403
                                alertview.delegate = self
                            }else{
                                var alertview = UIAlertView(title: "系统提示", message: "更新失败", delegate: self, cancelButtonTitle: "好")
                                alertview.show()
                            }
                    }
                }
                
            }else if(status == 3 && checkerID == _globalUserID){
                //确认
                if(isFinishSeg2.selectedSegmentIndex == 1){
                    //完成
                    if(affirmTextView.text == "" || affirmTextView.text == "请输入..."){
                        var alertview = UIAlertView(title: "系统提示", message: "请输入确认意见", delegate: self, cancelButtonTitle: "好")
                    }else{
                        status!++
                        let Parameters1 = ["operate":"UPDATEINSTRUCTION","Instruction":"{\"IMPELSCORE\":\"\(inspireTextView.text)\",\"ISPUNISH\":\"0\",\"ISNEWORDER\":\"0\",\"ISCONFIRMCOMPLETE\":\"\(isFinishItem2)\",\"CONFIRMOPINION\":\"\(affirmTextView.text)\",\"Status\":\"\(status!)\"}"
                        ]
                        Alamofire.request(.POST,
                            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/UpdateInstruction",
                            parameters: Parameters1)
                            .responseString{(request,response,string4,error) in
                                 println("确认(完成):\(string4)")
                                var mm = string4! as String
                                if(mm == "true"){
                                    
                                    var alertview = UIAlertView(title: "系统提示", message: "更新成功", delegate: self, cancelButtonTitle: "好")
                                    alertview.show()
                                    alertview.tag = 404
                                    alertview.delegate = self
                                }else{
                                    var alertview = UIAlertView(title: "系统提示", message: "更新失败", delegate: self, cancelButtonTitle: "好")
                                    alertview.show()
                                }
                        }
                        
                    }
                }else{
                    //未完成
                    if(affirmTextView.text == "" || affirmTextView.text == "请输入..."){
                        var alertview = UIAlertView(title: "系统提示", message: "请输入确认意见", delegate: self, cancelButtonTitle: "好")
                    }else{
                        status!++
                        let Parameters1 = ["operate":"UPDATEINSTRUCTION","Instruction":"{\"ISPUNISH\":\"\(isPunishItem)\",\"ISNEWORDER\":\"\(isNewOrderItem)\",\"ISCONFIRMCOMPLETE\":\"\(isFinishItem2)\",\"CONFIRMOPINION\":\"\(affirmTextView.text)\",\"Status\":\"\(status!)\"}"
                        ]
                        Alamofire.request(.POST,
                            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/UpdateInstruction",
                            parameters: Parameters1)
                            .responseString{(request,response,string4,error) in
                                  println("确认(未完成):\(string4)")
                                var mm = string4! as String
                                if(mm == "true"){
                                    
                                    var alertview = UIAlertView(title: "系统提示", message: "更新成功", delegate: self, cancelButtonTitle: "好")
                                    alertview.show()
                                    alertview.tag = 405
                                    alertview.delegate = self
                                }else{
                                    var alertview = UIAlertView(title: "系统提示", message: "更新失败", delegate: self, cancelButtonTitle: "好")
                                    alertview.show()
                                }
                        }
                    }
                }
            }
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(alertView.tag >= 401 && alertView.tag <= 405 ){
            var vc = YCYAViewController()
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        
    }
    //textView clear
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    //MARK:segement
    func segementSetting(){
        segement.frame = CGRectMake(0, height - 30, width, 30)
        segement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        segement.selectedSegmentIndex = 0
        segement.tag = 501
        self.view.addSubview(segement)
    }
    func segementChange(sender:UISegmentedControl){
        if(sender.tag == 501){
            self.view.bringSubviewToFront(viewArr[segement.selectedSegmentIndex])
        }else if(sender.tag == 502){
            // isFinishSeg1
            isFinishItem1 = sender.selectedSegmentIndex
        }else if(sender.tag == 503){
            // isFinishSeg2
            isFinishItem2 = sender.selectedSegmentIndex
            if(sender.selectedSegmentIndex == 0){
                inspireLabel.hidden = true
                inspireTextView.hidden = true
                punishLabel.hidden = false
                punishSegement.hidden = false
                instructLabel.hidden = false
                orderSegement.hidden = false
                affirmLabel.frame = CGRectMake(0, 160, width/4, 20)
                affirmTextView.frame = CGRectMake(width/4, 180, width/4*3-10, height-180-50-100)
            }else{
                inspireLabel.hidden = false
                inspireTextView.hidden = false
                punishLabel.hidden = true
                punishSegement.hidden = true
                instructLabel.hidden = true
                orderSegement.hidden = true
                affirmLabel.frame = CGRectMake(0, 110, width/4, 20)
                affirmTextView.frame = CGRectMake(width/4, 120, width/4*3-10, height-120-50-100)
            }
        }else if(sender.tag == 504){
            //punishSegement
            isPunishItem = sender.selectedSegmentIndex
        }else if(sender.tag == 505){
            //orderSegement
            isNewOrderItem = sender.selectedSegmentIndex
        }
    }
    //MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
