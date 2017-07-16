//
//  PersonalInfoCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/9.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class PersonalInfoCell: UITableViewCell {
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Medium
        label.textColor = .middlegray
        return label
    }()
    private lazy var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.borderGray
        return view
    }()
    lazy var  longLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .borderGray
        view.isHidden = true
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(line)
        contentView.addSubview(longLine)
        let bindings = [
            "iconImageView": iconImageView,
            "contentLabel": contentLabel,
            "line": line,
            "longLine": longLine
            
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[iconImageView(20)]-12-[contentLabel]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[longLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[contentLabel]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[longLine(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
