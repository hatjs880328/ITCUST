//
//  AppendPlanViewController.swift
//  itjh
//
//  Created by huasu on 15/3/26.
//  Copyright (c) 2015 zwb. All rights reserved.
//

import UIKit
import Alamofire
class AppendPlanViewController: UIViewController,UIAlertViewDelegate,UITextFieldDelegate {
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
    var nowID = String()
    var nowDay = String()
    var segementItem = 0
    var selfItem = 0
    var receiverName = String()
    var receiverID = String()
    var workContent = String()
    var resultDefine = String()
    var promisePunish = String()
    //UI
    var nameBtn = UIButton(frame: CGRectZero)
    var segement:UISegmentedControl = UISegmentedControl(items: ["集团","公司","一级部门","二级部门"])
    var contentTF = UITextField(frame: CGRectZero)
    var resultTF = UITextField(frame: CGRectZero)
    var promiseTF = UITextField(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        urlParam = "Attention"
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
       
    }
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        navSetting()
        UISetting()
         MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
        titleLabel.text = "新增日计划"
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
        rightBtn.setBackgroundImage(UIImage(named: "save_and_send.png"), forState: UIControlState.Normal)
        rightBtn.tag = 202
        navView.addSubview(rightBtn)
    }
    //MARK:navBtnClick
    func navBtnClick(sender:UIButton){
        if(sender.tag == 201){
            var vc = MyPlanInfoViewController();
            vc.modalTransitionStyle = _globalCustomviewchange
            vc.nowUserID = self.nowID
            vc.selectedDay = self.nowDay
            vc.segementItem = self.segementItem
        
            self.presentViewController(vc, animated: true, completion: nil)
        }else if(sender.tag == 202){
            if(receiverName == ""){
                var alertview = UIAlertView(title: "系统提示", message: "请选择客户", delegate: self, cancelButtonTitle: "好")
                alertview.show()
            }else if(contentTF.text == "" || contentTF.text == "新增内容"){
                var alertview = UIAlertView(title: "系统提示", message: "工作内容不能为空", delegate: self, cancelButtonTitle: "好")
                alertview.show()
            }else if(resultTF.text == "" || contentTF.text == "结果定义"){
                var alertview = UIAlertView(title: "系统提示", message: "结果定义不能为空", delegate: self, cancelButtonTitle: "好")
                alertview.show()
            }else if(promiseTF.text == "" || promiseTF.text == "承诺自罚"){
                var alertview = UIAlertView(title: "系统提示", message: "承诺自罚不能为空", delegate: self, cancelButtonTitle: "好")
                alertview.show()
            }else{
                let Parameters1 = ["random":"3","data":"[{\"ID\":\"0\",\"WORKCONTENT\":\"\(contentTF.text)\",\"RESULTDEFINITION\":\"\(resultTF.text)\",\"CUSTOMERNAME\":{\"UserId\":\"\(receiverID)\"},\"PROMISESELFPUNISH\":\"\(promiseTF.text)\"}]","vr":"\(selfItem)","dayplanTime":"\(_globalTomorrow)"
                ]
                Alamofire.request(.POST,
                    "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Dayresult/SaveSomeDayPlans",
                    parameters: Parameters1)
                    .responseString{(request,response,string4,error) in
                        println(string4)
                        var mm = string4! as String
                        if(mm == "True"){
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
            var vc = MyPlanInfoViewController();
            vc.modalTransitionStyle = _globalCustomviewchange
            vc.nowUserID = self.nowID
            vc.selectedDay = self.nowDay
            vc.segementItem = self.segementItem
      
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func UISetting(){
        var nameLabel = UILabel(frame: CGRectMake(0, 80, width/4, 30))
        nameLabel.text = "客户名称:"
        nameLabel.font = _globaluifont
        nameLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nameLabel)
        
        nameBtn.frame = CGRectMake(width/4, 80, width/4*3-10, 30)
        
        if(receiverName != ""){
            nameBtn.setTitle(receiverName, forState: UIControlState.Normal)
            nameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }else{
            nameBtn.setTitle("请点击选择客户!", forState: UIControlState.Normal)
            nameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }

        nameBtn.titleLabel?.font = _globaluifont
        nameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        nameBtn.tag = 301
        nameBtn.addTarget(self, action: "selectClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(nameBtn)
        var imgV = UIImageView(frame: CGRectMake(nameBtn.frame.width-40, 0, 40, 30))
        imgV.image = UIImage(named: "xinzeng")
        nameBtn.addSubview(imgV)
        
        var lineView1 = UIView(frame: CGRectMake(0, 119, width, 1))
        lineView1.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView1)

        var rangeLabel = UILabel(frame: CGRectMake(0, 130, width/4, 30))
        rangeLabel.text = "可见范围:"
        rangeLabel.font = _globaluifont
        rangeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(rangeLabel)
        
        segement.frame = CGRectMake(width/4, 130, width/4*3-10, 30)
        segement.selectedSegmentIndex = selfItem
        segement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(segement)
        
        var lineView2 = UIView(frame: CGRectMake(0, 169, width, 1))
        lineView2.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView2)
        
        var contentLabel = UILabel(frame: CGRectMake(0, 180, width/4, 30))
        contentLabel.text = "工作内容:"
        contentLabel.font = _globaluifont
        contentLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(contentLabel)
        
        contentTF.frame = CGRectMake(width/4, 180, width/4*3-10, 30)
        contentTF.placeholder = "新增内容"
        if(workContent != ""){
            contentTF.text = workContent
        }
        contentTF.font = _globaluifont
        contentTF.tag = 101
        contentTF.delegate = self
        contentTF.clearButtonMode = UITextFieldViewMode.WhileEditing
        contentTF.returnKeyType = UIReturnKeyType.Done
        self.view.addSubview(contentTF)
        
        var lineView3 = UIView(frame: CGRectMake(0, 219, width, 1))
        lineView3.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView3)
        
        var resultLabel = UILabel(frame: CGRectMake(0, 230, width/4, 30))
        resultLabel.text = "结果定义:"
        resultLabel.font = _globaluifont
        resultLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(resultLabel)
        
        resultTF.frame = CGRectMake(width/4, 230, width/4*3-10, 30)
        resultTF.placeholder = "结果定义"
        resultTF.clearButtonMode = UITextFieldViewMode.WhileEditing
        resultTF.returnKeyType = UIReturnKeyType.Done
        if(resultDefine != ""){
            resultTF.text = resultDefine
        }
        resultTF.font = _globaluifont
        resultTF.tag = 102
        resultTF.delegate = self
        self.view.addSubview(resultTF)
        
        var lineView4 = UIView(frame: CGRectMake(0, 269, width, 1))
        lineView4.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView4)
        
        var promiseLabel = UILabel(frame: CGRectMake(0, 280, width/4, 30))
        promiseLabel.text = "承诺自罚:"
        promiseLabel.font = _globaluifont
        promiseLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(promiseLabel)
        
        promiseTF.frame = CGRectMake(width/4, 280, width/4*3-10, 30)
        promiseTF.placeholder = "承诺自罚"
        promiseTF.clearButtonMode = UITextFieldViewMode.WhileEditing
        if(promisePunish != ""){
            promiseTF.text = promisePunish
        }
        promiseTF.font = _globaluifont
        promiseTF.delegate = self
        promiseTF.keyboardType = UIKeyboardType.NumbersAndPunctuation
        promiseTF.returnKeyType = UIReturnKeyType.Done
        self.view.addSubview(promiseTF)
        var lineView5 = UIView(frame: CGRectMake(0, 319, width, 1))
        lineView5.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView5)
    }
    func selectClick(){
          var con = selectCustomerViewController()
            con.modalTransitionStyle = _globalCustomviewchange
            con.nowSelectedName = receiverName
            con.nowContent = contentTF.text
            con.nowResult = resultTF.text
            con.nowPromise = promiseTF.text
            con.nowSelectedID = receiverID
            con.nowSegementItem = selfItem
        
           con.nowUserID = self.nowID
           con.selectedDay = self.nowDay
           con.plan_resultItem = self.segementItem
    
            self.presentViewController(con, animated: true, completion: nil)
    }
    func segementChange(sender:UISegmentedControl){
        selfItem = segement.selectedSegmentIndex
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
