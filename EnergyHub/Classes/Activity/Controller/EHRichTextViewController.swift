//
//  EHRichTextViewController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/28.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHRichTextViewController: EHBaseViewController {

    let textView = EHRichTextInputView()
    var richContent: NSAttributedString?
    var saveBlock : ((NSAttributedString) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑活动详情"
        view.backgroundColor = .white
        setUI()
        setTextView()
        
        needNav = false
    }
    
    func setUI() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("保存", for: .normal)
        saveButton.tintColor = .mainColor
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }

    func setTextView() {
        textView.parentViewController = self
        view.subviews(textView)
        view.layout(
            0,
            |-12-textView-12-|
        )
        textView.Bottom == view.safeAreaLayoutGuide.Bottom - 16
        
        if let richContent = richContent {
            self.textView.setContent(content: richContent)
        }
    }
   
    @objc func saveButtonTapped() {
        print("点击了保存")
        self.saveBlock?(textView.richContent)
        navigationController?.popViewController(animated: true)
    }
    
}
