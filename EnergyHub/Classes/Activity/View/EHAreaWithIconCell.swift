//
//  EHAreaWithIconCell.swift
//  EnergyHub
//
//  Created by 赵贤斌 on 2025/4/2.
//  Copyright © 2025 EnergyHub. All rights reserved.
//

import UIKit
import Stevia

class EHAreaWithIconCell: EHAreaCell {
    
    var icon = UIImageView(image: UIImage(named: "area_selected"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    func setUI() {
        self.subviews(icon)
        icon.centerVertically().right(13)
        icon.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        icon.isHidden = !selected
        
    }

}
