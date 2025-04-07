//
//  EHAddressSheetController.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/1.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

enum ItemType {
    case province
    case city
    case district
}

class EHAddressSheetController: EHBaseSheetController, UITextFieldDelegate {
    
    let provinceIcon = UIImageView(image: UIImage(named: "icon_down")?.withRenderingMode(.alwaysTemplate))
    let cityIcon = UIImageView(image: UIImage(named: "icon_down")?.withRenderingMode(.alwaysTemplate))
    let districtIcon = UIImageView(image: UIImage(named: "icon_down")?.withRenderingMode(.alwaysTemplate))
    
    let provinceLabel = UILabel()
    let cityLabel = UILabel()
    let districtLabel = UILabel()
    ///省列表
    var provinces: [String] = []
    var cities: [String: [String]] = [:]
    var districts: [String: [String]] = [:]
    ///城市列表
    var currentCities: [String] = []
    ///区列表
    var currentDistricts: [String] = []
    ///所选省份
    var selectedProvince: String = ""
    ///所选城市
    var selectedCity: String = ""
    ///所选区
    var selectedDistrict: String = ""
    var provinceItem: UIView!
    var cityItem: UIView!
    var districtItem: UIView!
    
    var tableView = UITableView()
    var selectType: ItemType? = nil
    var onConfirm: ((String,String,String,String) -> Void)?  //回调 地址信息
    
    private let locationField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText = "活动地址"
        height = 430
        tableView.register(EHAreaWithIconCell.self, forCellReuseIdentifier: EHAreaWithIconCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        setUI()
    }
    
    func loadData() {
        guard let fileURL = Bundle.main.url(forResource: "region_tree_data", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let regions = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            print("❌ Failed to load or parse JSON")
            return
        }

        processRegions(regions: regions)
    }
    
    func processRegions(regions: [[String: Any]]) {
        provinces = []
        cities = [:]
        districts = [:]

        for province in regions {
            guard let provinceName = province["text"] as? String else { continue }
            provinces.append(provinceName)

            var cityList: [String] = []
            var districtMap: [String: [String]] = [:]

            if let cityArray = province["children"] as? [[String: Any]] {
                for city in cityArray {
                    guard let cityName = city["text"] as? String else { continue }
                    cityList.append(cityName)

                    var districtList: [String] = []
                    if let districtArray = city["children"] as? [[String: Any]] {
                        for district in districtArray {
                            if let districtName = district["text"] as? String {
                                districtList.append(districtName)
                            }
                        }
                    }

                    districtMap[cityName] = districtList
                }
            }

            cities[provinceName] = cityList
            for (key, value) in districtMap {
                districts[key] = value
            }
        }
    }
    
    func setUI() {
        provinceItem = creatItem(label: provinceLabel, icon: provinceIcon, type: .province)
        cityItem = creatItem(label: cityLabel, icon: cityIcon, type: .city)
        districtItem = creatItem(label: districtLabel, icon: districtIcon, type: .district)
        
        whiteView.subviews(provinceItem,cityItem,districtItem)
        whiteView.layout(
            |-0-provinceItem-0-cityItem-0-districtItem-0-|
        )
        provinceItem.Top == titleLabel.Bottom + 12
        
        let locationTitle = UILabel()
        locationTitle.text = "详细地址："
        locationTitle.font = .systemFont(ofSize: 14)
        locationTitle.textColor = UIColor(hex: "#333333")
        
        locationField.attributedPlaceholder = NSAttributedString(
            string: "请输入详细地址",
            attributes: [
                .font: UIFont.regular(14),
                .foregroundColor: UIColor(hex: "#BCBCBC")
            ]
        )
        locationField.height(44)
        locationField.backgroundColor = UIColor(hex: "#FAFAF8")
        locationField.layer.cornerRadius = 8
        locationField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        locationField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        locationField.leftViewMode = .always
        locationField.rightViewMode = .always
        locationField.font = .systemFont(ofSize: 14)
        locationField.delegate = self
        
        whiteView.subviews(tableView,locationTitle,locationField)
        whiteView.layout(
            |-0-tableView-0-|,
              16,
              |-16-locationTitle-16-|,
              4,
              |-16-locationField-16-|
        )
        tableView.Top == provinceItem.Bottom
        locationField.Bottom == okBtn.Top - 12
    }
    
    func creatItem(label: UILabel, icon: UIImageView, type: ItemType) -> UIView {
        let view = UIView()
        label.font = .regular(16)
        label.textColor = UIColor(hex: "#323233")
        let contentView = UIView()
        icon.tintColor = UIColor(hex: "#323233")
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.subviews(label,icon)
        contentView.layout(
            |-0-label.top(0).bottom(0)-0-icon-0-|
        )
        view.subviews(contentView)
        view.layout(
            |-(>=3)-contentView.centerInContainer()-(>=3)-|
        )
        contentView.centerInContainer()
        let width = ScreenWidth/3
        view.height(48).width(width)
        switch type {
        case .province:
            label.text = "省份"
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapProvince))
            view.addGestureRecognizer(tap)
        case .city:
            label.text = "城市"
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCity))
            view.addGestureRecognizer(tap)
        case .district:
            label.text = "区/县"
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapDistrict))
            view.addGestureRecognizer(tap)
        }
        return view
    }
    
    
    @objc func tapProvince() {
        updateItem(type: .province)
    }
    
    @objc func tapCity() {
        guard selectedProvince != "" else {
            showHUD(view: self.view, text: "请先选择省份")
            return
        }
        updateItem(type: .city)
    }
    
    @objc func tapDistrict() {
        guard selectedProvince != "" else {
            showHUD(view: self.view, text: "请先选择省份")
            return
        }
        guard selectedCity != "" else {
            showHUD(view: self.view, text: "请选择城市")
            return
        }
        updateItem(type: .district)
    }
    
    func updateItem(type: ItemType) {
        if type == selectType {
            selectType = nil
            provinceLabel.textColor = UIColor(hex: "#323233")
            provinceIcon.tintColor = UIColor(hex: "#323233")
            provinceIcon.transform = .identity
            cityLabel.textColor = UIColor(hex: "#323233")
            cityIcon.tintColor = UIColor(hex: "#323233")
            cityIcon.transform = .identity
            districtLabel.textColor = UIColor(hex: "#323233")
            districtIcon.tintColor = UIColor(hex: "#323233")
            districtIcon.transform = .identity
            self.provinceItem.layoutIfNeeded()
            self.cityItem.layoutIfNeeded()
            self.districtItem.layoutIfNeeded()
        }else {
            selectType = type
            provinceLabel.textColor = type == .province ? .mainColor : UIColor(hex: "#323233")
            provinceIcon.tintColor = type == .province ? .mainColor : UIColor(hex: "#323233")
            provinceIcon.transform = (type == .province) ? CGAffineTransform(rotationAngle: .pi) : .identity
            cityLabel.textColor = type == .city ? .mainColor : UIColor(hex: "#323233")
            cityIcon.tintColor = type == .city ? .mainColor : UIColor(hex: "#323233")
            cityIcon.transform = (type == .city) ? CGAffineTransform(rotationAngle: .pi) : .identity
            districtLabel.textColor = type == .district ? .mainColor : UIColor(hex: "#323233")
            districtIcon.tintColor = type == .district ? .mainColor : UIColor(hex: "#323233")
            districtIcon.transform = (type == .district) ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        tableView.reloadData()
    }
    
    override func commit() {
        guard selectedProvince != "" else {
            showHUD(view: self.view, text: "请先选择省份")
            return
        }
        guard selectedCity != "" else {
            showHUD(view: self.view, text: "请选择城市")
            return
        }
        guard selectedDistrict != "" else {
            showHUD(view: self.view, text: "请选择区")
            return
        }
        guard let detail = locationField.text, !detail.isEmpty else {
            showHUD(view: self.view, text: "请输入详细地址")
            return
        }
        onConfirm?(selectedProvince,selectedCity,selectedDistrict,detail)
        super.commit()
    }

}

extension EHAddressSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectType = selectType else { return 0}
        switch selectType {
        case .province:
            return provinces.count
        case .city:
            return currentCities.count
        case .district:
            return currentDistricts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EHAreaWithIconCell = tableView.dequeueReusableCell(withIdentifier: EHAreaWithIconCell.description()) as! EHAreaWithIconCell
        guard let selectType = selectType else { return cell}
        let index = indexPath.row
        switch selectType {
        case .province:
            cell.areaLabel.text = provinces[index]
        case .city:
            cell.areaLabel.text = currentCities[index]
        case .district:
            cell.areaLabel.text = currentDistricts[index]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectType = selectType else { return }
        let index = indexPath.row
        switch selectType {
        case .province:
            selectedProvince = provinces[index]
            currentCities = cities[selectedProvince] ?? [];
            selectedCity = ""
            selectedDistrict = ""
        case .city:
            selectedCity = currentCities[index]
            currentDistricts = districts[selectedCity] ?? []
            selectedDistrict = ""
        case .district:
            selectedDistrict = currentDistricts[index]
        }
        updateUI()
    }
    
    func updateUI() {
        provinceLabel.text = selectedProvince == "" ? "省份" : selectedProvince
        cityLabel.text = selectedCity == "" ? "城市" : selectedCity
        districtLabel.text = selectedDistrict == "" ? "区/县" : selectedDistrict
    }
    
}
