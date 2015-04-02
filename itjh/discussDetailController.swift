//
//  discussDetailController.swift
//  oa
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit
import Alamofire

class discussDetailController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {

    //params
    var width:CGFloat = 0
    var height:CGFloat = 0
    var topView = UIView(frame: CGRectZero)
    var _midbigView = UIView(frame: CGRectZero)
    var bgcolorall = UIColor(red: 85/255, green: 169/255, blue: 254/255, alpha: 1)
    var uifont1 = UIFont(name: "Arial-BoldItalicMT", size: 14)
    var textarea = UIView(frame: CGRectZero)
    
    var tableviewdetail = UITableView(frame: CGRectZero)
    var arraylt:NSArray = []
    var arraylt1:NSArray = []
    var id = ""
    var idgo = ""
    var data:NSDictionary = NSDictionary()
    
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
        getdata()
        WidthHeightSetting()
        topviewSetting()
        midviewSetting()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    
    //MARK: VIEW SETTING START.
    func getdata(){
        var provideArray = self.data["comment"] as? NSArray
        println(provideArray)
        self.arraylt1 = provideArray!
        self.tableviewdetail.reloadData()
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
    }
    
    func midviewSetting(){
        _midbigView.frame = CGRectMake(0, 20, width, height-20)
        self.view.addSubview(_midbigView)
        //nav setting.
        let view = UIView(frame: CGRectMake(0, 0, width, _globalNavviewHeight))
        view.backgroundColor = bgcolorall
        self._midbigView.addSubview(view)
        var label = UILabel(frame: CGRectMake(width/6, 15, width/3*2, 25))
        label.text = "回复"
        label.textAlignment = NSTextAlignment.Center
        label.font = uifont1
        view.addSubview(label)
        //left button
        var button2 = UIButton(frame: CGRectMake(10, 15, 25, 25))
        button2.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        button2.addTarget(self, action: "pressshowall:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button2)
        //right button
        let buttonright = UIButton(frame: CGRectMake(width - 40, 10, 40, 40))
        buttonright.setImage(UIImage(named: "pinglun.png"), forState: UIControlState.Normal)
        buttonright.addTarget(self, action: "pressEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(buttonright)
        //midwebview
        var frame3 = CGRectMake(0, _globalNavviewHeight, width, height - _globalNavviewHeight - 20)
        self.textarea.frame = frame3
        self.textarea.backgroundColor = UIColor.whiteColor()
        self._midbigView.addSubview(textarea)
        makeTableviewsetting()
    }
    
    func makeTableviewsetting(){
        var frame = CGRectMake(0, 0, width, height - _globalNavviewHeight - 20 )
        self.tableviewdetail.frame = frame
        self.textarea.addSubview(tableviewdetail)
        self.tableviewdetail.delegate = self
        self.tableviewdetail.dataSource = self
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arraylt1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "discussDetailtableivewcell1")
        if(self.arraylt1.count != 0){
            var data = self.arraylt1[indexPath.row] as NSDictionary
            //content
            var content = UILabel(frame: CGRectMake(15, 5, width/2, 25))
            content.font = _globaluifont
            content.text = data["CONTENT"] as? String
            cell.addSubview(content)
            //time
            var time = UILabel(frame: CGRectMake(width - 140, 5, 140, 25))
            time.font = _globaluifont
            time.text = data["CREATETIME"] as? String
            cell.addSubview(time)
            //com
            var com = UILabel(frame: CGRectMake(15, 30, width/2, 25))
            com.font = _globaluifont
            var dic = data["CreaterEmp"] as NSDictionary
            com.text = dic["RealName"] as? String
            cell.addSubview(com)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    //MARK: ACTION BUTTONS.
    func pressshowall(sender:UIButton){
        var con = detailsharesController()
        con.id = self.id
        con.modalTransitionStyle = _globalCustomviewchange
        self.presentViewController(con, animated: true, completion: nil)
    }
    
    //show alertview
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
                "random":"555","comment":"{\"Content\":\"\(text!)\"}","workshareid":"\(self.idgo)","commID":"\(self.idgo)","type":"comm"
            ]
            Alamofire.request(.POST,
                "http://\(_globaleIpstring):\(_globalPortstring)/MicroMIS/WorkShare/AddComment",parameters: Parameters3)
                .responseString{(request,response,string4,error) in
                    if(string4 != nil){
                        //self.tableviewdetail.reloadData()
                        //refresh goto up page.
                        var con = detailsharesController()
                        con.id = self.id
                        con.modalTransitionStyle = _globalCustomviewchange
                        self.presentViewController(con, animated: true, completion: nil)
                    }
            }
        }else{
            alertView.hidden = true
        }
    }

}
