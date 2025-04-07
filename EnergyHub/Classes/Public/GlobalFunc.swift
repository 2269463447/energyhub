//
//  GlobalFunc.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/1.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import Foundation

public func showHUD(view: UIView, text: String) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.mode = .text
    hud.contentColor = .white
    hud.label.text = text
    hud.hide(animated: true, afterDelay: 1.5)
}
