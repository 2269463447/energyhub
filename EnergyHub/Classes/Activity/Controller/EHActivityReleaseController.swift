//
//  UIZxView.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/26.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import EasyListView
import Stevia

class EHActivityReleaseController: EHBaseViewController {
    
//    var service = EHActivityService()
    ///活动的海报
    var posterView = UIImageView()
    let placeholderView = UIView()
    ///活动标题
    let titleTextField = UITextField()
    let titleCount = UILabel()
    ///活动详情
    let textView = UITextView()
    ///活动开始时间
    let startTimeLabel = UILabel()
    ///活动结束时间
    let endTimeLabel = UILabel()
    let chargeView = EHChargeView()
    let chargeStackView = UIStackView()
    ///是否收费
    var isExpend: Bool = false
    ///收费金额
    var amount: Double = 0.0
    ///收费原因
    var reason: String = ""
    ///姓名
    var name: String = ""
    ///联系方式
    var contact: String = ""
    let contactLabel = UILabel()
    ///地址
    let addressLabel = UILabel()
    ///所选省份
    var province: String = ""
    ///所选城市
    var city: String = ""
    ///所选区
    var district: String = ""
    ///详细地址
    var detailAddress: String = ""
    ///活动视图
    var themeContentView = UIView()
    
    
    let startTimeIcon = UIImageView(image: UIImage(named: "time_picker"))
    let endTimeIcon = UIImageView(image: UIImage(named: "time_picker"))
    let contactIcon = UIImageView(image: UIImage(named: "time_picker"))
    let addressIcon = UIImageView(image: UIImage(named: "time_picker"))
    let themeIcon = UIImageView(image: UIImage(named: "time_picker"))
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日 HH时mm分"
        return formatter
    }
        
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布活动"
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.96, alpha: 1.00)
        
        setUI()
        needNav = true
    }
    
    private func setUI() {
        // 背景视图
        let bgView = UIView()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 16
        view.subviews(bgView)
        view.layout(
            |-0-bgView-0-|,
              0
        )
        bgView.Top == view.safeAreaLayoutGuide.Top
        
        
        // 底部按钮视图
        let bottomView = setBottomView()
        view.subviews(bottomView)
        view.layout(
            |-0-bottomView-0-|,
              0
        )
        bottomView.Top == view.safeAreaLayoutGuide.Bottom - 64
       
        // 滚动视图
        view.subviews(scrollView)
        view.layout(
            |-0-scrollView-0-|
        )
        scrollView.Top == bgView.Top + 12
        scrollView.Bottom == bottomView.Top
        setSubView()
    }
    
    func setSubView() {
        // MARK: - 上传图片
        posterView.backgroundColor = UIColor(hex: "#FAFAF8")
        posterView.layer.masksToBounds = true
        posterView.layer.cornerRadius = 10
        posterView.isUserInteractionEnabled = true
        posterView.contentMode = .scaleAspectFill
        let addPoster = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        posterView.addGestureRecognizer(addPoster)
        posterView.height(160)
        
        let placeholder = UIImageView(image: UIImage(named: "poster_image"))
        let addIcon = UIImageView(image: UIImage(named: "poster_add"))
        
        let posterTitle = UILabel()
        posterTitle.text = "添加海报"
        posterTitle.textColor = UIColor(hex: "#333333")
        posterTitle.font = UIFont.medium(12)
        let tipLabel = UILabel()
        tipLabel.text = "漂亮的海报可以抓住更多眼球哦~"
        tipLabel.textColor = UIColor(hex: "#B9B9B9")
        tipLabel.font = UIFont.medium(9)
        
        let contentView = UIView()
        contentView.subviews(addIcon,posterTitle)
        contentView.layout(
            |-0-addIcon-3-posterTitle.top(0).bottom(0)-0-|
        )
        
        placeholderView.subviews(placeholder,contentView,tipLabel)
        placeholderView.layout(
            0,
            placeholder.centerHorizontally(),
            12,
            contentView.centerHorizontally(),
            4,
            |-0-tipLabel.centerHorizontally()-0-|,
            0
        )
        
        posterView.subviews(placeholderView)
        placeholderView.top(37).centerHorizontally()
        
        self.scrollView.easy.appendView(posterView).insets(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        
        // MARK: - 活动标题
        let titleLabel = creatTitleLabel(text: "活动标题：")
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleTextField.delegate = self
        titleTextField.textColor = UIColor(hex: "#333333")
        titleTextField.font = UIFont.regular(14)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "请输入标题（必填）",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        
        titleCount.text = "0/30"
        titleCount.textColor = UIColor(hex: "#CCCCCC")
        titleCount.font = UIFont.regular(8)
        
        let titleView = UIView()
        titleView.subviews(titleLabel,titleTextField,titleCount)
        titleView.layout(
            |-12-titleLabel-25-titleTextField.top(14)-12-|,
              5,
              titleCount-12-|,
              12
        )
        
        self.scrollView.easy.appendView(titleView).insets(UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
        // MARK: - 活动详情
        let detailLabel = creatTitleLabel(text: "活动详情：")
        let textViewBg = UIView()
        textViewBg.layer.cornerRadius = 8
        textViewBg.backgroundColor = UIColor(hex: "#FAFAF8")
        textViewBg.height(200)
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .clear
        textView.isEditable = false        // 禁止编辑
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.showsVerticalScrollIndicator = false
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(detailViewTapped))
        textView.addGestureRecognizer(detailTap)
        textViewBg.subviews(textView)
        textViewBg.layout(
            8,
            |-5-textView-5-|,
            8
        )

        let detailView = UIView()
        detailView.subviews(detailLabel,textViewBg)
        detailView.layout(
            0,
            |-12-detailLabel-12-|,
            10,
            |-12-textViewBg-12-|,
            0
        )
        self.scrollView.easy.appendView(detailView).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        // MARK: - 活动开始时间选择器
        let startLabel = creatTitleLabel(text: "活动开始时间：")
        startTimeLabel.text = "请选择开始时间"
        startTimeLabel.textColor = UIColor(hex: "#BCBCBC")
        startTimeLabel.font = .regular(14)
        let startTimeView = creatPickerView(titleLabel: startLabel, isStart: true)
        self.scrollView.easy.appendView(startTimeView).insets(UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
        
        let endLabel = creatTitleLabel(text: "活动结束时间：")
        endTimeLabel.text = "请选择结束时间"
        endTimeLabel.textColor = UIColor(hex: "#BCBCBC")
        endTimeLabel.font = .regular(14)
        let endTimeView = creatPickerView(titleLabel: endLabel, isStart: false)
        self.scrollView.easy.appendView(endTimeView).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        // MARK: - 是否收费
        self.scrollView.easy.appendView(chargeView)
            .insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        chargeView.chargeBlock = { [weak self, weak chargeView] in
            guard let self = self, let chargeView = chargeView else { return }
            let originalContentOffset = scrollView.contentOffset
            self.scrollToVisible(view: chargeView, height: 210)
            let vc = EHChargeSheetController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            //成功设置
            vc.onConfirm = { amount, reason in
                self.showDetail(amount: amount, reason: reason)
                self.amount = Double(amount) ?? 0.0
                self.reason = reason
            }
            //取消设置
            vc.cancelBlock = {
                if self.isExpend {
                    return
                }else {
                    self.chargeView.isFree = true
                    for subview in self.chargeStackView.arrangedSubviews {
                        UIView.animate(withDuration: 0.25, animations: {
                            subview.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                            subview.alpha = 0
                        }, completion: { _ in
                            self.chargeStackView.removeArrangedSubview(subview)
                            subview.removeFromSuperview()
                        })
                    }
                }
            }
            //归位
            vc.completion = {
                self.finishScroll(original: originalContentOffset)
            }
            self.present(vc, animated: true, completion: nil)
        }
        chargeView.freeBlock = { [weak self] in
            guard let self = self else { return }
            for subview in self.chargeStackView.arrangedSubviews {
                UIView.animate(withDuration: 0.25, animations: {
                    subview.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                    subview.alpha = 0
                }, completion: { _ in
                    self.chargeStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                })
            }
        }
        
        chargeStackView.axis = .vertical            // 垂直方向排列
        chargeStackView.spacing = 8                 // 子视图之间的间距
        chargeStackView.alignment = .fill           // 子视图横向对齐方式
        chargeStackView.distribution = .fill        // 子视图垂直分布方式
        chargeStackView.translatesAutoresizingMaskIntoConstraints = false
        let chargeInfoView = UIView()
        chargeInfoView.subviews(chargeStackView)
        chargeInfoView.layout(
            0,
            |-12-chargeStackView-12-|,
            0
        )
        self.scrollView.easy.appendView(chargeStackView).insets(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        // MARK: - 联系方式
        let contactTitle = creatTitleLabel(text: "联系方式：")
        let contactView = UIView()
        contactLabel.text = "请选择输入联系方式"
        contactLabel.textColor = UIColor(hex: "#BCBCBC")
        contactLabel.font = .regular(14)
        contactLabel.numberOfLines = 2
        contactTitle.setContentHuggingPriority(.required, for: .horizontal)
        contactIcon.setContentHuggingPriority(.required, for: .horizontal)
        contactView.subviews(contactTitle,contactLabel,contactIcon)
        contactView.layout(
            |-12-contactTitle.top(12)
        )
        contactLabel.top(12).bottom(12)
        contactLabel.Left == contactTitle.Right + 12
        contactLabel.Right == contactIcon.Left - 8
        contactIcon.top(12).right(12)
        let contactTap = UITapGestureRecognizer(target: self, action: #selector(showContactInfo))
        contactView.addGestureRecognizer(contactTap)
        self.scrollView.easy.appendView(contactView).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // MARK: - 活动地址
        let addressTitle = creatTitleLabel(text: "活动地址：")
        let addressView = UIView()
        addressLabel.text = "请选择地址"
        addressLabel.textColor = UIColor(hex: "#BCBCBC")
        addressLabel.font = .regular(14)
        addressLabel.numberOfLines = 2
        addressTitle.setContentHuggingPriority(.required, for: .horizontal)
        addressIcon.setContentHuggingPriority(.required, for: .horizontal)
        addressView.subviews(addressTitle,addressLabel,addressIcon)
        addressView.layout(
            |-12-addressTitle.top(12)
        )
        addressLabel.top(12).bottom(12)
        addressLabel.Left == addressTitle.Right + 12
        addressLabel.Right == addressIcon.Left - 8
        addressIcon.top(12).right(12)
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(showAddressPicker))
        addressView.addGestureRecognizer(addressTap)
        self.scrollView.easy.appendView(addressView).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // MARK: - 主题标签
        let themeTitle = creatTitleLabel(text: "活动主题/标签")
        let themeView = UIView()
        let themeLabel = UILabel()
        themeLabel.text = "请选择主题/标签"
        themeLabel.font = .regular(14)
        themeLabel.textColor = UIColor(hex: "#BCBCBC")
        
        themeContentView.subviews(themeLabel)
        themeLabel.top(0).bottom(0).right(0).left(0)
        themeIcon.setContentHuggingPriority(.required, for: .horizontal)
        themeTitle.setContentHuggingPriority(.required, for: .horizontal)
        themeView.subviews(themeTitle,themeContentView,themeIcon)
        themeView.layout(
            |-12-themeTitle.top(12)
        )
        themeContentView.top(12).bottom(12)
        themeContentView.Left == themeTitle.Right + 12
        themeContentView.Right == themeIcon.Left - 8
        themeIcon.top(12).right(12)
        let themeTap = UITapGestureRecognizer(target: self, action: #selector(toThemeVC))
        themeView.addGestureRecognizer(themeTap)
        
        self.scrollView.easy.appendView(themeView).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    // MARK: - func
    
    private func creatTitleLabel(text: String) -> UILabel{
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = .regular(14)
        return titleLabel
    }
    
    private func creatPickerView(titleLabel: UILabel, isStart: Bool) -> UIView{
        let view = UIView()
        if isStart {
            view.subviews(titleLabel,startTimeLabel,startTimeIcon)
            view.layout(
                12,
                |-12-titleLabel-0-startTimeLabel-(>=5)-startTimeIcon-12-|,
                12
            )
            let startTap = UITapGestureRecognizer(target: self, action: #selector(showStartPicker))
            view.addGestureRecognizer(startTap)
        }else {
            view.subviews(titleLabel,endTimeLabel,endTimeIcon)
            view.layout(
                12,
                |-12-titleLabel-0-endTimeLabel-(>=5)-endTimeIcon-12-|,
                12
            )
            let endTap = UITapGestureRecognizer(target: self, action: #selector(showEndPicker))
            view.addGestureRecognizer(endTap)
        }
        
        return view
    }
    
    private func setBottomView() -> UIView {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.shadowColor = UIColor(hex: "#978C81").cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomView.layer.shadowOpacity = 0.11
        bottomView.layer.shadowRadius = 8
        
        let saveBtn = UIButton(type: .system)
        saveBtn.backgroundColor = UIColor(hex: "#FFFAF6")
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 20
        saveBtn.layer.borderColor = UIColor(hex: "#FF8F21").cgColor
        saveBtn.layer.borderWidth = 1
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveBtn.setTitle("保存并预览", for: .normal)
        saveBtn.setTitleColor(UIColor(hex: "#FF8F21"), for: .normal)
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        let releaseBtn = UIButton(type: .system)
        releaseBtn.backgroundColor = UIColor(hex: "#FF8F21")
        releaseBtn.layer.masksToBounds = true
        releaseBtn.layer.cornerRadius = 20
        releaseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        releaseBtn.setTitle("立即发布", for: .normal)
        releaseBtn.setTitleColor(.white, for: .normal)
        releaseBtn.addTarget(self, action: #selector(releaseAction), for: .touchUpInside)
        bottomView.subviews(saveBtn,releaseBtn)
        
        bottomView.layout(
            12,
            |-12-saveBtn-12-releaseBtn-12-| ~ 40
        )
        saveBtn.Width == releaseBtn.Width
        
        return bottomView
    }
    
    @objc private func saveAction() {
        // 保存并预览操作
    }
    
    @objc private func releaseAction() {
        // 立即发布操作
    }
    // MARK: - 点击上传图片

    @objc func imageViewTapped() {
        // 创建UIImagePickerController并设置它的来源类型为相册
        let vc = EHPosterViewController()
        vc.posterImage = self.posterView.image
        vc.posterBlock = { [weak self] image in
            guard let self = self else{ return }
            posterView.image = image
            placeholderView.isHidden = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func detailViewTapped() {
        let vc = EHRichTextViewController()
        vc.richContent = textView.attributedText
        vc.saveBlock = { [weak self] content in
            self?.textView.attributedText = content
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - 时间选择器

    @objc func showStartPicker(){
        view.endEditing(true)
        let originalContentOffset = scrollView.contentOffset
        scrollToVisible(view: startTimeLabel, height: 252)
        
        let datePickView = BRDatePickerView()
        datePickView.pickerStyle = pickerStyle()
        datePickView.pickerMode = .YMDHM
        datePickView.title =  "请选择开始时间"
        let calendar = Calendar.current
        let now = Date()

        //初始选择
        let cleanedText = startTimeLabel.text
        if let components = cleanedText, components != "请选择开始时间" {
            if let date = formatter.date(from: components) {
                print("解析成功：\(date)")
                datePickView.selectDate = date
            } else {
                datePickView.selectDate = now
                print("解析失败，格式不匹配")
            }
        }else {
            datePickView.selectDate = now
        }
        datePickView.minDate = calendar.date(byAdding: .year, value: -1, to: now)
        datePickView.maxDate = calendar.date(byAdding: .year, value: 10, to: now)
        //回调
        datePickView.resultBlock = { [weak self] selectDate , selectValue in
            if let selectDate = selectDate{
                let timeStr = self?.formatter.string(from: selectDate)
                self?.startTimeLabel.text = timeStr
                self?.startTimeLabel.textColor = UIColor(hex: "#333333")
            }
            UIView.animate(withDuration: 0.3) {
                self?.startTimeIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
            self?.finishScroll(original: originalContentOffset)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.startTimeIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        datePickView.cancelBlock = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.startTimeIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
            self?.finishScroll(original: originalContentOffset)
        }
        datePickView.show()
    }
    
    @objc func showEndPicker(){
        view.endEditing(true)
        let originalContentOffset = scrollView.contentOffset
        scrollToVisible(view: endTimeLabel, height: 252)
        let datePickView = BRDatePickerView()
        datePickView.pickerStyle = pickerStyle()
        datePickView.pickerMode = .YMDHM
        datePickView.title = "请选择结束时间"
        let calendar = Calendar.current
        let now = Date()

        //初始选择
        let cleanedText = endTimeLabel.text
        if let components = cleanedText, components != "请选择开始时间" {
            if let date = formatter.date(from: components) {
                print("解析成功：\(date)")
                datePickView.selectDate = date
            } else {
                datePickView.selectDate = now
                print("解析失败，格式不匹配")
            }
        }else {
            datePickView.selectDate = now
        }
        datePickView.minDate = calendar.date(byAdding: .year, value: -1, to: now)
        datePickView.maxDate = calendar.date(byAdding: .year, value: 10, to: now)
        //回调
        datePickView.resultBlock = { [weak self] selectDate , selectValue in
            if let selectDate = selectDate{
                let timeStr = self?.formatter.string(from: selectDate)
                self?.endTimeLabel.text = timeStr
                self?.endTimeLabel.textColor = UIColor(hex: "#333333")
            }
            UIView.animate(withDuration: 0.3) {
                self?.endTimeIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
            self?.finishScroll(original: originalContentOffset)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.endTimeIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        datePickView.cancelBlock = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.endTimeIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
            self?.finishScroll(original: originalContentOffset)
        }
        datePickView.show()
    }
    
    // MARK: - 时间选择器样式

    func pickerStyle() -> BRPickerStyle{
        let pickerStyle = BRPickerStyle()
        pickerStyle.titleBarHeight = 44
        pickerStyle.titleTextColor = .darkGray
        pickerStyle.titleTextFont = .regular(18)
        pickerStyle.cancelTextColor = UIColor(hex: "#999999")
        pickerStyle.doneTextColor = UIColor(hex: "#FF8F21")
        pickerStyle.selectRowColor = UIColor(hex: "#FFFDFC")
        pickerStyle.selectRowTextColor = UIColor(hex: "#FF8F21")
        pickerStyle.pickerColor = .white
        pickerStyle.topCornerRadius = 16
        pickerStyle.pickerHeight = 228
        pickerStyle.rowHeight = 40
        return pickerStyle
    }
    
    // MARK: - 滑动到可视范围
    func scrollToVisible(view: UIView, height: CGFloat) {
        let view = UIView()
        view.height(height)
        self.scrollView.easy.appendView(view).insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            .identifier("Placeholder")
        self.scrollView.layoutIfNeeded()
        let viewFrameInWindow = view.convert(view.bounds, to: self.view)
        let viewHeight = self.view.bounds.height

        // 是否在底部 350px 范围内（即：会被遮挡）
        let dangerZoneY = viewHeight - 350
        if viewFrameInWindow.maxY > dangerZoneY {
            
            let frameInScroll = view.convert(view.bounds, to: scrollView)
            scrollView.scrollRectToVisible(frameInScroll.insetBy(dx: 0, dy: -height), animated: true)
        }
    }
    
    func finishScroll(original: CGPoint) {
        self.scrollView.easy.deleteView("Placeholder") { [weak self] in
            self?.scrollView.setContentOffset(original, animated: true)
        }
    }
    
    // MARK: - 展示收费详细内容
 
    func showDetail(amount: String, reason: String) {
        self.isExpend = true
        let contentView = UIView()
        contentView.backgroundColor = UIColor(hex: "#FAFAF8")
        contentView.layer.cornerRadius = 8
        let amountLabel = UILabel()
        amountLabel.text = "收费金额：\(amount)元"
        amountLabel.textColor = UIColor(hex: "#999999")
        amountLabel.font = .regular(14)
        
        let reasonLabel = UILabel()
        reasonLabel.text = "收费方式及收费原因说明：\n\(reason)"
        reasonLabel.textColor = UIColor(hex: "#999999")
        reasonLabel.font = .regular(14)
        reasonLabel.numberOfLines = 0
        contentView.subviews(amountLabel,reasonLabel)
        contentView.layout(
            8,
            |-8-amountLabel-8-|,
            2,
            |-8-reasonLabel-8-|,
            8
        )
        chargeStackView.addArrangedSubview(contentView)
    }
    // MARK: - 显示联系方式填写

    @objc func showContactInfo() {
        let originalContentOffset = scrollView.contentOffset
        self.scrollToVisible(view: chargeView, height: 198)
        let vc = EHContactSheetController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        //成功设置
        vc.onConfirm = { [weak self] name, contact in
            guard let self = self else { return }
            self.name = name
            self.contact = contact
            self.contactLabel.text = "\(name) \(contact)"
            self.contactLabel.textColor = UIColor(hex: "#333333")
        }
        //归位
        vc.completion = { [weak self] in
            self?.finishScroll(original: originalContentOffset)
            UIView.animate(withDuration: 0.3) {
                self?.contactIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contactIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - 显示地址填写
    @objc func showAddressPicker() {
        let originalContentOffset = scrollView.contentOffset
        self.scrollToVisible(view: chargeView, height: 352)
        let vc = EHAddressSheetController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        //成功设置
        vc.onConfirm = { [weak self] selectedProvince,selectedCity,selectedDistrict,detail in
            guard let self = self else { return }
            self.province = selectedProvince
            self.city = selectedCity
            self.district = selectedDistrict
            self.detailAddress = detail
            let location = "\(selectedProvince)\(selectedCity)\(selectedDistrict)\(detail)"
            self.addressLabel.text = "\(location)"
            self.addressLabel.textColor = UIColor(hex: "#333333")
        }
        //归位
        vc.completion = { [weak self] in
            self?.finishScroll(original: originalContentOffset)
            UIView.animate(withDuration: 0.3) {
                self?.contactIcon.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contactIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - 主题选择页面
    @objc func toThemeVC() {
        let vc = EHSelectThemeController()
        vc.completion = { [weak self] theme,tags in
            guard let self = self else { return }
            themeContentView.subviews.forEach { $0.removeFromSuperview() }
            themeContentView.removeConstraints(themeContentView.userAddedConstraints)
            let themeView = EHThemeView(type: theme)
            if tags.count == 0 {
                themeContentView.subviews(themeView)
                themeContentView.layout(
                    2,
                    |-0-themeView,
                    2
                )
            }else {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 8
                stackView.height(16)
                themeContentView.subviews(themeView,stackView)
                for tag in tags {
                    let tagView = EHTagView(type: tag)
                    stackView.addArrangedSubview(tagView)
                }
                themeContentView.layout(
                    2,
                    |-0-themeView,
                    6,
                    |-0-stackView-(>=10)-|,
                    0
                )
            }
            themeContentView.layoutIfNeeded()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        
    }

}


extension EHActivityReleaseController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        titleCount.text = "\(textField.text?.count ?? 0)/30"
    }
}


extension EHActivityReleaseController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 图片选择后回调的方法
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.editedImage] as? UIImage {
                // 更新UIImageView的image
                posterView.image = selectedImage
                placeholderView.isHidden = true
            }
            
            // 关闭图片选择器
            dismiss(animated: true, completion: nil)
        }
        
        // 用户取消选择时的回调方法
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 关闭图片选择器
            dismiss(animated: true, completion: nil)
        }
}





