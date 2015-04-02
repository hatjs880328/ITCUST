//
//  postArticleController.swift
//  oa
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class postArticleController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //params
    var menuFlag = 0
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
    var dataarray:NSMutableArray = []
    var allarrayData:NSMutableArray = []
    
    var nowpage = 1
    var tableview1 = UITableView(frame: CGRectZero)
    var _webView = UIWebView(frame: CGRectZero)
    var button = UIButton(frame: CGRectMake(0, 0, 0, 0))
    var path = ""
    
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
        hidtableview()
        setupRefresh()
        loadData()
        gobackbutton()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING START.
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
        label.text = "发文"
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
        getTable()
    }
    
    func getTable(){
        var frame = CGRectMake(0, 0, width, height - _globalNavviewHeight - 20)
        self.tableview1.frame = frame
        self.tableview1.delegate = self
        self.tableview1.dataSource = self
        self.tableview1.tag = 99
        self.tableview1.separatorColor = _globalBgcolor
        self.textarea.addSubview(tableview1)
    }
    
    func loadData(){
        let Parameters1 = [
            "page":"\(nowpage)","rows":"10"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/Portal/SelectByLawPaperByUsername",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    self.dataarray = jsonObject["rows"] as NSMutableArray
                    self.allarrayData.addObjectsFromArray(self.dataarray)
                    self.tableview1.reloadData()
                    self.tableview1.headerEndRefreshing()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 20){
            return 11
        }else if(tableView.tag == 99){
            return self.allarrayData.count
        }else{
            return 4
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 20){
            var cell1 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell5")
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
        }else if(tableView.tag == 99){
            var indexpathData = self.allarrayData[indexPath.row] as NSDictionary
            //println(indexpathData)
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell4")
            //title
            let labeltitle = UILabel(frame: CGRectMake(10, 5, self.width/2, 20))
            labeltitle.text = indexpathData["NAME"] as? String
            labeltitle.font = uifont2
            cell.addSubview(labeltitle)
            //time REALNAME
            let labeltime = UILabel(frame: CGRectMake(self.width/2+15, 5, width/2-20, 20))
            labeltime.text = indexpathData["ADDDATE"] as? String
            labeltime.font = _globaluifont
            cell.addSubview(labeltime)
            //person
            let labelperson = UILabel(frame: CGRectMake(10, 30, width/2, 25))
            labelperson.text = indexpathData["FULLNAME"] as? String
            labelperson.font = _globaluifont
            cell.addSubview(labelperson)
            //unit
            let labelunit = UILabel(frame: CGRectMake(width - 70, 30, 70, 25))
            var ifread = indexpathData["ISREAD"] as? String
            if(ifread == "1"){
                labelunit.text = "已读"
                labelunit.textColor = _globalBgcolor
            }else{
                labelunit.text = "未读"
            }
            labelunit.font = _globaluifont
            cell.addSubview(labelunit)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }else{
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell42")
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 99){
            return 60
        }else if(tableView.tag == 20){
            return 50
        }else{
            return 100
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 20){
            jumpothersPage(indexPath.row)
        }else if(tableView.tag == 99){
            var indexpathData = self.allarrayData[indexPath.row] as NSDictionary
            self.path = indexpathData["NEWNAME"] as String
            showwebView("55",id: "")
        }
    }
    //show the _webview
    func showwebView(url3:String,id:String)->Void{
        if(url3 != "rrr")
        {
            let framebutton = CGRectMake(width/2 - 50, height - 55, 100, 25)
            let frame = CGRectMake(0, 0, width, height)
            var nsurl:NSURL = NSURL(string: "http://\(_globaleIpstring):\(_globalPortstring)/Content/resources/uploadfile/PublicAffairs/\(self.path)")!
            var request:NSURLRequest = NSURLRequest(URL: nsurl)
            self._webView.scalesPageToFit = true
            self._webView.loadRequest(request)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._webView.frame = frame
            self.button.frame = framebutton
            self.view.addSubview(self._webView)
            self.view.addSubview(self.button)
            }, completion: nil)
        }
    }
    
    func gobackbutton(){
        button.addTarget(self, action: "pressExit:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("退出", forState: UIControlState.Normal)
        button.backgroundColor = _globalBgcolor
        button.alpha = 0.5
        button.layer.cornerRadius = 9
    }
    
    //MARK:ACTION BUTTONS.
    func pressExit(sender:UIButton){
        var frame = CGRectZero
        var framebutton = CGRectZero
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._webView.frame = frame
            self.button.frame = framebutton
            }, completion: nil)
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
    
    //refresh the tableview
    func setupRefresh(){
        self.tableview1.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowpage = 1
                self.allarrayData.removeAllObjects()
                self.loadData()
            })
        })
        //bot refresh
        self.tableview1.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowpage++
                self.loadData()
                self.tableview1.footerEndRefreshing()
            })
            
        })
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
