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
    
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
    
}
