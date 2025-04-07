//
//  EHThemeAndTagView.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHThemeView: UIView {
    
    var type: ActivityTheme!
    private let gradientLayer = CAGradientLayer()  // ✅ 渐变层

    @objc init(type: ActivityTheme) {
        super.init(frame: .zero)
        self.type = type
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        self.height(16)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true

        // ✅ 设置渐变色
        gradientLayer.colors = [
            UIColor(hex: "#FF6227").cgColor,
            UIColor(hex: "#FFB45F").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)

        // ✅ 文本标签
        let titleLabel = UILabel()
        titleLabel.text = ActivityThemeTitle(type)
        titleLabel.textColor = .white
        titleLabel.font = .regular(10)

        self.subviews(titleLabel)
        self.layout(
            |-8-titleLabel.centerVertically()-8-|
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds  // ✅ 自动适配 frame
    }
}


class EHTagView: UIView {
    var type: ActivityTag!
    @objc init(type: ActivityTag) {
        super.init(frame: .zero)
        self.type = type
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.height(16)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = ActivityTagBackgroundColor(type)
        
        let titleLabel = UILabel()
        titleLabel.text = ActivityTagTitle(type)
        titleLabel.textColor = ActivityTagTextColor(type)
        titleLabel.font = .regular(10)
        
        self.subviews(titleLabel)
        self.layout(
            |-8-titleLabel.centerVertically()-8-|
        )
    }
    
}
