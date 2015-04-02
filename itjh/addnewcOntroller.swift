//
//  addnewcOntroller.swift
//  itjh
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit
import Alamofire

class addnewcOntroller: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var textarea = UIView(frame: CGRectZero)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    
    var labeltheme = UITextField(frame: CGRectZero)
    var labelcontent = UIImageView(frame: CGRectZero)
    var labelcontent1 = UILabel(frame: CGRectZero)
    var textareafield = UITextView(frame: CGRectZero)
    
    var table2 = UITableView(frame: CGRectZero)
    var arraydata:NSArray = []
    var fxID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        table1()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        label.text = "发分享"
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
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self.textarea.backgroundColor = UIColor.whiteColor()
        self._midbigView.addSubview(textarea)
        //MID TABLE VIEW START.
    }

    
    func table1(){
        var a:CGFloat = (CGFloat)(self.arraydata.count + 1)
        //println(a)
        var table1 = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, height - _globalNavviewHeight - 20))
        table1.tag = 1
        table1.delegate = self
        table1.dataSource = self
        self.textarea.addSubview(table1)
        table2 = UITableView(frame: CGRectMake(-width, 160, self.view.bounds.width, 250))
        table2.tag = 2
        table2.separatorColor = _globalBgcolor
        table2.layer.borderColor = _globalBgcolor.CGColor
        table2.layer.borderWidth = 1
        table2.delegate = self
        table2.dataSource = self
        self.view.addSubview(table2)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 1){
            return 3
        }else{
            return self.arraydata.count + 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 1){
            if(indexPath.row == 0 || indexPath.row == 1){
                return 35
            }else{
                return height - _globalNavviewHeight - 90
            }
        }else if(tableView.tag == 2){
            return 50
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if(tableView.tag == 1){
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "shareinfoaddControllerviewcell3")
            cell.selectionStyle = .None
            if(indexPath.row == 0){
                var theme = UILabel(frame: CGRectMake(5, 5, 100, 25))
                theme.font = _globaluifont
                theme.text = "分享主题:"
                cell.addSubview(theme)
                self.labeltheme.frame = CGRectMake(105, 5, width - 57, 25)
                self.labeltheme.text = ""
                self.labeltheme.delegate = self
                self.labeltheme.font = _globaluifont
                cell.addSubview(self.labeltheme)
                return cell
            }else if(indexPath.row == 1){
                var theme = UILabel(frame: CGRectMake(5, 5, 100, 25))
                theme.font = _globaluifont
                theme.text = "分享区:"
                cell.addSubview(theme)
                self.labelcontent1.frame = CGRectMake(105, 5, 100, 25)
                self.labelcontent1.font = _globaluifont
                cell.addSubview(self.labelcontent1)
                self.labelcontent.frame = CGRectMake(width - 57, 5, 25, 25)
                self.labelcontent.image = UIImage(named: "xinzeng.png")
                cell.backgroundColor = _globalgraycolor
                cell.addSubview(self.labelcontent)
                var button = UIButton(frame: CGRectMake(width - 57, 5, 25, 25))
                button.alpha = 0.1
                button.addTarget(self, action: "addperson:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(button)
                return cell
            }else if(indexPath.row == 2){
                self.textareafield.frame = CGRectMake(5, 5, width - 10, height - 90 - _globalNavviewHeight)
                self.textareafield.font = _globaluifont
                self.textareafield.textAlignment = NSTextAlignment.Justified
//                var push = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//                //设置手势点击数,双击：点2下
//                push.numberOfTapsRequired = 2
//                self.textareafield.addGestureRecognizer(push)
                cell.addSubview(textareafield)
                return cell
            }else{
                return cell
            }
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "sdfeasdflsdafj")
            var textlabel = UILabel(frame: CGRectMake(15, 15, 100, 25))
            if(indexPath.row != self.arraydata.count){
                var data = self.arraydata[indexPath.row] as NSDictionary
                textlabel.text = data["NAME"] as? String
                textlabel.font = uifont1
                cell.addSubview(textlabel)
                var switch3 = UISwitch(frame: CGRectMake(width - 165, 15, 30, 25))
                switch3.tag = indexPath.row
                switch3.addTarget(self, action: "switchvaluechange:", forControlEvents: UIControlEvents.ValueChanged)
                cell.addSubview(switch3)
            }else{
                var tllabel = UIButton(frame: CGRectMake(0, 15, width - 100, 25));                tllabel.setTitle("确定", forState: UIControlState.Normal)
                tllabel.titleLabel?.textAlignment = NSTextAlignment.Center
                tllabel.titleLabel?.font = uifont2
                tllabel.titleLabel?.textColor = UIColor.blackColor()
//                tllabel.backgroundColor = UIColor.yellowColor()
                tllabel.addTarget(self, action: "pressOK:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.backgroundColor = _globalgraycolor
                cell.addSubview(tllabel)
            }
            cell.selectionStyle = .None
            return cell
        }
    }
    
    //show hidden view
    func addperson(sender:UIButton){
        var frame = CGRectMake(50, 100, width - 100, 250)
        let Parameters3 = [
            "":""
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/GetShareAreas",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                if let statusesArray = jsonObject as? NSArray{
                    //println(statusesArray)
                    self.arraydata = statusesArray
                    self.table2.reloadData()
                    UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.table2.frame = frame
                        }, completion: nil)
                }
        }
    }
    
    func switchvaluechange(sender:UISwitch){
        var index = sender.tag
        var data = self.arraydata[index] as NSDictionary
        var id = data["ID"] as? String
        self.fxID = id!
    }
    
    func pressOK(sender:UIButton){
        var frame = CGRectMake(-width, 100, width - 100, 250)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.table2.frame = frame
            }, completion: nil)
    }
    
    func pressEdit(sender:UIButton){
        if(self.labeltheme.text != "" && self.textareafield.text != "" && self.fxID != ""){
            let Parameters3 = [
                "random":"4","WorkShare":"{\"ID\":\"\",\"SHARECONTENT\":\"\(self.textareafield.text)\",\"SHARETHEME\":\"\(self.labeltheme.text)\",\"SHAREAREAID\":\"\(self.fxID)\",\"ISDRAFT\":\"0\"}"
                ,"Reminded":"","remind":"0"
            ]
            Alamofire.request(.POST,
                "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/Published",parameters: Parameters3)
                .responseString{(request,response,string4,error) in
                    var mm = string4! as String
                    if(mm == "true"){
                        var alert = UIAlertView(title: "提醒", message: "分享成功！", delegate: self, cancelButtonTitle: "好")
                        alert.show()
                    }else{
                        var alert = UIAlertView(title: "提醒", message: "分享失败！", delegate: self, cancelButtonTitle: "好")
                        alert.show()
                    }
            }
        }
        else{
            var alert = UIAlertView(title: "提醒", message: "主题，分享区域，分享内容不能为空！", delegate: self, cancelButtonTitle: "好")
            alert.show()
        }
    }
    
    func pressshowall(sender:UIButton){
        var con = shareInfoController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
//    func handleTapGesture(sender:UITapGestureRecognizer){
//        println("push")
//        self.textareafield.resignFirstResponder()
//    }
    
    

}
