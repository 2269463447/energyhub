//
//  EHSelectThemeController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/3.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHSelectThemeController: EHBaseViewController {

    var completion: ((ActivityTheme, [ActivityTag]) -> Void)?

    private var selectedTheme: ActivityTheme?
    private var selectedTags: [ActivityTag] = []

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let confirmButton = UIButton(type: .system)
    
    let themeCustom = EHDashedInputView(placeholder: "自定义主题（最多4个字）", isTheme: true)
    let tagCustom = EHDashedInputView(placeholder: "自定义标签（最多4个字）", isTheme: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "活动主题/标签"
        view.backgroundColor = UIColor(hex: "#FAFAF8")
        themeCustom.textField.delegate = self
        tagCustom.textField.delegate = self
        setupUI()
        needNav = false
    }

    func setupUI() {
        scrollView.backgroundColor = .clear
        contentView.axis = .vertical
        contentView.spacing = 16

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 6),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24)
        ])

        // 添加主题选择区块（OC无allCases，需要自己维护数组）
        let themes: [ActivityTheme] = [
            .juHuiJiaoYou, .lvYouChuXing, .yueQiTiYan,
            .laoNianJiaoYou, .yiQiJianShen, .jiNengPeiXun,
            .hangYeJiaoLiu, .xiangQinJiaoYou, .duShuHui,
            .chuangYeJiaoLiu, .yiQiGongYi, .dianShangJiaoLiu,
            .qinZiTiYan, .shangJiaDaCu, .mianFeiJiNeng
        ]

        let themeButtons = themes.map { theme in
            createTagButton(title: ActivityThemeTitle(theme)) { [weak self] in
                self?.selectTheme(theme, button: $0)
            }
        }
        contentView.addArrangedSubview(createSection(
            title: "活动主题",
            tip: "只可选择1个主题",
            tags: themeButtons,
            isTheme: true)
        )

        // 标签选择区块（同样自维护）
        let tags: [ActivityTag] = (0...17).compactMap { ActivityTag(rawValue: $0) }
        let tagButtons = tags.map { tag in
            createTagButton(title: ActivityTagTitle(tag)) { [weak self] in
                self?.toggleTag(tag, button: $0)
            }
        }
        contentView.addArrangedSubview(createSection(
            title: "活动标签",
            tip: "最多可选择3个标签",
            tags: tagButtons,
            isTheme: false)
        )

        // 确认按钮
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.backgroundColor = UIColor(hex: "#FF8F21")
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)

        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    func createSection(title: String, tip: String, tags: [UIView], isTheme: Bool) -> UIView {
        let container = UIStackView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.axis = .vertical
        container.spacing = 16

        let titleView = UIView()

        let mainTitleLabel = UILabel()
        mainTitleLabel.text = title
        mainTitleLabel.textColor = UIColor(hex: "#333333")
        mainTitleLabel.font = .boldSystemFont(ofSize: 16)

        let tipLabel = UILabel()
        tipLabel.text = tip
        tipLabel.textColor = UIColor(hex: "#999999")
        tipLabel.font = .systemFont(ofSize: 12)
        
        titleView.subviews(mainTitleLabel,tipLabel)
        titleView.layout(
            16,
            |-8-mainTitleLabel,
            0
        )
        tipLabel.Left == mainTitleLabel.Right + 8
        tipLabel.Bottom == mainTitleLabel.Bottom

        let tagWrap = WrapStackView(spacing: 12, lineSpacing: 12)
        tags.forEach { tagWrap.addArrangedSubview($0) }

        container.addArrangedSubview(titleView)
        container.addArrangedSubview(tagWrap)
        let customView = UIView()
        if isTheme {
            customView.subviews(themeCustom)
            customView.layout(
                0,
                |-8-themeCustom-8-|,
                16
            )
        }else {
            customView.subviews(tagCustom)
            customView.layout(
                0,
                |-8-tagCustom-8-|,
                16
            )
        }
        container.addArrangedSubview(customView)
        return container
    }

    func createTagButton(title: String, action: @escaping (ActionButton) -> Void) -> ActionButton {
        let button = ActionButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(hex: "#F6F6F6")
        button.width((ScreenWidth - 64) / 4).height(40)
        button.layer.cornerRadius = 10
        button.setAction(action)
        return button
    }

    func selectTheme(_ theme: ActivityTheme, button: UIButton) {
        if selectedTheme == theme {
            selectedTheme = nil
            resetButtonStyle(button)
        } else {
            if selectedTheme != nil {
                showHUD(view: self.view, text: "只可选择1个主题")
                return
            }
            selectedTheme = theme
            applySelectedStyle(to: button)
        }
    }

    func toggleTag(_ tag: ActivityTag, button: UIButton) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
            resetButtonStyle(button)
        } else {
            if selectedTags.count >= 3 {
                showHUD(view: self.view, text: "最多可选择3个主题")
                return
            }
            selectedTags.append(tag)
            applySelectedStyle(to: button)
        }
    }
    
    func applySelectedStyle(to button: UIButton) {
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
    }
    
    func resetButtonStyle(_ button: UIButton) {
        button.backgroundColor = UIColor(hex: "#F6F6F6")
        button.setTitleColor(UIColor(hex: "#333333"), for: .normal)
    }

    @objc func confirmAction() {
        guard let theme = selectedTheme else {
            showHUD(view: self.view, text: "请选择活动主题")
            return
        }

        // 检查自定义主题文本长度
        if theme == .ziDingYi {
            let text = themeCustom.textField.text ?? ""
            if text.count > 4 {
                showHUD(view: self.view, text: "自定义主题最多4个字")
                return
            }
        }

        // 检查自定义标签文本长度
        if selectedTags.contains(.ziDingYi) {
            let text = tagCustom.textField.text ?? ""
            if text.count > 4 {
                showHUD(view: self.view, text: "自定义标签最多4个字")
                return
            }
        }

        completion?(theme, selectedTags)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EHSelectThemeController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == themeCustom.textField {
            if selectedTheme != nil {
                if selectedTheme == .ziDingYi {
                    themeCustom.updateSelected(false)
                    return true
                }
                showHUD(view: self.view, text: "只可选择一个主题")
                return false
            }
        } else if textField == tagCustom.textField {
            if selectedTags.contains(.ziDingYi) {
                tagCustom.updateSelected(false)
                return true
            }
            if selectedTags.count >= 3 {
                showHUD(view: self.view, text: "最多可选择3个标签")
                return false
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == themeCustom.textField {
            if let text = textField.text, !text.isEmpty {
                themeCustom.updateSelected(true)
                selectedTheme = .ziDingYi
            } else {
                themeCustom.updateSelected(false)
                selectedTheme = nil
            }
        } else if textField == tagCustom.textField {
            if let text = textField.text, !text.isEmpty {
                if !selectedTags.contains(.ziDingYi) {
                    selectedTags.append(.ziDingYi)
                }
                tagCustom.updateSelected(true)
            } else {
                selectedTags.removeAll { $0 == .ziDingYi }
                tagCustom.updateSelected(false)
            }
        }
    }
    
}

// MARK: - 中间的按钮组

class WrapStackView: UIView {
    
    private var spacing: CGFloat
    private var lineSpacing: CGFloat
    private var arrangedSubviews: [UIView] = []
    private let sidePadding: CGFloat = 8
    private let itemHeight: CGFloat = 40
    private let itemsPerRow: Int = 4

    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 12) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addArrangedSubview(_ view: UIView) {
        arrangedSubviews.append(view)
        addSubview(view)
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let totalWidth = bounds.width
        let totalSpacing = spacing * CGFloat(itemsPerRow - 1)
        let totalPadding = sidePadding * 2
        let itemWidth = (totalWidth - totalSpacing - totalPadding) / CGFloat(itemsPerRow)
        
        var x = sidePadding
        var y: CGFloat = 0

        for (index, subview) in arrangedSubviews.enumerated() {
            subview.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            
            if (index + 1) % itemsPerRow == 0 {
                x = sidePadding
                y += itemHeight + lineSpacing
            } else {
                x += itemWidth + spacing
            }
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let rowCount = Int(ceil(Double(arrangedSubviews.count) / Double(itemsPerRow)))
        let totalHeight = CGFloat(rowCount) * itemHeight + CGFloat(max(0, rowCount - 1)) * lineSpacing
        return CGSize(width: size.width, height: totalHeight)
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    }
}

// MARK: - 主题标签按钮

class ActionButton: UIButton {
    private var actionHandler: ((ActionButton) -> Void)?

    func setAction(_ action: @escaping (ActionButton) -> Void) {
        self.actionHandler = action
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        actionHandler?(self)
    }
}

// MARK: - 自定义按钮

class EHDashedInputView: UIView {
    
    private let iconImageView = UIImageView()
    let textField = UITextField()
    private let dashedLayer = CAShapeLayer()
    
    private let isTheme: Bool
    private var isSelected: Bool = false

    // MARK: - Init
    init(placeholder: String, isTheme: Bool) {
        self.isTheme = isTheme
        super.init(frame: .zero)
        setupUI(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI(placeholder: String) {
        backgroundColor = UIColor(hex: "#F6F6F6")
        layer.cornerRadius = 10
        layer.masksToBounds = true
        self.height(40)

        // 虚线边框
        dashedLayer.lineDashPattern = [4, 2]
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.lineWidth = 1
        dashedLayer.strokeColor = UIColor(hex: "#CCCCCC").cgColor
        layer.addSublayer(dashedLayer)

        // 图标
        iconImageView.image = UIImage(named: "theme_add")
        iconImageView.tintColor = UIColor(hex: "#BCBCBC")
        iconImageView.contentMode = .scaleAspectFit

        // 输入框
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        
        
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .mainColor

        subviews(iconImageView, textField)
        iconImageView.size(12)
        iconImageView.centerVertically().left(16)
        textField.Left == iconImageView.Right + 8
        textField.centerVertically().right(12)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashedLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }

    // MARK: - Selection State
    func updateSelected(_ selected: Bool) {
        isSelected = selected
        if selected {
            dashedLayer.strokeColor = UIColor.mainColor.cgColor
            iconImageView.tintColor = UIColor.mainColor
            textField.textColor = UIColor.mainColor
            iconImageView.image = UIImage(named: "theme_add_s")
        } else {
            textField.text = ""
            dashedLayer.strokeColor = UIColor(hex: "#CCCCCC").cgColor
            iconImageView.tintColor = UIColor(hex: "#BCBCBC")
            textField.textColor = UIColor(hex: "#BCBCBC")
            iconImageView.image = UIImage(named: "theme_add")
        }
    }
}
