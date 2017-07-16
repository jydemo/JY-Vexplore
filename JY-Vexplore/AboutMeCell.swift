//
//  AboutMeCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/9.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class AboutMeCell: UITableViewCell {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = R.Font.Medium
        label.textColor = UIColor.middlegray
        return label
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentLabel)
        let bindings = ["contentLabel": contentLabel]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[contentLabel]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[contentLabel]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.backgroundColor = .white
        //是否参考父视图
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.font = R.Font.Medium
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
