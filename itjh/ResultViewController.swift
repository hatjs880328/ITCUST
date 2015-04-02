//
//  ResultViewController.swift
//  itjh
//
//  Created by huasu on 15/3/23.
//  Copyright (c) 2015 zwb. All rights reserved.
//

import UIKit
import Alamofire
class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //global params
    var flag = 0
    var menuFlag = 0
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
    //UI
    var mainTableView = UITableView(frame: CGRectZero)
    var segement:UISegmentedControl = UISegmentedControl(items: ["我关注的","所有结果","我的结果"])
    var leftTableView = UITableView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        urlParam = "Attention"
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        loadData()
        setupRefresh()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        navSetting()
        tableViewSetting()
        segementSetting()
        hiddenviewSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    //MARK:LoadData
    func loadData(){
        flag = 1
        let Parameters1 = [
            "DataRange":"\(urlParam)","pagerJson":"{\"pageIndex\":\"\(nowPage)\",\"pageSize\":\"6\"}"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Dayresult/GetPlanDays",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    var arr = result["rows"] as NSMutableArray
                    self.dataArray.addObjectsFromArray(arr)
                    self.mainTableView.reloadData()
                    self.mainTableView.headerEndRefreshing()
                    self.flag = 0
                }
        }
        
    }
    //MARK:refreshData
    func setupRefresh(){
        mainTableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.dataArray.removeAllObjects()
                self.nowPage = 1
                self.loadData()
            })
        })
        //footer Refresh
        mainTableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowPage++
                self.loadData()
                self.mainTableView.footerEndRefreshing()
            })
            
        })
        
    }
    
    //MARK:BASE SETTING
    func WidthHeight_ArraySetting(){
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
    //MARK:NAV SETTING
    func navSetting(){
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        var  titleLabel = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        titleLabel.text = "日结果"
        titleLabel.textColor = _globalTitleColor
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = _globaluifont
        navView.addSubview(titleLabel)
        //left Button
        var leftBtn = UIButton(frame: CGRectMake(10, 35, 25, 25))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        
        //right Button
        var rightBtn = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        rightBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "emailxinzeng.png"), forState: UIControlState.Normal)
        rightBtn.tag = 202
        navView.addSubview(rightBtn)
    }
    //MARK:navBtnClick
    func navBtnClick(sender:UIButton){
        if(sender.tag == 201){
            if(menuFlag == 0){
                var frameshow = CGRectMake(0, 90, 150, height-130)
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.leftTableView.frame = frameshow
                    self.menuFlag = 1
                    }, completion: nil)
            }else if(menuFlag == 1){
                var frameshow = CGRectMake(-150, 90, 150, height-130)
                UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.leftTableView.frame = frameshow
                    self.menuFlag = 0
                    }, completion: nil)
                
            }
            
        }else if(sender.tag == 202){
            
            var vc = MyPlanInfoViewController();
            vc.nowUserID = _globalUserID
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)}
        
    }
    //MARK:tableView Setting
    func tableViewSetting(){
        mainTableView.frame = CGRectMake(0, 70, width, height - 100)
        mainTableView.tag = 101
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        var swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright:")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        mainTableView.addGestureRecognizer(swipeRightGesture)
        self.view.addSubview(mainTableView)
    }
    //MARK:tableView right Gesture
    func midscrollright(sender:UISwipeGestureRecognizer){
        
        var frameshow = CGRectMake(0, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftTableView.frame = frameshow
            self.menuFlag = 1
            }, completion: nil)
        
    }
    //MARK:segement Setting
    func segementSetting(){
        segement.frame = CGRectMake(0, height - 30, width, 30)
        segement.addTarget(self, action: "segementChange:", forControlEvents: UIControlEvents.ValueChanged)
        segement.selectedSegmentIndex = 0
        self.view.addSubview(segement)
    }
    func segementChange(sender:UISegmentedControl){
        self.nowPage = 1
        self.dataArray.removeAllObjects()
        if(segement.selectedSegmentIndex == 0 && flag == 0){
            urlParam = "Attention"
            self.loadData()
        }else if(segement.selectedSegmentIndex == 1 && flag == 0){
            urlParam = "ALL"
            self.loadData()
        }else if(segement.selectedSegmentIndex == 2 && flag == 0){
            urlParam = "MY"
            self.loadData()
        }
        
    }
    
    //MARK:leftTableView Setting
    func hiddenviewSetting(){
        self.leftTableView.frame = CGRectMake(0, 70, 0, 0)
        self.leftTableView.tag = 102;
        self.view.addSubview(leftTableView)
        self.leftTableView.delegate = self
        self.leftTableView.dataSource = self
        self.leftTableView.layer.borderColor = bgcolorall.CGColor
        self.leftTableView.layer.borderWidth = 1
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollleft:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.leftTableView.addGestureRecognizer(swipeLeftGesture)
    }
    //MARK:left Gesture
    func midscrollleft(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftTableView.frame = frameshow
            self.menuFlag = 0
            }, completion: nil)
        
    }
    //MARK:rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 101){
            return self.dataArray.count
        }else
        {
            return 11
        }
    }
    //MARK:cell Setting
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 101)
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
            var dic = self.dataArray[indexPath.row] as NSDictionary
            
            var imgV = UIImageView (frame: CGRectMake(10, 18, 35, 35))
            imgV.image = UIImage(named: "daily_result_icon2.png")
            cell.contentView.addSubview(imgV)
            
            var nameDic = dic["Employee"] as NSDictionary
            var nameLabel = UILabel(frame: CGRectMake(60, 10, width/2-30, 20))
            nameLabel.text = nameDic["RealName"] as? String
            nameLabel.font = _globaluifont
            cell.contentView.addSubview(nameLabel)
            
            var sectionDic = dic["UnitName"] as NSDictionary
            var sectionLabel = UILabel(frame: CGRectMake(60, 40, width/2-30, 20))
            sectionLabel.text = sectionDic["FullName"] as? String
            sectionLabel.font = _globaluifont
            cell.contentView.addSubview(sectionLabel)
            
            var timeLabel = UILabel(frame: CGRectMake(width/2+30, 10, width/2-40, 20))
            timeLabel.text = dic["VSDAYRESULTDAY"] as? String
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.textAlignment = NSTextAlignment.Right
            timeLabel.font = _globaluifont
            cell.contentView.addSubview(timeLabel)
            return cell
        }
        else
        {
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
        }
    }
    //MARK:cell Height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 101)
        {
            return _globalEachCellHeight
        }
        else {
            return 50
        }
    }
    //MARK:cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 101){
            var dic = self.dataArray[indexPath.row] as NSDictionary
            var vc = ResultDetailViewController();
            vc.empID = dic["EMPLOYEEID"] as NSString
            vc.dayTime = dic["VSDAYRESULTDAY"] as NSString
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }else
        {
            jumpothersPage(indexPath.row)
        }
    }
    //MARK:jump to MainController
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
