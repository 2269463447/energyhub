//
//  EHKeyboardTopToolbar.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/28.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia


class EHKeyboardTopToolbar: UIView {

    var onUndo: (() -> Void)?
    var onRedo: (() -> Void)?
    var onImage: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = .white
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        self.layer.shadowColor = UIColor(hex: "#978C81").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 12

        let undoButton = makeButton(imageName: "arrow.uturn.left", action: #selector(undoTapped))
        let redoButton = makeButton(imageName: "arrow.uturn.right", action: #selector(redoTapped))
        let imageButton = makeButton(imageName: "photo", action: #selector(imageTapped))

        let stack = UIStackView(arrangedSubviews: [undoButton, redoButton, imageButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false

        subviews(stack)
        stack.top(0).bottom(0).right(24)
        stack.Left == self.CenterX + 20
    
    }

    private func makeButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: imageName)
        button.setImage(image, for: .normal)
        button.width(24).height(20)
        button.tintColor = .darkGray
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func undoTapped() {
        onUndo?()
    }

    @objc private func redoTapped() {
        onRedo?()
    }

    @objc private func imageTapped() {
        onImage?()
    }
}
