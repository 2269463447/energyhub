//
//  ChargeInfoSheetViewController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/1.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHChargeSheetController: EHBaseSheetController, UITextFieldDelegate {
    
    var onConfirm: ((String, String) -> Void)?  // 回调：金额 + 原因
    
    private let amountField = UITextField()
    private let reasonField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText = "收费详情"
        height = 288
        setUI()
        amountField.delegate = self
        reasonField.delegate = self
    }
    
    func setUI() {
        // 收费金额
        let amountTitle = UILabel()
        amountTitle.text = "收费金额："
        amountTitle.font = .systemFont(ofSize: 14)
        amountTitle.textColor = UIColor(hex: "#333333")
        
        let yuanLabel = UILabel()
        yuanLabel.text = "元"
        yuanLabel.font = .systemFont(ofSize: 14)
        yuanLabel.textColor = UIColor(hex: "#BCBCBC")
        let yuanView = UIView()
        yuanView.height(44).width(40)
        yuanView.subviews(yuanLabel)
        yuanLabel.centerInContainer()
        amountField.attributedPlaceholder = NSAttributedString(
            string: "收费金额",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        amountField.height(44)
        amountField.backgroundColor = UIColor(hex: "#FAFAF8")
        amountField.layer.cornerRadius = 8
        amountField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        amountField.rightView = yuanView
        amountField.leftViewMode = .always
        amountField.rightViewMode = .always
        amountField.keyboardType = .decimalPad
        amountField.font = .systemFont(ofSize: 14)
        
        
        // 收费原因
        let reasonTitle = UILabel()
        reasonTitle.text = "收费方式及收费原因说明："
        reasonTitle.font = .systemFont(ofSize: 14)
        reasonTitle.textColor = UIColor(hex: "#333333")
        
        reasonField.attributedPlaceholder = NSAttributedString(
            string: "请输入原因，30字以内",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        reasonField.height(44)
        reasonField.backgroundColor = UIColor(hex: "#FAFAF8")
        reasonField.layer.cornerRadius = 8
        reasonField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        reasonField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        reasonField.leftViewMode = .always
        reasonField.rightViewMode = .always
        reasonField.font = .systemFont(ofSize: 14)
        
        whiteView.subviews(amountTitle,amountField,reasonTitle,reasonField)
        whiteView.layout(
            |-16-amountTitle-16-|,
              4,
              |-16-amountField-16-|,
              16,
              |-16-reasonTitle-16-|,
              4,
              |-16-reasonField-16-|
        )
        
        amountTitle.Top == titleLabel.Bottom + 14
    }
    
    override func commit() {
        guard let amount = amountField.text, !amount.isEmpty else {
            showHUD(view: self.view, text: "请输入金额")
            return
        }
        guard let reason = reasonField.text, !reason.isEmpty else {
            showHUD(view: self.view, text: "请说明收费原因")
            return
        }
        
        guard isValidNumber(amount) else {
            showHUD(view: self.view, text: "请输入正确的金额")
            return
        }
        onConfirm?(amount,reason)
        
        super.commit()
    }
    
    func isValidNumber(_ text: String) -> Bool {
        let pattern = "^-?\\d+(\\.\\d+)?$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex?.firstMatch(in: text, options: [], range: range) != nil
    }
    // MARK: - delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == reasonField {
            // 获取当前文本内容
            let currentText = textField.text ?? ""
            
            // 计算变更后的文本
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // 限制最大 30 个字符
            return updatedText.count <= 30
        }
        return true
    }
}
