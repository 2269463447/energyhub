//
//  GlobalValues.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/27.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
// MARK: - mark

// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width
// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height
// 导航栏高度
public let NavBarHeight = UIApplication.shared.statusBarFrame.height + 44


//字体
extension UIFont {
    public class func regular(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Regular", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func light(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Light", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func semibold(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Semibold", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func medium(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Medium", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func din(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "DIN Condensed", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func dinBlack(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "DINAlternate-Bold", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
}
