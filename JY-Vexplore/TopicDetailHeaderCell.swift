//
//  TopicDetailHeaderCell.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/26.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TopicDetailHeaderCell: UITableViewCell {
    
    lazy var avatarImageView: AvatarImageView = {
        let view = AvatarImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.tintColor = .body
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(avatarTapped)))
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Small
        label.textColor = .desc
        return label
        
    }()
    lazy var topicTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Medium
        label.numberOfLines = 0
        label.textColor = .body
        return label
    }()
    lazy var nodeNameBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.desc.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.setTitleColor(.desc, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
        btn.addTarget(self, action: #selector(nodeTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var commentImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Comment
        view.tintColor = .desc
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var repliesNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = .desc
        label.text = R.String.Zero
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = .border
        label.textAlignment = .left
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return label
    }()
    
    lazy var favoriteContainerview: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favoriteBtnTapped))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.isHidden = true
        return view
    }()
    lazy var likeImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Like
        view.tintColor = .desc
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var favoriteNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = .desc
        label.textAlignment = .right
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        label.text = R.String.NoFavorite
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        return view
    }()
    
    
    var topicDetailModel: TopicDetailModel?
    weak var delegate: TopicDetailDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let bindings: [String: Any] = [
            "avatarImageView": avatarImageView,
            "userNameLabel": userNameLabel,
            "nodeNameBtn": nodeNameBtn,
            "commentImageView": commentImageView,
            "repliesNumberLabel": repliesNumberLabel,
            "topicTitleLabel": topicTitleLabel,
            "dateLabel": dateLabel,
            "favoriteContainerView": favoriteContainerview,
            "likeImageView": likeImageView,
            "favoriteNumLabel": favoriteNumberLabel,
            "separatorLine": separatorLine
        ]
        favoriteContainerview.addSubview(likeImageView)
        favoriteContainerview.addSubview(favoriteNumberLabel)
        favoriteContainerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[likeImageView]-1-[favoriteNumLabel]-|", metrics: nil, views: bindings))
        favoriteContainerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[likeImageView]-1-|", metrics: nil, views: bindings))
        favoriteNumberLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor).isActive = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(nodeNameBtn)
        contentView.addSubview(commentImageView)
        contentView.addSubview(repliesNumberLabel)
        contentView.addSubview(topicTitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(favoriteNumberLabel)
        contentView.addSubview(separatorLine)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[avatarImageView]-8-[userNameLabel]-8-[nodeNameBtn]", metrics: nil, views: bindings
        ))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[commentImageView]-1-[repliesNumberLabel]-8-|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[userNameLabel]-6-[topicTitleLabel]-6-[dateLabel]-4-|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dateLabel]-(>=0)-[favoriteContainerView]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[avatarImageView]", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorLine]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separatorLine(1)]|", metrics: nil, views: bindings))
        avatarImageView.widthAnchor.constraint(equalToConstant: R.Constant.AvatarSize).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: R.Constant.AvatarSize).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        commentImageView.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        repliesNumberLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        nodeNameBtn.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        topicTitleLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        topicTitleLabel.trailingAnchor.constraint(equalTo: repliesNumberLabel.leadingAnchor).isActive = true
        likeImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        contentView.backgroundColor = .background
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        avatarImageView.cancelImageDownloadTaskIfNeed()
        super.prepareForReuse()
        avatarImageView.image = nil
        repliesNumberLabel.text = R.String.Zero
        favoriteNumberLabel.text = R.String.NoFavorite
        favoriteContainerview.isHidden = true
        userNameLabel.font = R.Font.Small
        topicTitleLabel.font = R.Font.Medium
        nodeNameBtn.titleLabel?.font = R.Font.ExtraSmall
        repliesNumberLabel.font = R.Font.ExtraSmall
        dateLabel.font = R.Font.ExtraSmall
        favoriteNumberLabel.font = R.Font.ExtraSmall
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        topicTitleLabel.preferredMaxLayoutWidth = topicTitleLabel.bounds.width
    }
    
    @objc fileprivate func avatarTapped() {
        if let username = topicDetailModel?.username {
            delegate?.avatarTapped(withUsername: username)
        }
    }
    @objc fileprivate func nodeTapped() {
        if let nodeID = topicDetailModel?.nodeId {
            delegate?.nodeTapped(withNodeID: nodeID, nodeName: topicDetailModel?.nodeName)
        }
    }
    @objc fileprivate func favoriteBtnTapped() {
        delegate?.favorieBtnTapped()
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
