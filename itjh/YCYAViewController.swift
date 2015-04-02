//
//  YCYAViewController.swift
//  oa
//
//  Created by  on 15/3/18.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class YCYAViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //global params
    var flag = 0
    var menuFlag = 0
    var refreshFlag = 999
    var width:CGFloat = 0
    var height:CGFloat = 0
    var stringarr = [String]()
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var dataArray:NSMutableArray = []
    var nowPage:Int = 1
    var strUrl:String?
    var statusArr = [String]()
    //UI
    var tableView = UITableView(frame: CGRectZero)
    var segement:UISegmentedControl = UISegmentedControl(items: ["我下达","我承诺","我检查"])
    var titleLabel = UILabel(frame:CGRectZero)
    var typeTableView = UITableView(frame: CGRectZero)
    var leftTableView = UITableView(frame: CGRectZero)
    var addBtn = UIButton(frame: CGRectZero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        strUrl = "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/MyDirected"
        loadData()
        setupRefresh()
    }
    //MARK:loadData
    func loadData(){
        flag = 1
        let Parameters1 = [
            "page":"\(nowPage)","rows":"6"
        ]
        Alamofire.request(.POST,
            strUrl!,
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    
                        var arr = jsonObject["rows"] as NSMutableArray
                        self.dataArray.addObjectsFromArray(arr)
                        self.tableView.reloadData()
                        self.tableView.headerEndRefreshing()
                        self.flag = 0
                    
                }
        }
        
    }
    //MARK:viewDidAppear
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        navSetting()
        tableViewSetting()
        typeViewSetting()
        segementSetting()
        hiddenviewSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
        
        statusArr.append("所有")
        statusArr.append("待承诺")
        statusArr.append("待汇报")
        statusArr.append("待检查")
        statusArr.append("待确认")
        statusArr.append("已完成")
        statusArr.append("未完成")
        
    }
    //MARK:NAV SETTING
    func navSetting(){
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        titleLabel.frame = CGRectMake(width/6, 35, width/3*2, 25)
        titleLabel.text = "YCYA已下达"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = _globaluifont
        navView.addSubview(titleLabel)
        //left Button
        var leftBtn = UIButton(frame: CGRectMake(10, 35, 25, 25))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        //add Button
        addBtn.frame = CGRectMake(width-90, 25, 35, 35)
        addBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        addBtn.setBackgroundImage(UIImage(named: "emailxinzeng.png"), forState: UIControlState.Normal)
        addBtn.tag = 203
        navView.addSubview(addBtn)
        //right Button
        var rightBtn = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        rightBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "ycyafanwei.png"), forState: UIControlState.Normal)
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
            typeTableView.hidden = !typeTableView.hidden
        }else if(sender.tag == 203){
            var vc = AddYCYAViewController()
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    //MARK:tableView Setting
    func tableViewSetting(){
        self.tableView.frame = CGRectMake(0, 70, width, height - 100)
        self.tableView.tag = 101
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = _globalBgcolor
        var swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright:")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.tableView.addGestureRecognizer(swipeRightGesture)
        self.view.addSubview(tableView)
    }
    //MARK:tableView right Gesture
    func midscrollright(sender:UISwipeGestureRecognizer){
        
        var frameshow = CGRectMake(0, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftTableView.frame = frameshow
            self.menuFlag = 1
            }, completion: nil)
        
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
    
    //MARK:select Type Setting
    func typeViewSetting(){
        
        typeTableView.frame = CGRectMake(40, 110, width - 80, height - 190)
        typeTableView.hidden = true
        typeTableView.dataSource = self
        typeTableView.delegate = self
        typeTableView.tag = 103
        typeTableView.hidden = true
        self.view.addSubview(typeTableView)
        
    }
    //MARK:rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 101){
            return self.dataArray.count
        }else if(tableView.tag == 102)
        {
            return 11
        }else{
            return statusArr.count + 2
        }
    }
    //MARK:cell Setting
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 101)
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
            
            var dic = self.dataArray[indexPath.row] as NSDictionary
            //user
            var userLabel: UILabel = UILabel(frame: CGRectMake(5, 10, width/2, 20))
            userLabel.adjustsFontSizeToFitWidth = true
            userLabel.font = _globaluifont
            var str3 = dic["COMPLETETIME"] as? String
            if(segement.selectedSegmentIndex != 1){
                
                if var dic1 = dic["ReceiverEmp"] as? NSDictionary{
                    if var dic2 = dic["ReceiverUnit"] as? NSDictionary{
                        var str1 = dic1["RealName"] as? String
                        var str2 = dic2["FullName"] as? String
                        userLabel.text = "执行人: \(str1!)   \(str2!)"
                    }
                }
                else{
                    userLabel.text = "执行人:"
                }
                
                
            }else {
                
                if var dic1 = dic["DirectorEmp"] as? NSDictionary{
                    if var dic2 = dic["DirectorUnit"] as? NSDictionary{
                        var str1 = dic1["RealName"] as? String
                        var str2 = dic2["FullName"] as? String
                        userLabel.text = "下达人: \(str1!)   \(str2!)"
                    }
                }
                else{
                    userLabel.text = "下达人:"
                }

            }
            cell.contentView.addSubview(userLabel)
            //time
            var timeLabel:UILabel = UILabel(frame: CGRectMake(width/2+10, 10, width/2-15, 20))
            timeLabel.text = "\(str3!)"
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.font = UIFont.systemFontOfSize(14)
            timeLabel.adjustsFontSizeToFitWidth = true
            timeLabel.textAlignment = NSTextAlignment.Right
            cell.contentView.addSubview(timeLabel)
            //YCYA Content
            var contentLabel:UILabel = UILabel(frame: CGRectMake(5, 40, width-10, 20))
            var str4 = dic["CONTENT"] as? String
            contentLabel.text = "YCYA内容: \(str4!)"
            contentLabel.textColor = UIColor.grayColor()
            contentLabel.font = UIFont.systemFontOfSize(14)
            cell.contentView.addSubview(contentLabel)
            //Status
            var statusLabel:UILabel = UILabel(frame: CGRectMake(5, 70, width-10, 20))
            var num = dic["STATUS"] as? Int
            num!++
            statusLabel.text = "状态: \(statusArr[num!])"
            statusLabel.textColor = UIColor.grayColor()
            statusLabel.font = _globaluifont
            cell.contentView.addSubview(statusLabel)
            return cell
        }
        else if(tableView.tag == 102)
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
            
            
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
            if(indexPath.row == 0){
                cell.contentView.backgroundColor = bgcolorall
                //cell didSelected color
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = bgcolorall
                
                cell.textLabel?.text = "选择操作"
                cell.textLabel?.font = uifont2
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.textLabel?.textAlignment = NSTextAlignment.Center
            }else if(indexPath.row == statusArr.count + 1){
                cell.contentView.backgroundColor = UIColor.lightGrayColor()
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = UIColor.lightGrayColor()
                cell.textLabel?.text = "取消"
                cell.textLabel?.font = uifont2
                cell.textLabel?.textAlignment = NSTextAlignment.Center
            }
            else
            {
                var cellHeight = (height - 190)/(CGFloat)(statusArr.count + 2)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = "  \(statusArr[indexPath.row - 1])"
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.textLabel?.font = _globaluifont
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
            }
            return cell
        }
    }
    //MARK:cell Height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 101)
        {
            return 100
        }
        else if(tableView.tag == 102)
        {
            return 50
        }else
        {
            return (height - 190)/(CGFloat)(statusArr.count + 2)
        }
    }
    //MARK:cell Click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 101){
            
            var vc = YCYADetailViewController();
            var dic = self.dataArray[indexPath.row] as NSDictionary
            vc.YCYAID = dic["ID"] as? String
            var num = dic["STATUS"] as? Int
            num!++
            if(num! >= 5){
                num! = 0
            }
            vc.frontFlag = num!
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if(tableView.tag == 102){
            jumpothersPage(indexPath.row)
        }else
        {
            if(indexPath.row != 0 ){
                typeTableView.hidden = true
                if(indexPath.row == 1){
                    self.dataArray.removeAllObjects()
                    refreshFlag = 999
                    self.loadData()
                }else if(indexPath.row != statusArr.count + 1){
                    self.dataArray.removeAllObjects()
                    refreshFlag = indexPath.row - 2
                    self.typeLoadData(indexPath.row - 2)
                }
            }
        }
    }
   
    //MARK:jump to MainController
    func jumpMainview(){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    //MRAK:select Type loadData
    func typeLoadData(status:Int){
        let Parameters1 = [
            "page":"\(nowPage)","rows":"6","Status":"\(status)"
        ]
        Alamofire.request(.POST,
            strUrl!,
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil && string4 != "" && string4 != "[]"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    if(result["rows"] != nil){
                        var arr = result["rows"] as NSArray
                        self.dataArray.addObjectsFromArray(arr)
                        self.tableView.reloadData()
                        self.tableView.headerEndRefreshing()
                    }
                }
        }
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
            strUrl = "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/MyDirected"
            titleLabel.text = "YCYA已下达"
            addBtn.hidden = false
            self.loadData()
        }else if(segement.selectedSegmentIndex == 1 && flag == 0){
            strUrl = "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/MyReceived"
            titleLabel.text = "YCYA待承诺"
            addBtn.hidden = true
            self.loadData()
        }else if(segement.selectedSegmentIndex == 2 && flag == 0){
            strUrl = "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/Instruction/MyChecked"
            titleLabel.text = "YCYA待检查"
            addBtn.hidden = true
            self.loadData()
        }
    }
    //MARK:refreshData
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.dataArray.removeAllObjects()
                self.nowPage = 1
                if(self.refreshFlag == 999){
                    self.loadData()
                }else{
                    self.typeLoadData(self.refreshFlag)
                }
                
            })
        })
        //footer Refresh
        self.tableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowPage++
                if(self.refreshFlag == 999){
                    self.loadData()
                }else{
                    self.typeLoadData(self.refreshFlag)
                }
                
                self.tableView.footerEndRefreshing()
            })
            
        })
        
    }
    
    //MARK:MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
