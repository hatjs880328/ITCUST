//
//  detaillpic.swift
//  itjh
//  the recursion -> solve the problem 
//  Created by apple on 15/3/30.
//  Copyright (c) 2015年 com.jndz.mrshan. All rights reserved.
//

import Foundation

class detaillpic{
    func dothePic(str:NSMutableString)->String{
        if(str != ""){
            if(str.containsString("src=\"/")){
                var aaa:NSRange = str.rangeOfString("src=\"/")
                var m :Int = aaa.location + aaa.length
                str.insertString("http://\(_globaleIpstring):\(_globalPortstring)", atIndex: m - 1)
                dothePic(str)
            }
        }
        return str
    }
}
