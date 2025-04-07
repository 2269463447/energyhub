//
//  UIColor+Extension.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/27.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static var mainColor:UIColor{
        UIColor(hex: "#FF8F21")
    }
}
