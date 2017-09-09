//
//  TopiCommentCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
private enum ActionButtonType: Int {
    case reply = 0
    case thank
    case hide
}

class TopiCommentCell: SwipeCell {
    
    lazy var avatarImageView: AvatarImageView = {
        let view = AvatarImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.tintColor = UIColor.body
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(avatarTapped)))
        return view
    }()
    lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = UIColor.gray
        label.text = R.String.Owner
        label.isHidden = true
        return label
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Small
        label.textColor = UIColor.desc
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = UIColor.border
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    lazy var likeImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Like
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var likeNumLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = R.Font.ExtraSmall
        view.textColor = UIColor.desc
        return view
    }()
    lazy var commentIndexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = UIColor.desc
        label.text = R.String.Zero
        return label
    }()
    lazy var commentLabel: RichTextLabel = {
        let label = RichTextLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.border
        return view
    }()
    weak var delegate: CommentCellDelegate?
    var commentModel: TopicCommentModel?
    var longPressGestureRecognizer : UILongPressGestureRecognizer!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeImageView)
        contentView.addSubview(likeNumLabel)
        contentView.addSubview(commentIndexLabel)
        contentView.addSubview(commentLabel)
        addSubview(separatorLine)
        let bindings = [
           "avatarImageView" : avatarImageView,
          "ownerLabel" : ownerLabel,
         "userNameLabel" : userNameLabel,
         "dateLabel" : dateLabel,
         "likeImageView" : likeImageView,
         "likeNumView" : likeNumLabel,
            "commentIndexLabel" : commentIndexLabel,
            "commentLAbel" : commentLabel,
            "separatorLine" : separatorLine
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[avatarImageView]-8-[userNameLabel]-8-[likeImageView]-1-[likeNumLabel]", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[commentIndexLabel]-8-|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[avatarImageView]-2-[ownerLabel]", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[userNameLabel]-4-[commentLabel]-8-[dateLabel]-4-|", options: [.alignAllLeading], metrics: nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separatorLine(0.5)]|", metrics: nil, views: bindings))
        avatarImageView.widthAnchor.constraint(equalToConstant: R.Constant.AvatarSize).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: R.Constant.AvatarSize).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        likeImageView.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        likeNumLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        commentIndexLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        ownerLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: commentIndexLabel.trailingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: commentIndexLabel.trailingAnchor).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.delegate = self
        enableSwipe = User.shared.isLogin
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
    override func prepareForReuse() {
        avatarImageView.cancelImageDownloadTaskIfNeed()
        super.prepareForReuse()
        avatarImageView.image = nil
        commentIndexLabel.text = R.String.Zero
        userNameLabel.font = R.Font.Small
        dateLabel.font = R.Font.ExtraSmall
        likeNumLabel.font = R.Font.ExtraSmall
        commentIndexLabel.font = R.Font.ExtraSmall
        likeImageView.tintColor = .desc
        ownerLabel.font = R.Font.ExtraSmall
        ownerLabel.isHidden = true
        contentView.backgroundColor = .background
        
    }
    
    @objc private func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            reset()
            if let tableView = tableView(), let targetIndexPath = tableView.indexPath(for: self) {
                delegate?.longPress(at: targetIndexPath)
            }
        }
    }
    @objc private func avatarTapped() {}
}

extension TopiCommentCell {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tableView = tableView(), let targetIndexPath = tableView.indexPath(for: self) {
            delegate?.cellWillBeginSwipe(at: targetIndexPath)
        }
        if delegate?.cellShouldBeginSwipe() == false {
            return false
        }
        if gestureRecognizer == panGestureRecognizer {
            if userNameLabel.text == User.shared.username {
                return false
            }
            if abs(panGestureRecognizer.velocity(in: self).y) > abs(panGestureRecognizer.velocity(in: self).x) {
                return false
            }
            if panGestureRecognizer.velocity(in: self).x > 0, isDirty == false {
                return false
            }
        }
        return true
    }
    
}






















