//
//  EHContactSheetController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/1.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHContactSheetController: EHBaseSheetController {
    
    private let nameField = UITextField()
    private let contactField = UITextField()
    var onConfirm: ((String, String) -> Void)?  //回调 姓名、联系方式

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText = "联系方式"
        height = 276
        setUI()
    }
    
    func setUI() {
        // 收费金额
        let nameTitle = UILabel()
        nameTitle.text = "姓名："
        nameTitle.font = .systemFont(ofSize: 14)
        nameTitle.textColor = UIColor(hex: "#333333")
        
        nameField.attributedPlaceholder = NSAttributedString(
            string: "请输入姓名",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        nameField.height(44)
        nameField.backgroundColor = UIColor(hex: "#FAFAF8")
        nameField.layer.cornerRadius = 8
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        nameField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        nameField.leftViewMode = .always
        nameField.rightViewMode = .always
        nameField.font = .systemFont(ofSize: 14)
        
        
        // 收费原因
        let reasonTitle = UILabel()
        reasonTitle.text = "手机号/微信号："
        reasonTitle.font = .systemFont(ofSize: 14)
        reasonTitle.textColor = UIColor(hex: "#333333")
        
        contactField.attributedPlaceholder = NSAttributedString(
            string: "请输入联系方式",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        contactField.height(44)
        contactField.backgroundColor = UIColor(hex: "#FAFAF8")
        contactField.layer.cornerRadius = 8
        contactField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        contactField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        contactField.leftViewMode = .always
        contactField.rightViewMode = .always
        contactField.font = .systemFont(ofSize: 14)
        
        whiteView.subviews(nameTitle,nameField,reasonTitle,contactField)
        whiteView.layout(
            |-16-nameTitle-16-|,
              4,
              |-16-nameField-16-|,
              16,
              |-16-reasonTitle-16-|,
              4,
              |-16-contactField-16-|
        )
        
        nameTitle.Top == titleLabel.Bottom + 14
    }
    
    override func commit() {
        guard let name = nameField.text, !name.isEmpty else {
            showHUD(view: self.view, text: "请输入姓名")
            return
        }
        guard let contact = contactField.text, !contact.isEmpty else {
            showHUD(view: self.view, text: "请输入联系方式")
            return
        }
        
        onConfirm?(name,contact)
        
        super.commit()
    }

}
