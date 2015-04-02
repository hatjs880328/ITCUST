//
//  shareInfoController.swift
//  oa
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class shareInfoController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //params
    var stringarr = [String]()
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont2 = UIFont(name: "Arial-BoldItalicMT", size: 16)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var textarea = UIView(frame: CGRectZero)
    
    var midtableview = UITableView(frame: CGRectZero)
    var nowpage = 1
    var arraylist:NSMutableArray = []
    var allarrayData:NSMutableArray = []
    var lastview = UITableView(frame: CGRectZero)
    var flag = 0
    
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
        loadData4()
        hidtableview()
        setupRefresh()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK:VIEW SET
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
    
    func loadData4(){
        let Parameters3 = [
            "page":"\(nowpage)","rows":"15"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/MyAttentionWorkShareList",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    self.arraylist = jsonObject["rows"] as NSMutableArray
                    self.allarrayData.addObjectsFromArray(self.arraylist)
                    self.midtableview.reloadData()
                    self.midtableview.headerEndRefreshing()
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
        label.text = "分享"
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
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
        addTableview()
    }
    
    func addTableview(){
        let frame = CGRectMake(0, 0, width, self.textarea.bounds.height)
        self.midtableview.frame = frame
        self.midtableview.tag == 404
        self.midtableview.delegate = self
        self.midtableview.dataSource = self
        self.midtableview.separatorColor = bgcolorall
        var swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "midscrollright1:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.midtableview.addGestureRecognizer(swipeLeftGesture)
        self.textarea.addSubview(midtableview)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == self.midtableview.tag){
            return self.allarrayData.count
        }else{
            return 11
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == self.midtableview.tag){
            var data = self.allarrayData[indexPath.row] as NSDictionary
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "shareInfocell")
            let imageview = UIImageView(frame: CGRectMake(5, 10, 20, 20))
            imageview.image = UIImage(named: "share_icon2.png")
            cell.addSubview(imageview)
            //title
            let titlelabel = UILabel(frame: CGRectMake(45, 5, width/2 - 30, 25))
            titlelabel.text = data["SHARETHEME"] as? String
            titlelabel.font = _globaluifont
            cell.addSubview(titlelabel)
            //time
            let timelabel = UILabel(frame: CGRectMake(width - 136, 5, 136, 25))
            timelabel.text = data["SHARETIME"] as? String
            timelabel.font = _globaluifont
            cell.addSubview(timelabel)
            //publisher
            let xxzx = UILabel(frame: CGRectMake(45, 31, width/3, 25))
            var xxzxla = data["Publisher"] as NSDictionary
            xxzx.text = xxzxla["RealName"] as? String
            xxzx.font = _globaluifont
            cell.addSubview(xxzx)
            //push ad
            let push = UILabel(frame: CGRectMake(width/3*2, 31, width/3, 25))
            push.textColor = _globalBgcolor
            push.font = uifont1
            push.text = "评论（..）"
            cell.addSubview(push)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            var id = data["ID"] as? String
            let Parameters3 = [
                "id":"\(id!)","random":"4","pagerJson":"{\"pageIndex\":\"1\",\"pageSize\":\"20\"}","type":"{}"
            ]
            Alamofire.request(.POST,
                "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/GetCommentByDfid",parameters: Parameters3)
                .responseString{(request,response,string4,error) in
                    if(string4 != nil){
                        var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                        let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                        if let statusesArray = jsonObject as? NSDictionary{
                            let ar = statusesArray["rows"] as NSArray
                            //println(ar)
                            if(ar.count != 0){
                                push.text = "评论（\(ar.count)）"
                            }else{
                                push.text = "评论（0）"
                            }
                        }
                    }
            }
            return cell
        }else{
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
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == self.midtableview.tag){
            return 60
        }else
        {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == self.midtableview.tag){
        var id = self.allarrayData[indexPath.row] as NSDictionary
        var idnew = id["ID"] as? String
        var con = detailsharesController()
        con.id = idnew!
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
        }
        else{
        jumpothersPage(indexPath.row)
        }
    }
    
    
    //MARK: ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        if(self.flag == 0){
        var frameshow = CGRectMake(-0, 70, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            }, completion: nil)
            self.flag = 1
        }else{
            var frameshow = CGRectMake(-150, 70, 150, height-130)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.lastview.frame = frameshow
                }, completion: nil)
            self.flag = 0
        }
    }
    
    func pressEdit(sender:UIButton){
        var con = addnewcOntroller()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func jumpMainview(){
        var con = mainController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //tableview left swap
    func midscrollright(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-150, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            }, completion: nil)
        flag = 0
    }
    
    //tableview right swap
    func midscrollright1(sender:UISwipeGestureRecognizer){
        var frameshow = CGRectMake(-0, 90, 150, height-130)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.lastview.frame = frameshow
            }, completion: nil)
        flag = 1
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
    
    //refresh the tableview
    func setupRefresh(){
        self.midtableview.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowpage = 1
                self.allarrayData.removeAllObjects()
                self.loadData4()
            })
        })
        //bot refresh
        self.midtableview.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.nowpage++
                self.loadData4()
                self.midtableview.footerEndRefreshing()
            })
            
        })
    }
    
    

}
