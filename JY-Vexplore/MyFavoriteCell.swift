//
//  MyFavoriteCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 19/06/2017.
//  Copyright © 2017 atom. All rights reserved.
//

import UIKit

protocol MyFavoriteCellDelegate: class {
    func favoriteTopicsTapped()
    func favoriteNodesTapped()
    func myFollowingtapped()
}

class MyFavoriteCell: UITableViewCell {
    weak var delegate: MyFavoriteCellDelegate?
    lazy var nodesView: ProfileActionView = {
        let view = ProfileActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textLabel.text = R.String.FavoriteNodes
        view.numLabel.text = R.String.Zero
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nodesViewTapped)))
        return view
    }()
    
    lazy var topicsView: ProfileActionView = {
        let view = ProfileActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textLabel.text = R.String.FavoriteTopics
        view.numLabel.text = R.String.Zero
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topicsviewTapped)))
        return view
    }()
    
    lazy var followingView: ProfileActionView = {
        let view = ProfileActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.verticalLine.isHidden = true
        view.textLabel.text = R.String.Followings
        view.numLabel.text = R.String.Zero
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingsviewtapped)))
        return view
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nodesView)
        contentView.addSubview(topicsView)
        contentView.addSubview(followingView)
        contentView.addSubview(bottomLine)
        
        let bingings = [
        "nodesView": nodesView,
        "topicsView": topicsView,
        "followingView": followingView,
            "bottomLine": bottomLine
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nodesView][topicsView][followingView]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: bingings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bingings))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[nodesView]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bingings))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomLine(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bingings))
        nodesView.widthAnchor.constraint(equalTo: followingView.widthAnchor).isActive = true
        topicsView.widthAnchor.constraint(equalTo: followingView.widthAnchor).isActive = true
        contentView.backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nodesView.prepareForReuse()
        topicsView.prepareForReuse()
        followingView.prepareForReuse()
        delegate = nil
    }
    
    @objc private func nodesViewTapped() {
        delegate?.favoriteNodesTapped()
    }
    
    @objc private func topicsviewTapped() {
        delegate?.favoriteTopicsTapped()
    }
    
    @objc private func followingsviewtapped(){
        delegate?.myFollowingtapped()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
