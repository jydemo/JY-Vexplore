//
//  ProfileAvatarCell.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

protocol ProfileAvatarCellDelegate: class {
    func writeBtnTapped()
}

class ProfileAvatarCell: UITableViewCell {
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = R.Font.Medium
        label.textColor = .body
        return label
    }()
    
    /*fileprivate lazy var avatarImageView: UIImageView = {
        if let username = topicItemModel.username {
            delegate.avatartapped(withUsername: username)
        }
    }()*/

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
