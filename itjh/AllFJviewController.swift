//
//  AllFJviewController.swift
//  itjh
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015 All rights reserved.
//

import UIKit

class AllFJviewController: UIViewController {

    var button: HamburgerButton! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 38.0 / 255, green: 151.0 / 255, blue: 68.0 / 255, alpha: 1)
        self.button = HamburgerButton(frame: CGRectMake(133, 133, 54, 54))
        self.button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        var lab = customalertviewone()
        lab.frame = CGRectMake(0, 0, 150, 150)
        self.view.addSubview(lab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return .LightContent
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }

}
