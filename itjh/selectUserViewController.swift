//
//  selectUserViewController.swift
//  itjh
//
//  Created by  on 15/3/23.
//  Copyright (c) 2015 zwb. All rights reserved.
//

import UIKit
import Alamofire

class selectUserController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    //global params
    var flag = 0
    var personMark = 0
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
    var eachID = ""
    var allID:NSMutableArray = []
    //
    var nowReceiverName = String()
    var nowCheckerName = String()
    var nowReceiverID = String()
    var nowCheckerID = String()
    var nowSelectDate = String()
    var nowContent = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        WidthHeightSetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        topviewSetting()
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
        //self._midbigView.addSubview(lastview)
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
        label.text = "可选人员"
        label.textAlignment = NSTextAlignment.Center
        label.font = _globaluifont
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
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
        self.searchview.backgroundColor = UIColor.grayColor()
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
            let telbutton = UIButton(frame: CGRectMake(width/3*2 - 35, 14, 32, 32))
            telbutton.tag = 1000 + indexPath.row
            telbutton.backgroundColor = UIColor(patternImage: UIImage(named: "im_unselect.png")!)
            telbutton.addTarget(self, action: "press443:", forControlEvents: UIControlEvents.TouchUpInside)
            var titleid = iddata["UserID"] as? String
            var  titlename = iddata["UserName"] as? String
            telbutton.titleLabel?.text = "\(titleid!)~\(titlename!)"
            cell.addSubview(telbutton)
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
            self.righttableview.reloadData()
        }else if(tableView.tag == 20){
            switch(indexPath.row){
            case 0:(println("0"),println("..."))
            case 1:println("1")
            case 2:println("2")
            case 3:println("3")
            case 4:println("4")
            case 5:println("5")
            case 6:println("6")
            case 7:println("7")
            case 8:println("8")
            case 9:println("9")
            case 10:jumpMainview()
            default:()
            }
        }else if(tableView.tag == 2){
            var iddata = self.arraylist[indexPath.row] as NSDictionary
           var con = AddYCYAViewController()
            con.modalTransitionStyle = _globalCustomviewchange
            if(personMark == 1){
                con.receiverName = iddata["UserName"] as String
                con.receiverID = iddata["UserID"] as String
                con.selectDate = nowSelectDate
                con.checkerName = nowCheckerName
                con.checkerID = nowCheckerID
                con.content = nowContent
            }else if(personMark == 2){
                con.checkerName = iddata["UserName"] as String
                con.checkerID = iddata["UserID"] as String
                con.receiverName = nowReceiverName
                con.receiverID = nowReceiverID
                con.selectDate = nowSelectDate
                con.content = nowContent
            }
            self.presentViewController(con, animated: true, completion: nil)

        }
    }
    
    //MARK:ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = AddYCYAViewController()
        con.modalTransitionStyle = _globalCustomviewchange
        con.checkerName = nowCheckerName
        con.checkerID = nowCheckerID
        con.receiverName = nowReceiverName
        con.receiverID = nowReceiverID
        con.selectDate = nowSelectDate
        con.content = nowContent
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //tableview left swap
    func midscrollright(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 70, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            }, completion: nil)
    }
    
    func jumpMainview(){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //select or unselect personid
    func press443(sender:UIButton){
        sender.backgroundColor = UIColor(patternImage: UIImage(named: "im_select.png")!)
        var iddata = self.arraylist[sender.tag - 1000] as NSDictionary
        var con = AddYCYAViewController()
        con.modalTransitionStyle = _globalCustomviewchange
        if(personMark == 1){
            con.receiverName = iddata["UserName"] as String
            con.receiverID = iddata["UserID"] as String
            con.selectDate = nowSelectDate
            con.checkerName = nowCheckerName
            con.checkerID = nowCheckerID
            con.content = nowContent
        }else if(personMark == 2){
            con.checkerName = iddata["UserName"] as String
            con.checkerID = iddata["UserID"] as String
            con.receiverName = nowReceiverName
            con.receiverID = nowReceiverID
            con.selectDate = nowSelectDate
            con.content = nowContent
        }
        self.presentViewController(con, animated: true, completion: nil)

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if(textField.tag == 3){
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.namelistxing.removeAll(keepCapacity: false)
        self.arraylist1.removeAll(keepCapacity: false)
        var text = self.searchtext.text as String
        //search first name 0(no change)
        if(text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0){
            //println("0")
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
                //println(name1)
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
                var name1 = name.substringToIndex(3)
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
        return true
    }
}
