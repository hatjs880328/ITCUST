//
//  userInfoController.swift
//  oa
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class userInfoController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //global params
    var stringarr = [String]()
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var tableview = UITableView(frame: CGRectZero)
    var view1 = UIView(frame: CGRectZero)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var width:CGFloat = 0
    var height:CGFloat = 0
    var page:Int = 1
    var arrayData:NSMutableArray = []
    var allarrayData:NSMutableArray = []
    var lastview = UITableView(frame: CGRectZero)
    var newsID:String?
    var newsarrayCache = [NSDictionary]()
    var midview = UIView(frame: CGRectZero)
    var hidtableviewmain = UITableView(frame: CGRectZero)
    var dic:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        midbigViewSetting()
        logoutView()
    }
    
    //MARK: VIEW SETTING
    func WidthHeightSetting(){
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
    }
    
    func topviewSetting(){
        let frame = CGRectMake(0, 0, width, 20)
        self.topView.frame = frame
        self.topView.backgroundColor = bgcolorall
        self.view.addSubview(topView)
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "设置"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont2
        view.addSubview(label)
        var button = UIButton(frame: CGRectMake(width-40, 15, 30, 30))
        button.addTarget(self, action: "gobackpress:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "footer_sort.png"), forState: UIControlState.Normal)
        //view.addSubview(button)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
    }
    
    //midbigview setting
    func midbigViewSetting(){
        var frame = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.midview.frame = frame
        self._midbigView.addSubview(midview)
        //user info 
        var infoview = UIView(frame: CGRectMake(0, 10, width, 50))
        infoview.layer.cornerRadius = 12
        infoview.backgroundColor = _globalgraycolor
        self.midview.addSubview(infoview)
        var buttoninfo = UIButton(frame: CGRectMake(10, 10, 40, 30))
        var imageviewversion1 = UIImageView(frame:CGRectMake(10, 10, 40, 30))
        infoview.addSubview(imageviewversion1)
        imageviewversion1.image = UIImage(named: "guanyulogin.png")
        buttoninfo.addTarget(self, action: "pressinfo:", forControlEvents: UIControlEvents.TouchUpInside)
        infoview.addSubview(buttoninfo)
        var labelinfo = UIButton(frame: CGRectMake(width/3*2, 10, width/3, 25))
        labelinfo.setTitle("用户信息", forState: UIControlState.Normal)
        labelinfo.titleLabel?.font = _globaluifont
        labelinfo.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        labelinfo.addTarget(self, action: "pressinfo:", forControlEvents: UIControlEvents.TouchUpInside)
        infoview.addSubview(labelinfo)
        //version check
        var checkview = UIView(frame: CGRectMake(0, 70, width, 50))
        checkview.backgroundColor = _globalgraycolor
        checkview.layer.cornerRadius = 12
        self.midview.addSubview(checkview)
        var buttonversion = UIButton(frame: CGRectMake(10, 10, 40, 30))
        var imageviewversion = UIImageView(frame:CGRectMake(10, 10, 40, 30))
        checkview.addSubview(imageviewversion)
        imageviewversion.image = UIImage(named: "ggxx.png")
        buttonversion.addTarget(self, action: "presscheck:", forControlEvents: UIControlEvents.TouchUpInside)
        checkview.addSubview(buttonversion)
        var labelinfo1 = UIButton(frame: CGRectMake(width/3*2, 10, width/3, 25))
        labelinfo1.setTitle("检查更新", forState: UIControlState.Normal)
        labelinfo1.titleLabel?.font = _globaluifont
        labelinfo1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        labelinfo1.addTarget(self, action: "presscheck:", forControlEvents: UIControlEvents.TouchUpInside)
        checkview.addSubview(labelinfo1)
        hidtableview()
    }
    
    //add the hid user info tableview
    func hidtableview(){
        hidtableviewmain.frame = CGRectMake(0, 0, 0, 0)
        self.hidtableviewmain.delegate = self
        self.hidtableviewmain.dataSource = self
        self.hidtableviewmain.tag = 99
        self.hidtableviewmain.separatorColor = _globalBgcolor
        self.hidtableviewmain.layer.borderColor = _globalBgcolor.CGColor
        self.hidtableviewmain.layer.borderWidth = 1
        self.hidtableviewmain.layer.cornerRadius = 7
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright1:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.hidtableviewmain.addGestureRecognizer(swipeLeftGesture)
        self.view.addSubview(hidtableviewmain)
    }
    //bot view log out.
    func logoutView(){
        var view = UIButton(frame: CGRectMake(width/2-100, self.height - 20 - 50, 200, 30))
        self._midbigView.addSubview(view)
        view.backgroundColor = _globalBgcolor
        view.layer.cornerRadius = 7
        view.setTitle("注销", forState: UIControlState.Normal)
        view.addTarget(self, action: "presslogout:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "userinfocontrollerTabelviewcell")
        switch(indexPath.row){
        case 0:
            cell.textLabel?.text = "用户信息"
            cell.textLabel?.font = uifont2
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.backgroundColor = _globalBgcolor
        case 1:
            var name = self.dic["RealName"] as? String!
            cell.textLabel?.text = "姓名：\(name!)"
            cell.textLabel?.font = uifont1
        case 2: var account = self.dic["Account"] as? String!
            cell.textLabel?.text = "帐号：\(account!)"
            cell.textLabel?.font = uifont1
        case 3:var id = self.dic["DevelopmentID"] as? String!
            cell.textLabel?.text = "部门：\(id!)"
            cell.textLabel?.font = uifont1
        case 4:var email = self.dic["Email"] as? String!
            cell.textLabel?.text = "邮箱：\(email!)"
            cell.textLabel?.font = uifont1
        case 5:var mobile = self.dic["Mobile"] as? String!
            cell.textLabel?.text = "手机：\(mobile!)"
            cell.textLabel?.font = uifont1
        case 6:
            cell.textLabel?.text = "返回"
            cell.textLabel?.font = uifont2
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.backgroundColor = _globalBgcolor
        default:println("others")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 6){
            hidtheTable()
        }
    }
    
    //MARK: ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressinfo(sender:UIButton){
        println(".")
        let Parameters1 = [
            "":""
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Dayresult/GetCurrentLoginUser",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    self.dic = jsonObject as NSDictionary
                    //println(self.dic)
                    self.hidtableviewmain.reloadData()
                    var frame = CGRectMake(50, 100, self.width - 100, 280)
                    UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.hidtableviewmain.frame = frame
                        }, completion: nil)
                }
        }
    }
    
    func presscheck(sender:UIButton){
        let Parameters1 = [
            "":""
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Phone/Common/GetNewVersion",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    if(string4 != "2.0"){
                        var alert = UIAlertView(title: "⚠警示", message: "不是最新版本！", delegate: self, cancelButtonTitle: "好")
                        alert.show()
                    }
                }
        }

    }
    
    func presslogout(sender:UIButton){
        println("...")
        var con = loginviewcontroller()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func midscrollright1(sender:UISwipeGestureRecognizer){
        var frame = CGRectMake(-width, 100, width - 100, 280)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.hidtableviewmain.frame = frame
            }, completion: nil)
    }
    
    func hidtheTable(){
        var frame = CGRectMake(-width, 100, width - 100, 280)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.hidtableviewmain.frame = frame
            }, completion: nil)
    }

}
