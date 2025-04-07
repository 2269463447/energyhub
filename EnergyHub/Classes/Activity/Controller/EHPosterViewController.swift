//
//  EHPosterViewController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/3/27.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import SnapKit
import Stevia

class EHPosterViewController: EHBaseViewController {
    
    private var posterView = UIImageView()
    private let placeholderView = UIView()
    private let tipLabel = UILabel()
    private let closeBtn = UIButton(type: .custom)
    private let commitBtn = UIButton(type: .system)
    var posterBlock: ((UIImage) -> Void)?
    var posterImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "上传图片"
        self.view.backgroundColor = .white
        setUI()
        needNav = false
    }
    

    func setUI() {
        posterView.backgroundColor = UIColor(hex: "#FAFAF8")
        posterView.layer.masksToBounds = true
        posterView.layer.cornerRadius = 10
        posterView.isUserInteractionEnabled = true
        let addPoster = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        posterView.addGestureRecognizer(addPoster)
        self.view.subviews(posterView)
        posterView.image = posterImage
        if (posterImage != nil) {
            self.posterView.snp.makeConstraints { make in
                make.height.equalTo(220)
                make.right.equalTo(self.view).offset(-12)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
                make.left.equalTo(self.view).offset(12)
            }
            placeholderView.isHidden = true
            closeBtn.isHidden = false
        }else {
            posterView.snp.makeConstraints { make in
                make.height.equalTo(110)
                make.width.equalTo(110)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
                make.left.equalTo(self.view).offset(12)
            }
            placeholderView.isHidden = false
            closeBtn.isHidden = true
        }
        
        
        let placeholder = UIImageView(image: UIImage(named: "poster_image"))
        let addIcon = UIImageView(image: UIImage(named: "poster_add"))
        
        let posterTitle = UILabel()
        posterTitle.text = "上传图片"
        posterTitle.textColor = UIColor(hex: "#333333")
        posterTitle.font = UIFont.regular(12)
        
        let contentView = UIView()
        contentView.subviews(addIcon,posterTitle)
        contentView.layout(
            |-0-addIcon-3-posterTitle.top(0).bottom(0)-0-|
        )
        
        
        placeholderView.subviews(placeholder,contentView)
        placeholderView.layout(
            0,
            placeholder.centerHorizontally(),
            8,
            |-0-contentView-0-|,
            0
        )
        closeBtn.setImage(UIImage(named: "close_button"), for: .normal)
        closeBtn.addTarget(self, action: #selector(resetImage), for: .touchUpInside)
        
        posterView.subviews(placeholderView,closeBtn)
        placeholderView.centerInContainer()
        closeBtn.top(0).right(0)
        
        tipLabel.text = "PS：打开手机相册，选取16：9的图片上传，图片大小不少过300K"
        tipLabel.font = .medium(10)
        tipLabel.textColor = UIColor(hex: "#999999")
        
        self.view.subviews(tipLabel)
        tipLabel.Top == posterView.Bottom + 24
        tipLabel.left(12).right(12)
        
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.setTitleColor(.white, for: .normal)
        commitBtn.backgroundColor = UIColor(hex: "#FF8F21")
        commitBtn.layer.masksToBounds = true
        commitBtn.layer.cornerRadius = 20
        commitBtn.height(40)
        commitBtn.addTarget(self, action: #selector(commitPoster), for: .touchUpInside)
        
        self.view.subviews(commitBtn)
        self.view.layout(
            |-12-commitBtn-12-|
        )
        commitBtn.Bottom == self.view.safeAreaLayoutGuide.Bottom - 12
        
    }
    
    @objc func imageViewTapped() {
        // 创建UIImagePickerController并设置它的来源类型为相册
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // 设置来源为相册
        imagePickerController.allowsEditing = true // 是否允许编辑（如裁剪等）
        imagePickerController.modalPresentationStyle = .fullScreen
        // 显示UIImagePickerController
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func resetImage() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            posterView.image = nil
            closeBtn.isHidden = true
            placeholderView.isHidden = false
            posterView.snp.remakeConstraints { make in
                make.height.equalTo(110)
                make.width.equalTo(110)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
                make.left.equalTo(self.view).offset(12)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func commitPoster() {
        guard let image = posterView.image else {
            showHUD(view: self.view, text: "请上传图片")
            return
        }
        self.posterBlock?(image)
        self.navigationController?.popViewController(animated: true)
    }

}


extension EHPosterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 图片选择后回调的方法
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.editedImage] as? UIImage {
                // 更新UIImageView的image
                posterView.image = selectedImage
                placeholderView.isHidden = true
                closeBtn.isHidden = false
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.posterView.snp.remakeConstraints{ make in
                        make.height.equalTo(220)
                        make.right.equalTo(self.view).offset(-12)
                        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
                        make.left.equalTo(self.view).offset(12)
                    }
                    self.view.layoutIfNeeded()
                }
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
