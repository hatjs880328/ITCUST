//
//  NoticeViewController.swift
//  oa
//
//  Created by  on 15/3/10.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire
class NoticeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //global params
    var menuFlag = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var stringarr = [String]()
    var botview = UIView(frame: CGRectZero)
    var colorall = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var dataArray:NSMutableArray = []
    var nowPage:Int = 1
    var nowID = "0"
    var idArray = [String]()
    var typeArr:NSMutableArray = []
    //UI
    
    var MainTableView = UITableView(frame: CGRectZero)
    var leftTableView = UITableView(frame: CGRectZero)
    var typeTableView = UITableView(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        loadData()
        loadTypeData()
        setupRefresh()
    }
    override func viewDidAppear(animated: Bool) {
        WidthHeight_ArraySetting()
        midviewSetting()
        typeTableViewSetting()
        hiddenviewSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:LOADDATA
    func loadData(){
        let Parameters1 = [
            "type":"main","id":nowID,"page":"\(nowPage)","rows":"10"
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
                        self.dataArray.addObjectsFromArray(arr)
                        self.MainTableView.reloadData()
                        self.MainTableView.headerEndRefreshing()
                    }
                }
        }
        
    }
    func loadTypeData(){
        let Parameters1 = [
            "ParentId":"0"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MyAffairs/CompanyNotice/GetCompanyNoticeTreeLine",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                //println(string4)
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var result = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSMutableArray
                    self.typeArr.addObjectsFromArray(result)
                    //println(self.typeArr)
                    self.typeTableView.reloadData()
            }
        }
    }
    //MARK:UI SETTING
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

    func midscrollleft(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftTableView.frame = frameshow
            self.menuFlag = 0
            }, completion: nil)
        
    }

    func midviewSetting(){
        //nav
        let  navView = UIView(frame: CGRectMake(0, 0, width, 70))
        navView.backgroundColor = bgcolorall
        self.view.addSubview( navView)
        var label = UILabel(frame: CGRectMake(width/6, 35, width/3*2, 25))
        label.text = "公告"
        label.textAlignment = NSTextAlignment.Center
        label.font = _globaluifont
        navView.addSubview(label)
        //leftBtn
        var leftBtn = UIButton(frame: CGRectMake(10, 35, 25, 25))
        leftBtn.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "im_menu_act.png"), forState: UIControlState.Normal)
        leftBtn.tag = 201
        navView.addSubview(leftBtn)
        //rightBtn
        var button = UIButton(frame: CGRectMake(width-40, 25, 35, 35))
        button.addTarget(self, action: "navBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "ycyafanwei.png"), forState: UIControlState.Normal)
        button.tag = 202
        navView.addSubview(button)
        //tableView
        self.MainTableView.frame = CGRectMake(0, 70, width, height - 70)
        self.MainTableView.tag = 101
        self.MainTableView.delegate = self
        self.MainTableView.dataSource = self
        self.MainTableView.separatorColor = _globalBgcolor
        self.view.addSubview(MainTableView)
        var swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright:")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.MainTableView.addGestureRecognizer(swipeRightGesture)
           }

    func typeTableViewSetting(){
        
        typeTableView.frame = CGRectMake(40, 110, width - 80, height - 190)
        typeTableView.hidden = true
        typeTableView.dataSource = self
        typeTableView.delegate = self
        typeTableView.tag = 103
        typeTableView.hidden = true
        self.view.addSubview(typeTableView)
        
    }

    func midscrollright(sender:UISwipeGestureRecognizer){
        
        var frameshow = CGRectMake(0, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftTableView.frame = frameshow
            self.menuFlag = 1
            }, completion: nil)
        
    }
    //MARK:TABLEVIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 101)
        {
            return self.dataArray.count
        }
        else if (tableView.tag == 102)
        {
            return 11
        }else{
            return self.typeArr.count + 3
        }
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 101)
        {
            var dic = self.dataArray[indexPath.row] as NSDictionary
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
            var imgV: UIImageView = UIImageView(frame: CGRectMake(5, 30, 25, 35))
            imgV.image = UIImage(named: "genggaotubiao.png")
            cell.contentView.addSubview(imgV)
            //title
            var titleLabel: UILabel = UILabel(frame: CGRectMake(30, 10, width - 30, 20))
            var flag = dic["SFZD"] as NSString
            if(flag == "1"){
                var str = dic["TITLE"] as NSString
                titleLabel.text = "⬆️\(str)"
            }else{
                titleLabel.text = dic["TITLE"] as? String
            }
            var readStr = dic["READED"] as NSString
            if(readStr == "0"){
                titleLabel.textColor = UIColor.redColor()
            }
            titleLabel.font = _globaluifont
            cell.contentView.addSubview(titleLabel)
            //time
            var timeLabel: UILabel = UILabel(frame: CGRectMake(150, 40, width - 160, 20))
            timeLabel.text = dic["NOWTIMES"] as? String
            timeLabel.font = UIFont.systemFontOfSize(14)
            timeLabel.textAlignment = NSTextAlignment.Right
            cell.contentView.addSubview(timeLabel)
            //notice's type
            var typeLabel: UILabel = UILabel(frame: CGRectMake(30, 40, 100, 15))
            typeLabel.text = dic["NAME"] as? String
            typeLabel.font = _globaluifont
            cell.contentView.addSubview(typeLabel)
            //user info
            var addressLabel: UILabel = UILabel(frame: CGRectMake(30, 65, 100, 20))
            addressLabel.text = dic["UNIT"] as? String
            addressLabel.font = _globaluifont
            cell.contentView.addSubview(addressLabel)
            var nameLabel: UILabel = UILabel(frame: CGRectMake(130, 65, 100, 20))
            nameLabel.text = dic["REALNAME"] as? String
            nameLabel.font = _globaluifont
            cell.contentView.addSubview(nameLabel)
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
           
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "typeID")
            if(indexPath.row == 0){
                cell.contentView.backgroundColor = bgcolorall
                //cell didSelected color
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = bgcolorall
                
                cell.textLabel?.text = "选择操作"
                cell.textLabel?.font = uifont2
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.textLabel?.textAlignment = NSTextAlignment.Center
            }else if(indexPath.row == typeArr.count + 2){
                cell.contentView.backgroundColor = UIColor.lightGrayColor()
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = UIColor.lightGrayColor()
                cell.textLabel?.text = "取消"
                cell.textLabel?.font = uifont2
                cell.textLabel?.textAlignment = NSTextAlignment.Center
            }else if(indexPath.row == 1){
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = "全部"
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.textLabel?.font = _globaluifont
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
            }
            else
            {
                var dic = self.typeArr[indexPath.row - 2] as NSDictionary
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                var str = dic["NAME"] as NSString
                cell.textLabel?.text = "  \(str)"
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.textLabel?.font = _globaluifont
                cell.selectedBackgroundView = UIView(frame: cell.frame)
                cell.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
            }
            return cell

        }
    }
  
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 101)
        {
            return 90
        }
        else if(tableView.tag == 102)
        {
            return 50;
        }else{
            return (height - 190)/(CGFloat)(typeArr.count + 3)
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 101){
            var dic = self.dataArray[indexPath.row] as NSDictionary
            var vc:NoticeDetailViewController = NoticeDetailViewController();
            vc.noticeID = dic["ID"] as? String
            vc.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if(tableView.tag == 102){
            jumpothersPage(indexPath.row)
        }else if(tableView.tag == 103){
            
                self.nowPage = 1
                if(indexPath.row != 0 ){
                    typeTableView.hidden = true
                    if(indexPath.row == 1){
                        self.dataArray.removeAllObjects()
                        self.nowID = "0"
                        self.loadData()
                    }
                    else if(indexPath.row != typeArr.count + 2)
                    {
                        var dic = self.typeArr[indexPath.row - 2] as NSDictionary
                        self.dataArray.removeAllObjects()
                        self.nowID = dic["ID"] as NSString
                        self.loadData()
                    }
                }
            
        }
        
    }
   
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
    //MARK:BUTTON CLICK
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
        self.typeTableView.hidden = !self.typeTableView.hidden
        }
    }
   
    //MARK:REFRESH DATA
    func setupRefresh(){
        self.MainTableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.dataArray.removeAllObjects()
                self.nowPage = 1
                self.loadData()
            })
        })
        //footer refresh
        self.MainTableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowPage++
                self.loadData()
                self.MainTableView.footerEndRefreshing()
            })
            
        })
        
    }
    
    
}
