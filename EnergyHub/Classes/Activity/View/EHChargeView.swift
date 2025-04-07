//
//  EHChargeView.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/29.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia
import SnapKit

class EHChargeView: UIView {
    
    var chargeBlock: (() -> Void)?
    var freeBlock: (() -> Void)?
    var isFree: Bool = true {
        didSet {
            self.updateUI(isFree)
        }
    }
    
    let freeBtn = UIButton(type: .custom)
    let chargeBtn = UIButton(type: .custom)
    let titleLabel = UILabel()
    
    let freeLabel = UILabel()
    let chargeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        titleLabel.text = "活动是否收费："
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = .regular(14)
        
        freeBtn.setImage(UIImage(named: "icon_unselected"), for: .normal)
        freeBtn.setImage(UIImage(named: "icon_selected"), for: .selected)
        freeBtn.isSelected = true
        freeBtn.isUserInteractionEnabled = false
        
        chargeBtn.setImage(UIImage(named: "icon_unselected"), for: .normal)
        chargeBtn.setImage(UIImage(named: "icon_selected"), for: .selected)
        chargeBtn.isUserInteractionEnabled = false
        
        freeLabel.text = "免费"
        freeLabel.font = .regular(14)
        freeLabel.textColor = UIColor(hex: "#FF8F21")
        
        chargeLabel.text = "收费"
        chargeLabel.font = .regular(14)
        chargeLabel.textColor = UIColor(hex: "#BCBCBC")
        
        let freeView = UIView()
        freeView.subviews(freeBtn,freeLabel)
        freeView.layout(
            |-0-freeBtn-5-freeLabel.top(0).bottom(0)-0-|
        )
        let freeTap = UITapGestureRecognizer(target: self, action: #selector(tapFree))
        freeView.addGestureRecognizer(freeTap)
        
        let chargeView = UIView()
        chargeView.subviews(chargeBtn,chargeLabel)
        chargeView.layout(
            |-0-chargeBtn-5-chargeLabel.top(0).bottom(0)-0-|
        )
        let chargeTap = UITapGestureRecognizer(target: self, action: #selector(tapCharge))
        chargeView.addGestureRecognizer(chargeTap)
        
        
        self.subviews(titleLabel,freeView,chargeView)
        self.layout(
            |-12-titleLabel.top(12).bottom(12)-0-freeView-24-chargeView-(>=10)-|
        )
        
        
    }
    
    func updateUI(_ isFree: Bool) {
        freeBtn.isSelected = isFree
        freeLabel.textColor = isFree ? UIColor(hex: "#FF8F21") : UIColor(hex: "#BCBCBC")
        
        chargeBtn.isSelected = !isFree
        chargeLabel.textColor = isFree ? UIColor(hex: "#BCBCBC") : UIColor(hex: "#FF8F21")
    }
    
    
    
    @objc func tapFree() {
        isFree = true
        freeBlock?()
    }
    
    @objc func tapCharge() {
        isFree = false
        chargeBlock?()
    }
}
