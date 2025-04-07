//
//  EHBaseSheetController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/1.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHBaseSheetController: UIViewController {
    
    let overlayView = UIView()
    let whiteView = UIView()
    let titleLabel = UILabel()
    var height: CGFloat = 278 {
        didSet {
            whiteView.snp.remakeConstraints { make in
                make.left.right.equalTo(self.view)
                make.top.equalTo(self.view.snp.bottom)
                make.height.equalTo(height)
            }
        }
    }
    var completion: (() -> Void)?
    var cancelBlock: (() -> Void)?
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    var cancelBtn = UIButton(type: .custom)
    var okBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear  // 背景设置透明
        setupOverlayView()
        setupPickerView()
    }
    

    // MARK: - 半透明背景遮罩
    func setupOverlayView() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        overlayView.addGestureRecognizer(tapGesture)
    }
    // MARK: - 白色视图

    func setupPickerView() {
        whiteView.backgroundColor = .white
        whiteView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        whiteView.layer.cornerRadius = 12
        
        self.view.subviews(whiteView)
        whiteView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.height.equalTo(height)
            make.top.equalTo(self.view.snp.bottom)
        }
        
        titleLabel.font = .regular(18)
        titleLabel.textColor = UIColor(hex: "#333333")
        
        cancelBtn.setImage(UIImage(named: "icon_cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        okBtn.setTitle("确认", for: .normal)
        okBtn.layer.cornerRadius = 20
        okBtn.width(240).height(40)
        okBtn.backgroundColor = .mainColor
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.addTarget(self, action: #selector(commit), for: .touchUpInside)
        
        whiteView.subviews(titleLabel,cancelBtn,okBtn)
        whiteView.layout(
            titleLabel.centerHorizontally().top(11)-(>=10)-cancelBtn-16-|
        )
        okBtn.centerHorizontally().bottom(22)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         // 从屏幕下方动画弹出
        UIView.animate(withDuration: 0.3, animations: {
            self.whiteView.transform = CGAffineTransform(translationX: 0, y: -self.height)
        })
    }
    
    @objc func dismissPicker() {
        completion?()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
            self.whiteView.transform = .identity  // 返回到原始位置
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func cancel() {
        cancelBlock?()
        dismissPicker()
    }
    
    @objc func commit() {
        dismissPicker()
    }

}
