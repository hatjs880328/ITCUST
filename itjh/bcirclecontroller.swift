//
//  bcirclecontroller.swift
//  itjh
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class bcirclecontroller: UIViewController {

    var width:CGFloat = 0
    var height:CGFloat = 0
    var view3 = UIView(frame: CGRectZero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.bounds.width
        self.height = self.view.bounds.height
        self.view.backgroundColor = UIColor.whiteColor()
        zLastview()
        get()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func get(){
        var dr = drawView()
        self.view.addSubview(dr)
    }
    
    
    //最外的一个LAYER添加一个VIEW (小邮箱的图标）
    func zLastview(){
        view3 = UIView(frame: CGRectMake(width-100, height-90, 40, 40))
        var postview = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        postview.image = UIImage(named: "about.png")
        view3.addSubview(postview)
        self.view.addSubview(view3)
        //给他添加手势，让他移动
        var getture = UIPanGestureRecognizer(target: self, action: "getturepress:")
        view3.addGestureRecognizer(getture)
    }
    //小邮箱拖动的事件
    func getturepress(sender:UIPanGestureRecognizer){
        var point = sender.translationInView(self.view) as CGPoint
        //println(point)
        var xxx = sender.view?.center.x
        var yyy = sender.view?.center.y
        sender.view?.center = CGPointMake( xxx! + point.x, yyy! + point.y)
        sender.setTranslation(CGPointZero, inView: self.view)
    }

}
