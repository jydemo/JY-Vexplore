//
//  TopicCell.swift
//  JY-VeX
//
//  Created by atom on 2017/5/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {
    
    lazy var  avatarImageView: UIImageView = {
        let view = UIImageView()
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
        btn.titleLabel?.font = R.Font.ExtraSmall
        btn.contentEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
        btn.addTarget(self, action: #selector(nodetapped), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var commentImageView: UIImageView = {
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
    
    lazy var lastReplayDateAndUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.ExtraSmall
        label.textColor = .note
        return label
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        return view
    }()
    var topicItemModel: TopicItemModel?
    var avatarSize: NSLayoutConstraint!
    weak var delegate: TopicCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(nodeNameBtn)
        contentView.addSubview(commentImageView)
        contentView.addSubview(repliesNumberLabel)
        contentView.addSubview(topicTitleLabel)
        contentView.addSubview(lastReplayDateAndUserLabel)
        contentView.addSubview(bottomLine)
        
        let bindings = [
            "avatarImageView": avatarImageView,
            "userNameLabel": userNameLabel,
            "nodeNameBtn": nodeNameBtn,
            "commentImageView": commentImageView,
            "repliesNumberLabel": repliesNumberLabel,
            "topicTitleLabel": topicTitleLabel,
            "lastReplayDateAndUserLabel": lastReplayDateAndUserLabel,
            "bottomLine": bottomLine
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[avatarImageView]-8-[userNameLabel]-8-[nodeNameBtn]", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[commentImageView]-1-[repliesNumberLabel]-8-|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[userNameLabel]-6-[topicTitleLabel]-6-[lastReplayDateAndUserLabel]-3.5-[bottomLine(0.5)]|", options: [.alignAllLeading], metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[avatarImageView]", metrics: nil, views: bindings))
        topicTitleLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        commentImageView.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        repliesNumberLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        nodeNameBtn.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        repliesNumberLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: repliesNumberLabel.trailingAnchor).isActive = true
        topicTitleLabel.trailingAnchor.constraint(equalTo: repliesNumberLabel.trailingAnchor).isActive = true
        lastReplayDateAndUserLabel.trailingAnchor.constraint(equalTo: repliesNumberLabel.trailingAnchor).isActive = true
        avatarSize = NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: R.Constant.AvatarSize)
        avatarSize.isActive = true
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        selectionStyle = .none
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: NSNotification.Name.Setting.NightModeDidChange, object: nil)
    }
    
    override func prepareForReuse() {
        //avatarImageView
        super.prepareForReuse()
        avatarImageView.image = nil
        repliesNumberLabel.text = R.String.Zero
        userNameLabel.font = R.Font.Small
        topicTitleLabel.font = R.Font.DynamicMedium
        nodeNameBtn.titleLabel?.font = R.Font.ExtraSmall
        repliesNumberLabel.font = R.Font.ExtraSmall
        lastReplayDateAndUserLabel.font = R.Font.ExtraSmall
    }
    
    @objc private func refreshColorScheme() {
        avatarImageView.tintColor = .body
        userNameLabel.textColor = .desc
        topicTitleLabel.textColor = .body
        nodeNameBtn.layer.borderColor = UIColor.desc.cgColor
        nodeNameBtn.setTitleColor(.desc, for: .normal)
        commentImageView.tintColor = .desc
        repliesNumberLabel.textColor = .desc
        lastReplayDateAndUserLabel.textColor = .note
        bottomLine.backgroundColor = .border
        contentView.backgroundColor = .background
    }
    
    @objc private func avatarTapped() {
        if let username = topicItemModel?.username {
            delegate?.avatarTapped(withUsername: username)
        }
    }
    
    func nodetapped() {
        if let nodeID = topicItemModel?.nodeID {
            delegate?.nodeTapped(withNodeID: nodeID, nodeName: topicItemModel?.nodeName)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        topicTitleLabel.preferredMaxLayoutWidth = topicTitleLabel.bounds.width
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
