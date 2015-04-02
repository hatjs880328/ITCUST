//
//  mainController.swift
//  oa
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class mainController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //global params
    var delayTIME:UInt32 = 4
    var topView = UIView(frame: CGRectZero)
    var width:CGFloat = 0
    var height:CGFloat = 0
    var _midbigView = UIView(frame: CGRectZero)
    var botview = UIView(frame: CGRectZero)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var stringarr = [String]()
    var tableview = UITableView(frame: CGRectZero)
    //post icon
    var iocn9  = UIButton(frame: CGRectZero)
    var iocn8  = UIButton(frame: CGRectZero)
    var iocn7  = UIButton(frame: CGRectZero)
    var iocn6  = UIButton(frame: CGRectZero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        self.view.backgroundColor = UIColor.whiteColor()
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        botSetting()
        hiddenviewSetting()
        setupRefresh()
        asy9()
        asy8()
        asy7()
    }
    
    override func viewDidAppear(animated: Bool) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: VIEW SETTING
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
    
    func topviewSetting(){
        let frame = CGRectMake(0, 0, width, 20)
        self.topView.frame = frame
        self.topView.backgroundColor = bgcolorall
        self.view.addSubview(topView)
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height)
        _midbigView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, 50))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "移动办公系统"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        var button = UIButton(frame: CGRectMake(width-40, 15, 30, 30))
        button.addTarget(self, action: "gobackpress:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "info_act.png"), forState: UIControlState.Normal)
        view.addSubview(button)
    }
    
    func botSetting(){
        let frame = CGRectMake(0, 50, width, height-70)
        self.botview.frame = frame
        self.botview.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenpic")!)
        self._midbigView.addSubview(botview)
        //shoucang
        for var i:CGFloat = 0;i<3;i++ {
            for var j:CGFloat = 0;j<3;j++ {
                var width1:CGFloat = (width)/3*j+18
                var height1:CGFloat = 120 * i+20
                var scview = UIView(frame: CGRectMake(width1, height1, 80, 100))
                scview.layer.cornerRadius = 10
                scview.layer.shadowColor = UIColor.blackColor().CGColor
                scview.layer.shadowOffset = CGSize(width: 2, height: 2)
                scview.layer.shadowRadius = 10
                scview.layer.shadowOpacity = 0.5
                self.botview.addSubview(scview)
                var mm = Int(3*i+j)
                var namelabel = UILabel(frame: CGRectMake(0, 80, 80, 20))
                namelabel.font = self.uifont1
                namelabel.textColor = UIColor.blackColor()
                namelabel.text = self.stringarr[mm] as String
                namelabel.textAlignment = NSTextAlignment.Center
                scview.addSubview(namelabel)
                var button = UIButton(frame: CGRectMake(0, 0, 80, 80))
                button.setImage(UIImage(named: "gonggao\(mm+1).png"), forState: UIControlState.Normal)
                button.addTarget(self, action: "eachpress:", forControlEvents: UIControlEvents.TouchUpInside)
                button.tag = Int(3*i+j)
                //small tip button
                var frame = CGRectMake(50, 0, 25, 15)
                self.iocn9.frame = frame
                self.iocn9.layer.cornerRadius = 5
                self.iocn9.backgroundColor = UIColor.redColor()
                self.iocn9.alpha = 0
                self.iocn8.frame = frame
                self.iocn8.backgroundColor = UIColor.redColor()
                self.iocn8.alpha = 0
                self.iocn8.layer.cornerRadius = 5
                self.iocn7.frame = frame
                self.iocn7.backgroundColor = UIColor.redColor()
                self.iocn7.alpha = 0
                self.iocn7.layer.cornerRadius = 5
                //add all of it.
                switch(mm){
                case 0:scview.addSubview(iocn9)
                case 1:scview.addSubview(iocn8)
                case 2:scview.addSubview(iocn7)
                default:println("")
                }
                scview.addSubview(button)
            }
        }
    }
    
    //hidden view
    func hiddenviewSetting(){
        self.tableview.frame = CGRectMake(-160, 50, 160, height-100)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.tableview.addGestureRecognizer(swipeLeftGesture)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "hiddenviewcell")
        if(indexPath.row == 9){
            cell.textLabel?.text = "返回首页"
        }else{
            cell.textLabel?.text = "\(self.stringarr[indexPath.row] as String)"
        }
        return cell
    }
    
    //MARK:ACTION(BUTTONS)
    func gobackpress(sender:UIButton){
        var con = userInfoController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //open or close
    func changeswitch(sender:UISwitch){
    }
    
    //each button press.
    func eachpress(sender:UIButton){
        //println(sender.tag)
        var frameshow = CGRectMake(0, 50, 160, height-100)
        if(sender.tag == 0){
            var con = NoticeViewController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 1){
            var con = approveController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 2){
            var con = emailController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 3){
            var con = menuController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 4){
            var con = shareInfoController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 5){
            var con = YCYAViewController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 6){
            var con = ResultViewController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else if(sender.tag == 7){
            var con = postArticleController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
            
        }else if(sender.tag == 8){
            var con = newsController()
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }
    }
    
    //tableview cell press
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 9){
            var con = mainController()
            self.presentViewController(con, animated: true, completion: nil)
        }else{
            
        }
    }
    
    //tableview left swap
    func midscrollright(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-160, 50, 160, height-100)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableview.frame = frameshow
            }, completion: nil)

    }
    
    //refresh the tableview
    func setupRefresh(){
        self.tableview.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.tableview.headerEndRefreshing()
            })
        })
        //bot refresh
        self.tableview.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                    self.tableview.footerEndRefreshing()
                    }) 
            })
    }
    
    //async icon9:publisher not read.
    func asy9(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var count5 = 0
            for var i = 0 ; i > -1 && 0 == 0 ; i++ {
                let Parameters1 = [
                    "type":"main","id":"0","page":"1","rows":"15"
                ]
                Alamofire.request(.POST,
                    "http://\(_globaleIpstring):\(_globalPortstring)/MyAffairs/CompanyNotice/GetCompanyNoticeListPhoneOA",
                    parameters: Parameters1)
                    .responseString{(request,response,string4,error) in
                        if(string4 != nil && string4 != "" && string4 != "[]"){
                            var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                            var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                            if(result["rows"] != nil){
                                var arr = result["rows"] as NSArray
                                for var i = 0  ; i < arr.count;i++ {
                                    var data = arr[i] as NSDictionary
                                    if(data["READED"] as NSString == "0" ){
                                        count5  = count5 + 1
                                    }
                                }
                                dispatch_async(dispatch_get_main_queue(), {
                                    println("这里返回主线程，写需要主线程执行的代码9")
                                    self.iocn9.alpha = 1
                                    if(count5 != 0){
                                        self.iocn9.setTitle("\(count5)", forState: UIControlState.Normal)
                                    }else{
                                        self.iocn9.hidden = true
                                    }
                                })
                            }
                        }
                }
                self.delayTIME = self.delayTIME + 2
                sleep(self.delayTIME);
            }
        })
    }
    //approve not read.
    func asy8(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var count:AnyObject?
            for var i = 0 ; i > -1 && 0 == 0 ; i++ {
                let Parameters1 = [
                    "":""
                ]
                Alamofire.request(.POST,
                    "http://\(_globaleIpstring):\(_globalPortstring)/AddWorkFlow/GetUnReadWork",
                    parameters: Parameters1)
                    .responseString{(request,response,string4,error) in
                        if(string4 != nil && string4 != "[]"){
                          var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                          let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                            var dj1 = jsonObject[0] as NSDictionary
                            count = dj1["DB"]
                            dispatch_async(dispatch_get_main_queue(), {
                                println("这里返回主线程，写需要主线程执行的代码8")
                                self.iocn8.alpha = 1
                                if(count! as NSString != "0"){
                                    self.iocn8.setTitle("\(count!)", forState: UIControlState.Normal)
                                }else{
                                    self.iocn8.hidden = true
                                }
                            })
                        }
                }
                self.delayTIME = self.delayTIME + 2
                sleep(self.delayTIME);
            }
        })
    }
    //email not read.
    func asy7(){
        var countall = 0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var count:AnyObject?
            for var i = 0 ; i > -1 && 0 == 0 ; i++ {
                var parameters = ["sfck":"0","delbj":"0","page":"1","rows":"10"]
                Alamofire.request(.POST,
                    "http://\(_globaleIpstring):\(_globalPortstring)/NbMail/NbMailAcceptSelectByWhere",
                    parameters: parameters)
                    .responseString{(request,response,string4,error) in
                        if(string4 != nil && string4 != "[]"){
                            var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                            var count = jsonObject["rows"] as NSArray
                            countall = count.count
                            dispatch_async(dispatch_get_main_queue(), {
                                println("这里返回主线程，写需要主线程执行的代码7")
                                self.iocn7.alpha = 1
                                if(countall != 0){
                                    self.iocn7.setTitle("\(countall)", forState: UIControlState.Normal)
                                }else{
                                    self.iocn7.hidden = true
                                }
                            })
                        }
                }
                self.delayTIME = self.delayTIME + 2
                sleep(self.delayTIME);
            }
        })
    }
}
