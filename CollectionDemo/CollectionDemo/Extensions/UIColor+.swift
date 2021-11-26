//
//  UIColor+.swift
//  CollectionDemo
//
//  Created by 杨馥瑞 on 2021/11/26.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        get {
            let red   = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue  = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
}
