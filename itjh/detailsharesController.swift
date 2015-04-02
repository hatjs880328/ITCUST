//
//  detailsharesController.swift
//  oa
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class detailsharesController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {

    //params
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var textarea = UIView(frame: CGRectZero)
    
    var id = ""
    var idgo = ""
    var arraylist:NSArray = []
    
    var titlelabel = UILabel(frame: CGRectZero)
    var topleftview = UILabel(frame: CGRectZero)
    var toprightview = UILabel(frame: CGRectZero)
    var contentviewreal = UIWebView(frame: CGRectZero)
    var discussTableview = UITableView(frame: CGRectZero)
    
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
        getload()
        getDiscussInfoData()
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
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "分享详细"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //right button
        let buttonright = UIButton(frame: CGRectMake(width - 40, 10, 30, 40))
        buttonright.setImage(UIImage(named: "pinglun.png"), forState: UIControlState.Normal)
        buttonright.addTarget(self, action: "pressEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(buttonright)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self.textarea.backgroundColor = UIColor.whiteColor()
        self._midbigView.addSubview(textarea)
        
        midviewSetting2()
    }
    
    //all info set.schema
    func midviewSetting2(){
        //title
        titlelabel = UILabel(frame: CGRectMake(0, 0, width, 30))
        titlelabel.font = UIFont(name: "Arial-BoldItalicMT", size: 20)
        titlelabel.textColor = _globalBgcolor
        titlelabel.textAlignment = NSTextAlignment.Center
        textarea.addSubview(titlelabel)
        //depart line
        let view = UIView(frame: CGRectMake(0, 31, width, 1))
        view.backgroundColor = UIColor.blackColor()
        textarea.addSubview(view)
        //content
        let contentview = UIView(frame: CGRectMake(0, 32, width, height/2))
        //left
        let frame1 = CGRectMake(10, 0, 100, 25)
        self.topleftview.frame = frame1
        self.topleftview.text = "..."
        self.topleftview.font = _globaluifont
        self.topleftview.textColor = UIColor.blackColor()
        contentview.addSubview(topleftview)
        //right
        let frame2 = CGRectMake(width-150, 0 , 150, 25)
        self.toprightview.frame = frame2
        self.toprightview.font = _globaluifont
        self.toprightview.textColor = UIColor.blackColor()
        contentview.addSubview(toprightview)
        //webview
        var frame3 = CGRectMake(10, 30, width - 20, height/2 - 30)
        self.contentviewreal.frame = frame3
        contentview.addSubview(contentviewreal)
        textarea.addSubview(contentview)
        //discuss info
        let view1 = UILabel(frame: CGRectMake(0, 32 + height/2, width, 28))
        view1.backgroundColor = UIColor.whiteColor()
        view1.textColor = _globalBgcolor
        view1.textAlignment = NSTextAlignment.Center
        view1.text = "所有评论"
        view1.font = UIFont(name: "Arial-BoldItalicMT", size: 18)
        textarea.addSubview(view1)
        //depart line2
        let view3 = UIView(frame: CGRectMake(0, 60 + height/2, width, 1))
        view3.backgroundColor = UIColor.blackColor()
        textarea.addSubview(view3)
        //discuss detail info
        let frametable = CGRectMake(0, 61 + height/2, width, height/2 - _globalNavviewHeight - 81)
        self.discussTableview.frame = frametable
        self.discussTableview.delegate = self
        self.discussTableview.dataSource = self
        self.discussTableview.separatorColor = _globalBgcolor
        textarea.addSubview(discussTableview)
    }
    
    func getload(){
        let Parameters3 = [
            "id":"\(self.id)","random":"4","pagerJson":"{\"pageIndex\":\"3\",\"pageSize\":\"55\"}","type":"{}"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/GetWorkShareByID",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSDictionary{
                        let ar = statusesArray["rows"] as NSDictionary
                        //title
                        self.titlelabel.text = ar["SHARETHEME"] as? String
                        //gly
                        var xxzxla = ar["Publisher"] as NSDictionary
                        self.topleftview.text = xxzxla["RealName"] as? String
                        //time
                        self.toprightview.text = ar["SHARETIME"] as? String
                        //webview
                        var cont: AnyObject = ar["SHARECONTENT"]!
                        self.contentviewreal.loadHTMLString("\(cont)", baseURL: nil)
                    }
                }
        }
    }
    
    func getDiscussInfoData(){
        let Parameters3 = [
            "id":"\(self.id)","random":"4","pagerJson":"{\"pageIndex\":\"1\",\"pageSize\":\"55\"}","type":"{}"
        ]
        Alamofire.request(.POST,
            "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/GetCommentByDfid",parameters: Parameters3)
            .responseString{(request,response,string4,error) in
                if(string4 != nil){
                    var nsdata = string4?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    if let statusesArray = jsonObject as? NSDictionary{
                        let ar = statusesArray["rows"] as NSArray
                        if(ar.count != 0){
                        var content = ar[0] as NSDictionary
                        self.arraylist = ar
                            //println(ar)
                        var content1 = content["comment"] as NSArray
                        self.discussTableview.reloadData()
                            
                        }
                    }
                }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        println(self.arraylist.count)
        return self.arraylist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "discussDetailCell")
        if(self.arraylist.count != 0 )
        {
            var data = self.arraylist[indexPath.row] as NSDictionary
            //println(data)
            self.idgo = data["ID"] as String!
            var content = UILabel(frame: CGRectMake(15, 5, width/2, 25))
            content.font = _globaluifont
            content.text = data["CONTENT"] as? String
            cell.addSubview(content)
            var time = UILabel(frame: CGRectMake(width - 140, 5, 140, 25))
            time.font = _globaluifont
            time.text = data["CREATETIME"] as? String
            cell.addSubview(time)
            var com = UILabel(frame: CGRectMake(15, 30, width/2, 25))
            com.font = _globaluifont
                var dic = data["CreaterEmp"] as NSDictionary
                com.text = dic["RealName"] as? String
            cell.addSubview(com)
            var discount = UILabel(frame: CGRectMake(width - 140, 30, 140, 25))
            discount.font = _globaluifont
                var content1 = data["comment"] as NSArray
            discount.text = "回复（\(content1.count)）"
            discount.textColor = _globalBgcolor
            cell.addSubview(discount)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.arraylist.count != 0){
            var con = discussDetailController()
            //con.arraylt = self.arraylist
            var data = self.arraylist[indexPath.row] as NSDictionary
            //id can't change
            con.id = self.id
            con.idgo = data["ID"] as String
            con.data = data
            con.modalTransitionStyle = _globalCustomviewchange
            self.presentViewController(con, animated: true, completion: nil)
        }else{
            println("don't press me")
        }
    }
    
    //MARK:ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = shareInfoController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //add research info.
    func pressEdit(sender:UIButton){
        let alert = UIAlertView()
        alert.title = "回复评论"
        alert.delegate = self
        alert.addButtonWithTitle("好的")
        alert.addButtonWithTitle("取消")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    //add content aciton
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var text = alertView.textFieldAtIndex(0)?.text
        if(buttonIndex == 0){
            let Parameters3 = [
                "random":"555","comment":"{\"Content\":\"\(text!)\"}","workshareid":"\(self.id)","commID":"{}","type":"1"
            ]
            Alamofire.request(.POST,
                "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/AddComment",parameters: Parameters3)
                .responseString{(request,response,string4,error) in
                    if(string4 != nil){
                        println(text!)
                        self.getDiscussInfoData()
                    }
            }
        }else{
            alertView.hidden = true
        }
    }


}
