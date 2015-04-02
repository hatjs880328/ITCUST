//
//  emailController.swift
//  东正oa
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit
import Alamofire

class emailController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //params
    var menuFlag = 0
    var lockflag = 0
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
    var buttonright = UIButton(frame: CGRectZero)
    var arraylist:NSArray = []
    var flagifRead = 0
    
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
        //init tableview
        var parameters = ["sfck":"0","delbj":"0","page":"1","rows":"30"]
        self.getData(parameters, url: "NbMail/NbMailAcceptSelectByWhere",id:"1")
        hidtableview()
        self.buttonleft.backgroundColor = UIColor.grayColor()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING START
    func getData(parameters5:[String: AnyObject],url:String,id:String){
        self.lockflag = 1
        let Parameters3 = parameters5
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/\(url)",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    if(id == "1" || id == "2"){
                        self.arraylist = jsonObject["rows"] as NSArray
                        self.midtableview.reloadData()
                    }
                    if(id == "3"){
                        self.arraylist = jsonObject["rows"] as NSArray
                        //println(self.arraylist[0])
                        self.midtableview.reloadData()
                    }
                    self.lockflag = 0
                }
        }
    }
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
        label.text = "邮件"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
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
        
        var useg = UISegmentedControl(items: ["未读","已读","已发送"])
        useg.frame = CGRectMake(0, 9, width, 30)
        useg.addTarget(self, action: "presssegment:", forControlEvents: UIControlEvents.ValueChanged)
        useg.tintColor = _globalBgcolor
        botview.addSubview(useg)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 20){
            return 11
        }else{
            return self.arraylist.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 20){
            var cell1 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell21")
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
        }else{
            var cell1 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell66")
            var data = self.arraylist[indexPath.row] as NSDictionary
            //emailicon
            let uiimage = UIImageView(frame: CGRectMake(5, 15, 30, 30))
            if(self.flagifRead == 0){
                uiimage.image = UIImage(named: "emailweidu.png")
            }else if(self.flagifRead == 1){
                uiimage.image = UIImage(named: "emailyidu.png")
            }else{
                 uiimage.image = UIImage(named: "emailyifasong.png")
            }
            cell1.addSubview(uiimage)
            if(self.flagifRead == 0 || self.flagifRead == 1){
                //post person
                let nameLabel = UILabel(frame: CGRectMake(40, 5, width/2, 25))
                var name = data["SendEmp"] as NSDictionary
                nameLabel.font = uifont2
                nameLabel.text = name["RealName"] as? String
                cell1.addSubview(nameLabel)
                //post time
                let timelabel = UILabel(frame: CGRectMake(width - 150, 5, 140, 25))
                timelabel.font = uifont1
                timelabel.text = data["ITIMES"] as? String
                cell1.addSubview(timelabel)
                //content
                let content = UILabel(frame: CGRectMake(40, 30, width - 45, 25))
                content.text =  data["TITLE"] as? String
                content.font = uifont1
                cell1.addSubview(content)
            }else{
                //post person
                let nameLabel = UILabel(frame: CGRectMake(40, 5, width/2, 25))
                nameLabel.font = uifont2
                nameLabel.text = data["ACCEPTREALNAME"] as? String
                cell1.addSubview(nameLabel)
                //post time
                let timelabel = UILabel(frame: CGRectMake(width - 150, 5, 140, 25))
                timelabel.font = uifont1
                timelabel.text = data["ITIMES"] as? String
                cell1.addSubview(timelabel)
                //content
                let content = UILabel(frame: CGRectMake(40, 30, width - 45, 25))
                content.text =  data["TITLE"] as? String
                content.font = uifont1
                cell1.addSubview(content)
            }
            return cell1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 20){
            jumpothersPage(indexPath.row)
        }else{
            var data = self.arraylist[indexPath.row] as NSDictionary
            println(data)
            var con = emailDetailinfoController()
            con.id = data["ID"] as String
            if(flagifRead == 2){
                con.falg = 0
            }
            else{
                con.falg = 1
            }
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 20){
            return 50
        }else{
            return 60
        }
    }
    
    //MARK:ACITON BUTTONS.
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
    
    //set all global params null
    func setAllnull(){
        nameall.removeAllObjects()
        idall.removeAllObjects()
        nameall1.removeAllObjects()
        idall1.removeAllObjects()
        nameall2.removeAllObjects()
        idall2.removeAllObjects()
    }
    
    func pressEdit(sender:UIButton){
        setAllnull()
        var con = postNewEmailController()
        con.flag = 0
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func presssegment(sender:UISegmentedControl){
        println(sender.selectedSegmentIndex)
        var i = sender.selectedSegmentIndex
        if( i == 0){
            //no read exist.
            var parameters = ["sfck":"0","delbj":"0","page":"1","rows":"30"]
            if(lockflag == 0){
                self.getData(parameters, url: "NbMail/NbMailAcceptSelectByWhere",id:"1")
            }
            self.flagifRead = 0
        }else if( i == 1){
            //read
            var parameters = ["sfck":"1","delbj":"0","page":"1","rows":"30"]
            if(lockflag == 0){
                self.getData(parameters, url: "NbMail/NbMailAcceptSelectByWhere",id:"2")
            }
            self.flagifRead = 1
        }else{
            var parameters = ["sfck":"0","delbj":"0","CGBJ":"0","page":"1","rows":"30"]
            if(lockflag == 0){
                self.getData(parameters, url: "NbMail/NbMailSendSelectByWhereCg",id:"3")
            }
            self.flagifRead = 2
        }
        
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
