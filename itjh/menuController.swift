//
//  menuController.swift
//  oa
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class menuController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    //global params
    var menuFlag = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var textarea = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var searchview = UIView(frame: CGRectZero)
    var lefttableview = UITableView(frame: CGRectZero)
    var righttableview = UITableView(frame: CGRectZero)
    var searchtext = UITextField(frame: CGRectZero)
    var arraylist:NSArray = []
    var namelist = [String]()
    var arraylist0:NSArray = []
    var namelistxing = [Int]()
    var arraylist1 = [NSDictionary]()
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    //lefttableiview
    var arraylistleft:NSArray = []
    var arraylist2 = [NSDictionary]()
    var lastview = UITableView(frame: CGRectZero)
    var stringarr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        WidthHeightSetting()
        topviewSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        midviewSetting()
        loadData()
        loaddataLefttableview()
        hidtableview()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING START.
    func hidtableview(){
        lastview.frame = CGRectMake(0,0,0,0)
        lastview.tag = 20
        lastview.delegate = self
        lastview.dataSource  = self
        lastview.layer.borderColor = bgcolorall.CGColor
        lastview.layer.borderWidth = 1
        self._midbigView.addSubview(lastview)
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.lastview.addGestureRecognizer(swipeLeftGesture)
    }
    
    func loadData(){
        let Parameters1 = [
            "":""
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Phone/Common/GetUserList",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSArray{
                        self.arraylist = statusesArray
                        self.arraylist0 = statusesArray
                        //sco add the name to the namelist[string]
                        for (var i = 0 ; i < self.arraylist0.count ; i++){
                            var data = self.arraylist0[i] as NSDictionary
                            self.namelist.append(data["UserName"] as String)
                        }
                        //println(self.namelist)
                        self.righttableview.reloadData()
                    }
                }
        }
    }
    
    func loaddataLefttableview(){
        let Parameters1 = [
            "":""
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Phone/Common/GetDepartmentlist",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSArray{
                        self.arraylistleft = statusesArray
                        self.lefttableview.reloadData()
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
        label.text = "通讯录"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
        
        textareaViewSetting()
    }
    
    func textareaViewSetting(){
        //search view
        var frame = CGRectMake(0, 0, width, 35)
        searchview.frame = frame
        self.textarea.addSubview(searchview)
        self.searchview.backgroundColor = _globalgraycolor
        var searchframe = CGRectMake(2, 2, width - 4, 31)
        self.searchtext.frame = searchframe
        self.searchtext.text = "search"
        self.searchtext.tag = 3
        self.searchtext.delegate = self
        self.searchtext.layer.cornerRadius = 7
        self.searchtext.backgroundColor = UIColor.whiteColor()
        let leftpic = UIImageView(frame: CGRectMake(12, 3, 28, 23))
        leftpic.image = UIImage(named: "im_search.png")
        searchtext.leftView = leftpic
        searchtext.leftViewMode = UITextFieldViewMode.Always
        searchtext.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.searchview.addSubview(searchtext)
        //left tableview 1/3
        var frameleft = CGRectMake(0, 35, width/3, height - 55 - _globalNavviewHeight)
        self.lefttableview.frame = frameleft
        self.lefttableview.tag = 1
        self.lefttableview.dataSource = self
        self.lefttableview.delegate = self
        self.lefttableview.separatorColor = bgcolorall
        self.textarea.addSubview(lefttableview)
        //right tableview 2/3
        var rightframe = CGRectMake(width/3, 35, width/3*2, height - 55 - _globalNavviewHeight)
        self.righttableview.frame = rightframe
        self.righttableview.tag = 2
        self.righttableview.dataSource = self
        self.righttableview.delegate = self
        self.righttableview.separatorColor = bgcolorall
        self.textarea.addSubview(righttableview)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 2){
            return arraylist.count
        }else if(tableView.tag == 20){
            return 11
        }
        else{
            return arraylistleft.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 2){
            var iddata = self.arraylist[indexPath.row] as NSDictionary
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "menuTableviewCell")
            let touxiangimage = UIImageView(frame: CGRectMake(1, 10, 30, 30))
            touxiangimage.image = UIImage(named: "info_act.png")
            cell.addSubview(touxiangimage)
            let namelabel = UILabel(frame: CGRectMake(32, 10, width/3, 25))
            let tellabel = UILabel(frame: CGRectMake(32, 36, width/3, 25))
            namelabel.font = uifont1
            var name: AnyObject? = iddata["UserName"]
            namelabel.text = "\(name!)"
            tellabel.font = uifont1
            var number:AnyObject? = iddata["PhoneNumber"]
            tellabel.text = "tel:\(number!)"
            cell.addSubview(namelabel)
            cell.addSubview(tellabel)
            let telbutton = UIButton(frame: CGRectMake(33 + width/3, 6, 48, 48))
                telbutton.tag = 1000 + indexPath.row
            let infobutton = UIButton(frame: CGRectMake(65 + width/3, 6, 48, 48))
                infobutton.tag = 2000 + indexPath.row
            telbutton.backgroundColor = UIColor(patternImage: UIImage(named: "adbooksend.png")!)
            telbutton.addTarget(self, action: "presstelphone:", forControlEvents: UIControlEvents.TouchUpInside)
            infobutton.backgroundColor = UIColor(patternImage: UIImage(named: "adbookinfo.png")!)
            infobutton.addTarget(self, action: "presstelinfo:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(telbutton)
            cell.addSubview(infobutton)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.layer.borderColor = bgcolorall.CGColor
            cell.layer.borderWidth = 0
            return cell
        }else if(tableView.tag == 20){
            var cell1 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell")
            let labeltitle = UILabel(frame: CGRectMake(45, 5, self.width/3*2, 20))
            let buttons = UIImageView(frame: CGRectMake(5, 5, 30, 30))
            if(indexPath.row == 0){
                labeltitle.text = "ourself"
                labeltitle.font = uifont2
                cell1.addSubview(labeltitle)
                buttons.image = UIImage(named: "info_act.png")
                cell1.addSubview(buttons)
            }else if(indexPath.row < 10){
                labeltitle.text = stringarr[indexPath.row - 1]
                labeltitle.font = _globaluifont
                cell1.addSubview(labeltitle)
                buttons.image = UIImage(named: "gonggao\(indexPath.row).png")
                cell1.addSubview(buttons)
            }else if(indexPath.row == 10){
                labeltitle.text = "返回首页"
                labeltitle.font = uifont2
                cell1.backgroundColor = bgcolorall
                cell1.addSubview(labeltitle)
            }
            return cell1
        }
        else{
            var indexdata = self.arraylistleft[indexPath.row] as NSDictionary
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "menuTableviewCell")
            cell.textLabel?.text = indexdata["DeaprtmentName"] as? String
            cell.textLabel?.font = uifont1
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 2){
            return 60
        }else if(tableView.tag == 20){
            return 50
        }
        else{
            return 40
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 1){
            self.arraylist2.removeAll(keepCapacity: true)
            var data = arraylistleft[indexPath.row] as NSDictionary
            var departmentId = data["DepartmentID"] as String
            
            var newdata:NSDictionary
            for (var i = 0 ;i < arraylist0.count;i++){
                newdata = arraylist0[i] as NSDictionary
                if(newdata["DepartmentID"] as? String == departmentId){
                    arraylist2.append(newdata)
                }
            }
            self.arraylist = self.arraylist2
            println(arraylist2.count)
            self.righttableview.reloadData()
        }else if(tableView.tag == 20){
            jumpothersPage(indexPath.row)
        }
    }
    
    //MARK:ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        if(menuFlag == 0){
            var frameshow = CGRectMake(0, 70, 150, height-130)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.lastview.frame = frameshow
                self.menuFlag = 1
                }, completion: nil)
        }else if(menuFlag == 1){
            var frameshow = CGRectMake(-150, 70, 150, height-130)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.lastview.frame = frameshow
                self.menuFlag = 0
                }, completion: nil)
            
        }

    }
    
    //tableview left swap
    func midscrollright(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 70, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            self.menuFlag = 0
            }, completion: nil)
    }
    
    func jumpMainview(){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //go call
    func presstelphone(sender:UIButton){
        var index = sender.tag - 1000
        var indexdata = self.arraylist[index] as NSDictionary
        //println(indexdata)
        if var phonenumber = indexdata["PhoneNumber"] as? NSString {
            //println(phonenumber)
            if(phonenumber != "" && phonenumber != "<null>" && phonenumber != "&nbsp;"){
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phonenumber)")!)
            }
        }
    }
    
    //send message
    func presstelinfo(sender:UIButton){
        var index = sender.tag - 2000
        var indexdata = self.arraylist[index] as NSDictionary
        //println(indexdata)
        if var phonenumber = indexdata["PhoneNumber"] as? NSString {
            if(phonenumber != "" && phonenumber != "<null>" && phonenumber != "&nbsp;"){
                UIApplication.sharedApplication().openURL(NSURL(string: "sms://\(phonenumber)")!)
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        println("start")
        if(textField.tag == 3){
            //textField.becomeFirstResponder()
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.namelistxing.removeAll(keepCapacity: false)
        self.arraylist1.removeAll(keepCapacity: false)
        println(self.namelistxing)
        var text = self.searchtext.text as String
        //search first name 0(no change)
        if(text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0){
            println("0")
            self.arraylist = self.arraylist0
            self.righttableview.reloadData()
        }
        //search first name 1
        else if(text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 3){
            var index = 0
            for (var i = 0 ; i < self.namelist.count ; i++){
                var name = (self.namelist[i] as String) as NSString
                var name1 = name.substringToIndex(1)
                if(text == name1){
                    self.namelistxing.append(i)
                }else{
                    
                }
            }
            for (var i = 0 ; i < self.namelistxing.count ; i++){
                var dic = arraylist0[namelistxing[i]] as NSDictionary
                arraylist1.append(dic)
            }
            self.arraylist = self.arraylist1
            self.righttableview.reloadData()
        }
        //search first name 2
        else if (text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 6){
            var index = 0
            for (var i = 0 ; i < self.namelist.count ; i++){
                var name = (self.namelist[i] as String) as NSString
                var name1 = name.substringToIndex(2)
                println(name1)
                if(text == name1){
                    self.namelistxing.append(i)
                }else{
                    
                }
            }
            for (var i = 0 ; i < self.namelistxing.count ; i++){
                var dic = arraylist0[namelistxing[i]] as NSDictionary
                arraylist1.append(dic)
            }
            self.arraylist = self.arraylist1
            self.righttableview.reloadData()
        }
        //search first name 3
        else if(text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 9){
            var index = 0
            for (var i = 0 ; i < self.namelist.count ; i++){
                var name = (self.namelist[i] as String) as NSString
                if(name.length >= 3){
                    var name1 = name.substringToIndex(3)
                    if(text == name1){
                        self.namelistxing.append(i)
                    }else{
                        
                    }
                }
            }
            for (var i = 0 ; i < self.namelistxing.count ; i++){
                var dic = arraylist0[namelistxing[i]] as NSDictionary
                arraylist1.append(dic)
            }
            self.arraylist = self.arraylist1
            self.righttableview.reloadData()
        }
        return true
    }
    
    func jumpothersPage(ind:Int){
        var con:UIViewController = UIViewController()
        if(ind == 0){
            con = userInfoController()
        }
        if(ind == 1){
            con = NoticeViewController()
        }
        if(ind == 2){
            con = approveController()
        }
        if(ind == 3){
            con = emailController()
        }
        if(ind == 4){
            con = menuController()
        }
        if(ind == 5){
            con = shareInfoController()
        }
        if(ind == 6){
            con = YCYAViewController()
        }
        if(ind == 7){
            con = ResultViewController()
        }
        if(ind == 8){
            con = postArticleController()
        }
        if(ind == 9){
            con = newsController()
        }
        if(ind == 10){
            con = mainController()
            
        }
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
}

