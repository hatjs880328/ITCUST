//
//  newsController.swift
//  oa
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class newsController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //golbal params
    var menuFlag = 0
    var stringarr = [String]()
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var tableview = UITableView(frame: CGRectZero)
    var view1 = UIView(frame: CGRectZero)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var width:CGFloat = 0
    var height:CGFloat = 0
    var page:Int = 1
    var arrayData:NSMutableArray = []
    var allarrayData:NSMutableArray = []
    var lastview = UITableView(frame: CGRectZero)
    var newsID:String?
    var newsarrayCache = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        tableview.dataSource = self
        tableview.delegate = self
        loaddataMethod()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        tableviewsetting()
        hidtableview()
        setupRefresh()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK: VIEW SETTING START.
    func loaddataMethod(){
       
        let Parameters1 = [
            "page":"\(page)","rows":"10"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/PublicAffairs/CompanyNews/CompanyNewsDisplayPhoneOA",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    //println(result)
                    self.arrayData = result["rows"] as NSMutableArray
                    self.allarrayData.addObjectsFromArray(self.arrayData)
                    self.tableview.reloadData()
                    self.tableview.headerEndRefreshing()
                }
        }

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
        label.text = "新闻"
        label.textAlignment = NSTextAlignment.Center
        label.font = _globaluifont
        view.addSubview(label)
        var button = UIButton(frame: CGRectMake(width-40, 15, 30, 30))
        button.addTarget(self, action: "gobackpress:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        //view.addSubview(button)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
    }
    
    func tableviewsetting(){
        var frame = CGRectMake(0, 50, self.width, self.height-70)
        tableview.frame = frame
        
        self._midbigView.addSubview(tableview)
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright1:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.tableview.addGestureRecognizer(swipeLeftGesture)
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
        }else{
            return allarrayData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 20){
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
        }else{
            var indexpathData = self.allarrayData[indexPath.row] as NSDictionary
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newstableviewcell1")
            //title
            let labeltitle = UILabel(frame: CGRectMake(10, 5, self.width/2, 20))
            labeltitle.text = indexpathData["TITLE"] as? String
            labeltitle.font = uifont2
            cell.addSubview(labeltitle)
            //time REALNAME
            let labeltime = UILabel(frame: CGRectMake(self.width/2+15, 5, width/2-20, 20))
            labeltime.text = indexpathData["NOWTIMES"] as? String
            labeltime.font = _globaluifont
            cell.addSubview(labeltime)
            //person 
            let labelperson = UILabel(frame: CGRectMake(20, 30, width/2, 25))
            labelperson.text = indexpathData["REALNAME"] as? String
            labelperson.font = _globaluifont
            cell.addSubview(labelperson)
            //unit
            let labelunit = UILabel(frame: CGRectMake(width/2+20, 30, width/2-20, 25))
            labelunit.text = indexpathData["UNITNAME"] as? String
            labelunit.font = _globaluifont
            labelunit.textColor = _globalBgcolor
            cell.addSubview(labelunit)
            cell.selectionStyle = .None
            return cell
        }
    }
    //cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 20){
            return 50
        }else{
        return _globalEachCellHeight
        }
    }

    //refresh the tableview
    func setupRefresh(){
        self.tableview.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.page = 1
                self.allarrayData.removeAllObjects()
                self.loaddataMethod()
            })
        })
        //bot refresh
        self.tableview.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.page++
                self.loaddataMethod()
                self.tableview.footerEndRefreshing()
            })
            
        })
    }
    
    //MARK: ACTION (BUTTONS)
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
    
    func gobackpress(sender:UIButton){
        println("..")
    }
    
    //tableview left swap
    func midscrollright(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 70, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            self.menuFlag = 0
            }, completion: nil)
        
    }
    
    //tableview right swap
    func midscrollright1(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-0, 70, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            self.menuFlag = 1
            //self.tableview.frame = CGRectMake(150, 50, self.width-150, self.height - 100)
            }, completion: nil)
        
    }
    //tableView did 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 20){
            jumpothersPage(indexPath.row)
        }else
        {
            println("...")
            var indexnow = allarrayData[indexPath.row] as NSDictionary
            self.newsID = indexnow["ID"] as? String
            var con = detailNewsController()
            con.indexnow = self.newsID!
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
            
        }
    }
    //jump 
    func jumpMainview(){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
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
