//
//  MemberFollowBlockCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/9.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
protocol MemberFollowBlockCellDelegate: class {
    func followViewTapped()
    func blockViewTapped()
}

class MemberFollowBlockCell: UITableViewCell {
    lazy var followView: ProfileActionView = {
        let view = ProfileActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(followViewTap)))
        return view
    }()
    lazy var blockView: ProfileActionView = {
        var view = ProfileActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.verticalLine.isHidden = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(blockViewTapped)))
        return view
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .borderGray
        return view
    }()
    weak var delegate: MemberFollowBlockCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(followView)
        contentView.addSubview(blockView)
        contentView.addSubview(bottomLine)
        let bindings = [
            "followView": followView,
            "blockView": blockView,
            "bottomLine": bottomLine
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[followView][blockView]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[blockView]-8-[bottomLine(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        followView.widthAnchor.constraint(equalTo: blockView.widthAnchor).isActive = true
        contentView.backgroundColor = .white
        selectionStyle = .none
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
    
    @objc private func followViewTap() {
        delegate?.followViewTapped()
    }
    @objc private func blockViewTapped() {
        delegate?.blockViewTapped()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        followView.prepareForReuse()
        blockView.prepareForReuse()
    }

}
