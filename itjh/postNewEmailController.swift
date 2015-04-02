//
//  postNewEmailController.swift
//  oa
//  无论是回复邮件，回复所有人，转发还是新建一个邮件，都跳转到这个界面，
//  当是回复的时候，需要把原始的信件信息传输过来，并显示 flag ！＝ 0
//  选择人的时候，原先的人会被消除掉
//
//  信件邮件的时候就传输一个flag = 0 就行
//  Created by apple on 15/3/18.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class postNewEmailController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    //params
    //0 new 1 post 2 post all 3 scro post
    var flag = 0
    var rowFlag = 0
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
    var midtableview = UITableView(frame: CGRectZero)
    var dicmain:NSDictionary = NSDictionary()
    var allID:NSMutableArray = []
    let label = UILabel(frame: CGRectZero)
    let label1 = UILabel(frame: CGRectZero)
    let label2 = UILabel(frame: CGRectZero)
    var path = ""
    var contenttt2 = UITextView(frame: CGRectZero)
    let labelzt3 = UITextField(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载...";
        hud.dimBackground = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        setDataback()
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
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
        label.text = "发送邮件"
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
        buttonright.setImage(UIImage(named: "im_select.png"), forState: UIControlState.Normal)
        buttonright.addTarget(self, action: "pressEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(buttonright)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self._midbigView.addSubview(textarea)
        midTableviewSetting()
    }
    
    func midTableviewSetting(){
        var frame = CGRectMake(0, 0, width, height - _globalNavviewHeight - 20)
        self.midtableview.frame = frame
        self.midtableview.delegate = self
        self.midtableview.dataSource = self
        self.midtableview.tag = 99
        self.midtableview.separatorColor = _globalBgcolor
        self.textarea.addSubview(midtableview)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag == 99){
            if(self.flag == 0){
                return 6
            }else{
                return 7
            }
        }else{
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag == 99){
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "emaildetailinfotableivewcell")
             label.frame = CGRectMake(12, 12, width - 100, 25)
             label1.frame = CGRectMake(12, 12, width - 100, 25)
             label2.frame = CGRectMake(12, 12, width - 100, 25)
            // index 0
            if(indexPath.row == 0){
                label.font = uifont1
                cell.addSubview(label)
                var jh = UIButton(frame: CGRectMake(width - 45, 5, 45, 40))
                jh.backgroundColor = UIColor(patternImage: UIImage(named: "btn_browser.png")!)
                if(self.flag == 0){
                    //new post
                    cell.addSubview(jh)
                    var aa = ""
                    for (var i = 0 ; i < nameall.count;i++){
                        aa += "\(nameall[i] as String),"
                    }
                    label.text = "收件人：\(aa)"
                }else if(self.flag == 3){
                    //scor post
                    label.text = "收件人："
                    cell.addSubview(jh)
                }else{
                    var name = self.dicmain["ACCEPTREALNAME"] as? String
                    if(name != nil){
                        name = name!
                    }else{
                        name = ""
                    }
                    label.text = "收件人：\(name!)"
                    cell.addSubview(jh)
                }
                jh.addTarget(self, action: "pressnewpost0:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            //index 1
            if(indexPath.row == 1){
                label1.font = uifont1
                cell.addSubview(label1)
                var jh = UIButton(frame: CGRectMake(width - 45, 5, 45, 40))
                jh.backgroundColor = UIColor(patternImage: UIImage(named: "btn_browser.png")!)
                if(self.flag == 0){
                    var aa = ""
                    for (var i = 0 ; i < nameall1.count;i++){
                        aa += "\(nameall1[i] as String),"
                    }
                    label1.text = "抄送人：\(aa)"
                    cell.addSubview(jh)
                }else if(self.flag == 3){
                    //scor post
                    label.text = "抄送人："
                    cell.addSubview(jh)
                }else{
                    //scor
                    var chaosongperson = self.dicmain["CHAOSONGREALNAME"] as? String
                    if(chaosongperson != nil){
                        chaosongperson = chaosongperson!
                    }else{
                        chaosongperson = ""
                    }
                    label1.text = "抄送人：\(chaosongperson!)"
                    cell.addSubview(jh)
                }
                jh.addTarget(self, action: "pressnewpost1:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            //index 2 misong
            if(indexPath.row == 2){
                label2.font = uifont1
                cell.addSubview(label2)
                var jh = UIButton(frame: CGRectMake(width - 45, 5, 45, 40))
                jh.backgroundColor = UIColor(patternImage: UIImage(named: "btn_browser.png")!)
                if(self.flag == 0){
                    var aa = ""
                    for (var i = 0 ; i < nameall2.count;i++){
                        aa += "\(nameall2[i] as String),"
                    }
                    label2.text = "密送人：\(aa)"
                    cell.addSubview(jh)
                }else if(self.flag == 3){
                    //scor post
                    label.text = "密送人："
                    cell.addSubview(jh)
                }else{
                    //MISONGREALNAME
                    var chaosongperson = self.dicmain["MISONGREALNAME"] as? String
                    if(chaosongperson != nil){
                        chaosongperson = chaosongperson!
                    }else{
                        chaosongperson = ""
                    }
                    label2.text = "密送人：\(chaosongperson!)"
                    cell.addSubview(jh)
                }
                jh.addTarget(self, action: "pressnewpost2:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            //main theme index 3
            if(indexPath.row == 3){
                var tilb = UILabel(frame: CGRectMake(12, 12, 50, 25))
                tilb.font = uifont1
                tilb.text = "主题："
                var name = self.dicmain["TITLE"] as? String
                if(name != nil){
                    name = name!
                }else{
                    name = ""
                }
                labelzt3.frame = CGRectMake(54, 12, width - 10, 25)
                labelzt3.text = "\(name!)"
                labelzt3.font = uifont1
                self.labelzt3.delegate = self
                cell.addSubview(labelzt3)
                cell.addSubview(tilb)
            }
            if(indexPath.row == 4){
                //fj
                let labelfj = UILabel(frame: CGRectMake(12, 12, width - 10, 25))
                labelfj.text = "附件："
                labelfj.font = uifont1
                cell.addSubview(labelfj)
            }
            if(indexPath.row == 5){
                //comment
                var nowheight:CGFloat = 0
                if(self.flag == 0){
                    nowheight = 240
                }else{
                    nowheight = 90
                }
                contenttt2 = UITextView(frame: CGRectMake(5, 5, width - 10, nowheight))
                contenttt2.textAlignment = NSTextAlignment.Justified
                contenttt2.text = ""
                contenttt2.backgroundColor = _globalgraycolor
                contenttt2.layer.cornerRadius = 8
//                var push = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//                //设置手势点击数,双击：点2下
//                push.numberOfTapsRequired = 2
//                self.contenttt2.addGestureRecognizer(push)
                cell.addSubview(contenttt2)
            }
            if(indexPath.row == 6){
                println(">>>>")
                println(self.dicmain)
                //comment CHAOSONGREALNAME
                var chaosongperson = self.dicmain["CHAOSONGREALNAME"] as? String
                if(chaosongperson != nil){
                    chaosongperson = chaosongperson!
                }else{
                    chaosongperson = ""
                }
                var postperson = self.dicmain["SENDREALNAME"] as? String
                if(postperson != nil){
                    postperson = postperson!
                }else{
                    postperson = ""
                }
                var acceptperson = self.dicmain["ACCEPTREALNAME"] as? String
                if(acceptperson != nil){
                    acceptperson = acceptperson!
                }else{
                    acceptperson = ""
                }
                var time = self.dicmain["ITIMES"] as? String
                if(time != nil){
                    time = time!
                }else{
                    time = ""
                }
                var CONTENT = self.dicmain["CONTENT"] as? String
                if(CONTENT != nil){
                    CONTENT = CONTENT!
                }else{
                    CONTENT = ""
                }
                var NAME = self.dicmain["TITLE"] as? String
                if(NAME != nil){
                    NAME = NAME!
                }else{
                    NAME = ""
                }
                var contenttt = UIWebView(frame: CGRectMake(5, 5, width - 10, 140))
                //contenttt.textAlignment = NSTextAlignment.Justified
                 var TEXT = "----原始邮件----<br/>收件人：\(acceptperson!)<br/>发件人：\(postperson!)<br/>抄送人：\(chaosongperson!)<br/>主题：\(NAME!)<br/>内容：\(CONTENT!)<br/>发送时间：\(time!)"
                contenttt.loadHTMLString(TEXT, baseURL: nil)
                cell.addSubview(contenttt)
            }
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "emaildetailinfotableivewcell1")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.tag == 99){
            if(indexPath.row < 5){
                return 50
            }else if(indexPath.row == 5){
                if(self.flag == 0){
                    return 250
                }else{
                    return 100
                }
            }else{
                return 150
            }
        }else{
            return 50
        }
    }
    
    func setDataback(){
        if(self.allID.count == 0){
           //do nothing.
        }else{
            if(self.rowFlag == 0){
                for (var i = 0 ; i < self.allID.count ; i++){
                    var name = self.allID[i] as NSString
                    var name1 = name.substringFromIndex(37)
                    var id1 = name.substringToIndex(36)
                    nameall.addObject(name1)
                    idall.addObject(id1)
                }
            }else if(self.rowFlag == 1){
                for (var i = 0 ; i < self.allID.count ; i++){
                    var name = self.allID[i] as NSString
                    var name1 = name.substringFromIndex(37)
                    var id1 = name.substringToIndex(36)
                    nameall1.addObject(name1)
                    idall1.addObject(id1)
                }
                
            }else if(self.rowFlag == 2){
                for (var i = 0 ; i < self.allID.count ; i++){
                    var name = self.allID[i] as NSString
                    var name1 = name.substringFromIndex(37)
                    var id1 = name.substringToIndex(36)
                    nameall2.addObject(name1)
                    idall2.addObject(id1)
                }
            }
        }
    }
    
    //MARK:ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = emailController()
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressEdit(sender:UIButton){
        //post email
        var getidall = ""
        for var i = 0 ; i < idall.count ; i++ {
            if(i == 0){
                getidall = idall[0] as String
            }else{
                getidall = "\(getidall),\(idall[i] as String)"
            }
        }
        var getidall1 = ""
        for var i = 0 ; i < idall1.count ; i++ {
            if(i == 0){
                getidall1 = idall1[0] as String
            }else{
                getidall1 = "\(getidall1),\(idall1[i] as String)"
            }
        }
        var getidall2 = ""
        for var i = 0 ; i < idall2.count ; i++ {
            if(i == 0){
                getidall2 = idall2[0] as String
            }else{
                getidall2 = "\(getidall2),\(idall2[i] as String)"
            }
        }
        var getnameall = ""
        for var i = 0 ; i < nameall.count ; i++ {
            if(i == 0){
                getnameall = nameall[0] as String
            }else{
                getnameall = "\(getnameall),\(nameall[i] as String)"
            }
        }
        var getnameall1 = ""
        for var i = 0 ; i < nameall1.count ; i++ {
            if(i == 0){
                getnameall1 = nameall1[0] as String
            }else{
                getnameall1 = "\(getnameall1),\(nameall1[i] as String)"
            }
        }
        var getnameall2 = ""
        for var i = 0 ; i < nameall2.count ; i++ {
            if(i == 0){
                getnameall2 = nameall2[0] as String
            }else{
                getnameall2 = "\(getnameall2),\(nameall2[i] as String)"
            }
        }
        var nameallold = self.dicmain["ACCEPTREALNAME"] as? String
        var idallold = self.dicmain["ACCEPTUSERNAME"] as? String
        //if not go the selectperson page.
        println(idallold)
        if(getidall.isEmpty && idallold != nil ){
            getidall = idallold!
            getnameall = nameallold!
        }
        if(getidall.isEmpty || contenttt2.text!.isEmpty || labelzt3.text!.isEmpty){
            var alert = UIAlertView(title: "⚠警示", message: "请将信息填写完整！", delegate: self, cancelButtonTitle: "好")
            alert.show()
        }else{
            //println(nameall2)
            let Parameters3 = ["item":"{\"ID\":\"null\",\"ACCEPTUSERNAME\":\"\(getidall)\",\"ACCEPTREALNAME\":\"\(getnameall)\",\"CHAOSONGUSERNAME\":\"\(getidall1)\",\"CHAOSONGREALNAME\":\"\(getnameall1)\",\"MISONGUSERNAME\":\"\(getidall2)\",\"MISONGREALNAME\":\"\(getnameall2)\",\"TITLE\":\"\(labelzt3.text!)\",\"CONTENT\":\"\(contenttt2.text!)\"}"]
            //println(Parameters3)
            Alamofire.request(.POST,
                "http://\(_globaleIpstring):\(_globalPortstring)/NbMail/NbMailAcceeptInsert",parameters: Parameters3)
                .responseString{(request,response,string4,error) in
                    if(string4 != nil){
                        println(string4)
                        if(string4! == "true"){
                            var alert = UIAlertView(title: "提醒", message: "发送成功！", delegate: self, cancelButtonTitle: "好")
                            alert.show()
                            var con = emailController()
                            con.modalTransitionStyle = _globalCustomviewchange
                            self.presentViewController(con, animated: true, completion: nil)
                        }else{
                            var alert = UIAlertView(title: "⚠ 警示", message: "发送失败！", delegate: self, cancelButtonTitle: "好")
                            alert.show()
                        }
                        
                    }
            }
        }
    }
    
    func pressnewpost0(sender:UIButton){
        var con = selectPersonController()
        con.rowflag = 0
        nameall.removeAllObjects()
        idall.removeAllObjects()
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressnewpost1(sender:UIButton){
        var con = selectPersonController()
        con.rowflag = 1
        nameall1.removeAllObjects()
        idall1.removeAllObjects()
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    func pressnewpost2(sender:UIButton){
        var con = selectPersonController()
        nameall2.removeAllObjects()
        idall2.removeAllObjects()
        con.rowflag = 2
        con.path = self.path
        con.dicmain = self.dicmain
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
//    func handleTapGesture(sender:UITapGestureRecognizer){
//        println("push")
//        self.contenttt2.resignFirstResponder()
//    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
