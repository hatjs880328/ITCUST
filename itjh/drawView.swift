//
//  drawView.swift
//  itjh
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015 All rights reserved.
//

import UIKit

class drawView: UIView {
    
    override func drawRect(rect: CGRect) {
        drawRectangle()
    }
    
    
    func drawRectangle(){
        var rectangle = CGRectMake(100, 290, 120, 25);
        var ctx = UIGraphicsGetCurrentContext();
        CGContextAddRect(ctx, rectangle);
        CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor);
        CGContextFillPath(ctx)
    }

}
