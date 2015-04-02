//
//  approveController.swift
//  itjh
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit
import Alamofire

class approveController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    //params
    var menuFlag = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var textarea = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var searchview = UIView(frame: CGRectZero)
    var stringarr = [String]()
    var lastview = UITableView(frame: CGRectZero)
    var arrayData:NSMutableArray = []
    var allarrayData:NSMutableArray = []
    var midtableview = UITableView(frame: CGRectZero)
    var page0 = 1
    var page1 = 1
    var page2 = 1
    var whichsegment = 0
    var segment = UISegmentedControl()
    var getdataflag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        hidtableview()
        setupRefresh()
        if(whichsegment == 0){
            getData("\(whichsegment)",url:"WorkFlow/AddWorkFlow/getDanBanANADDWORKLIST")
            self.segment.selectedSegmentIndex = 0
        }
        else if(whichsegment == 1){
            getData("\(whichsegment)",url:"WorkFlow/AddWorkFlow/selectybldistinct")
            self.segment.selectedSegmentIndex = 1
        }else{
            getData("\(whichsegment)",url:"WorkFlow/WorkFlowList/WorkFlowListYWT")
            self.segment.selectedSegmentIndex = 2
        }
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SETTING.
    func getData(id:String,url:String){
        getdataflag = 1
        var Parameters1 = [
            "":""
        ]
        if(id == "0"){
            Parameters1 = ["NAME":"","page":"\(page0)","rows":"15"]
        }else if(id == "1"){
            Parameters1 = ["NAME":"","page":"\(page1)","rows":"15"]
        }else{
            Parameters1 = ["NAME":"","page":"\(page2)","rows":"15"]
        }
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/\(url)",
            parameters: Parameters1)
            .responseString{(request,response,string4,error) in
                if(string4 != nil && string4 != "[]"){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    var arr = jsonObject["rows"] as NSMutableArray
                    //println(arr)
                    self.arrayData = arr
                    self.allarrayData.addObjectsFromArray(self.arrayData)
                    self.midtableview.reloadData()
                    self.midtableview.headerEndRefreshing()
                    self.getdataflag = 0
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
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "审批"
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
        var searchview = UIView(frame: CGRectMake(0, 0, width, 30))
        searchview.backgroundColor = _globalgraycolor
        self.textarea.addSubview(searchview)
        var searchfield = UITextField(frame: CGRectMake(2, 2, width - 4, 26))
        searchfield.font = _globaluifont
        let leftpic = UIImageView(frame: CGRectMake(12, 2, 28, 23))
        leftpic.image = UIImage(named: "im_search.png")
        searchfield.leftView = leftpic
        searchfield.leftViewMode = UITextFieldViewMode.Always
        searchfield.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        searchfield.backgroundColor = UIColor.whiteColor()
        searchfield.layer.cornerRadius = 7
        searchfield.text = "搜索"
        searchfield.delegate = self
        searchview.addSubview(searchfield)
        //table mid setting.
        midtableview.frame = CGRectMake(0, 30, width, height - 20 - _globalNavviewHeight - 30 - 30)
        midtableview.delegate = self
        midtableview.dataSource = self
        midtableview.separatorColor = _globalBgcolor
        self.textarea.addSubview(midtableview)
        //segment setting.
        segment = UISegmentedControl(items: ["代办","已办","已委托"])
        segment.addTarget(self, action: "segmentVchange:", forControlEvents: UIControlEvents.ValueChanged)
        segment.frame = CGRectMake(0, height - 31, width, 30)
        segment.tintColor = _globalBgcolor
        self.view.addSubview(segment)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 20){
            return 11
        }else{
            return allarrayData.count
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
            let labeltitle = UILabel(frame: CGRectMake(5, 5, self.width - 10, 20))
            var title1 = indexpathData["NAME"] as? String
            var time = indexpathData["NOWTIMES"] as? String
            labeltitle.text = "\(title1!) \(time!)"
            labeltitle.font = _globaluifont
            cell.addSubview(labeltitle)
            //time REALNAME
            let labeltime = UILabel(frame: CGRectMake(5, 26, width/2-20, 20))
            labeltime.text = indexpathData["FQREALNAME"] as? String
            labeltime.font = _globaluifont
            cell.addSubview(labeltime)
            //person
            let labelperson = UILabel(frame: CGRectMake(5, 48, width/2, 25))
            labelperson.text = indexpathData["NODENAME"] as? String
            labelperson.font = _globaluifont
            cell.addSubview(labelperson)
            //unit STATE
            let labelunit = UILabel(frame: CGRectMake(width - 105, 48, 100, 25))
            labelunit.text = indexpathData["STATE"] as? String
            labelunit.font = _globaluifont
            labelunit.textAlignment = NSTextAlignment.Center
            labelunit.textColor = _globalBgcolor
            cell.addSubview(labelunit)
            return cell
        }
    }
    
    //tableView did
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 20){
            jumpothersPage(indexPath.row)
        }else
        {
            var index = indexPath.row
            var data = self.allarrayData[indexPath.row] as NSDictionary
            
            if(self.whichsegment == 0){
                var con = spdetailinfoController()
                con.topdic = data
                con.modalTransitionStyle = _globalCustomviewchange
                self.presentViewController(con, animated: true, completion: nil)
            }else if(self.whichsegment == 1){
                var con = ybdetailinfoController()
                con.modalTransitionStyle = _globalCustomviewchange
                con.topdic = data
                self.presentViewController(con, animated: true, completion: nil)
            }else{
                var con = ywtdetailinfoController()
                con.topdic = data
                con.modalTransitionStyle = _globalCustomviewchange
                self.presentViewController(con, animated: true, completion: nil)
            }
        }
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
    
    func segmentVchange(sender:UISegmentedControl){
        self.allarrayData.removeAllObjects()
        
        if(sender.selectedSegmentIndex == 0 && self.getdataflag == 0){
            self.whichsegment = 0
            getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/getDanBanANADDWORKLIST")
        }else if(sender.selectedSegmentIndex == 1 && self.getdataflag == 0){
            self.whichsegment = 1
            getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/selectybldistinct")
        }else if(sender.selectedSegmentIndex == 2 && self.getdataflag == 0){
            self.whichsegment = 2
            getData("\(self.whichsegment)",url:"WorkFlow/WorkFlowList/WorkFlowListYWT")
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    //refresh the tableview
    func setupRefresh(){
        self.midtableview.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.allarrayData.removeAllObjects()
                if(self.whichsegment == 0 && self.getdataflag == 0){
                    self.page0 = 1
                    self.getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/getDanBanANADDWORKLIST")
                }else if(self.whichsegment == 1 && self.getdataflag == 0){
                    self.page1 = 1
                    self.getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/selectybldistinct")
                }else if(self.whichsegment == 2 && self.getdataflag == 0){
                    self.page2 = 1
                    self.getData("\(self.whichsegment)",url:"WorkFlow/WorkFlowList/WorkFlowListYWT")
                }
            })
        })
        //bot refresh
        self.midtableview.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                if(self.whichsegment == 0 && self.getdataflag == 0){
                    self.page0++
                    self.getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/getDanBanANADDWORKLIST")
                }else if(self.whichsegment == 1 && self.getdataflag == 0){
                    self.page1++
                    self.getData("\(self.whichsegment)",url:"WorkFlow/AddWorkFlow/selectybldistinct")
                }else if(self.whichsegment == 2 && self.getdataflag == 0){
                    self.page2++
                    self.getData("\(self.whichsegment)",url:"WorkFlow/WorkFlowList/WorkFlowListYWT")
                }
                self.midtableview.footerEndRefreshing()
            })
            
        })
    }

}
