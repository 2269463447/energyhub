//
//  EHRichTextInputView.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/28.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit

class EHRichTextInputView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    /// 图文内容（富文本）
    var richContent: NSAttributedString {
        return textView.attributedText
    }

    // MARK: - Public Components
    let textView = UITextView()
    private let placeholderLabel = UILabel()
    weak var parentViewController: UIViewController?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.delegate = self

        let toolbar = EHKeyboardTopToolbar()
        toolbar.onUndo = { [weak self] in self?.undoAction() }
        toolbar.onRedo = { [weak self] in self?.redoAction() }
        toolbar.onImage = { [weak self] in self?.insertImageAction() }

        textView.inputAccessoryView = toolbar

        placeholderLabel.text = "请输入活动详情..."
        placeholderLabel.textColor = UIColor(hex: "#BCBCBC")
        placeholderLabel.font = .systemFont(ofSize: 14)
        placeholderLabel.height(33)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textView)
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: NavBarHeight+2),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5)
        ])

        updatePlaceholderVisibility()
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }

    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    // MARK: - Public Method to Insert Image
    func insertImageFromLibrary() {
        guard let parentVC = parentViewController else { return }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        parentVC.present(picker, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            insertImageIntoTextView(image: image)
        }
    }

    // MARK: - Insert Image Logic
    private func insertImageIntoTextView(image: UIImage) {
        let attachment = NSTextAttachment()
        let maxWidth = textView.frame.width - 24
        let ratio = image.size.height / image.size.width
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: maxWidth, height: maxWidth * ratio)

        // 设置段落样式（让图片那一行居中）
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let imageAttr = NSAttributedString(attachment: attachment)
        let centeredAttr = NSMutableAttributedString(attributedString: imageAttr)
        centeredAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: centeredAttr.length))

        let newLine = NSAttributedString(string: "\n")
        
        let currentText = NSMutableAttributedString(attributedString: textView.attributedText)
        let cursorPosition = textView.selectedRange.location

        currentText.insert(newLine, at: cursorPosition)
        currentText.insert(centeredAttr, at: cursorPosition)
        currentText.insert(newLine, at: cursorPosition)

        textView.attributedText = currentText
        textView.selectedRange = NSRange(location: cursorPosition + 2, length: 0)

        updatePlaceholderVisibility()
    }

    func undoAction() {
        print("撤销")
        textView.undoManager?.undo()
        updatePlaceholderVisibility()
    }

    func redoAction() {
        print("重做")
        textView.undoManager?.redo()
        updatePlaceholderVisibility()
    }

    func insertImageAction() {
        print("选择图片")
        insertImageFromLibrary()
    }
    
    func setContent(content: NSAttributedString) {
        textView.attributedText = content
        updatePlaceholderVisibility()
    }
}
