//
//  TopicDetailViewController.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import WebKit

protocol TopicDetailViewControllerDelegate: class {
    func  showMorIcon()
    func isUnfavoriteTopic(_ unfavorite: Bool)
}

class TopicDetailViewController: BasetableViewController, TopicDetailDelegate, WKNavigationDelegate{
    var topicID = R.String.Zero
    var topicDetailModel: TopicDetailModel!
    var token: String?
    fileprivate var  contentView = TopicDetailContentView()
    fileprivate var lastContentCellheight: CGFloat?
    weak var delegate: TopicDetailViewControllerDelegate?
    var webViewReloadCount: UInt8 = 0
    
    override func viewDidLoad() {
        contentView.contentWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewDidLoad()
        tableView.register(TopicDetailHeaderCell.self, forCellReuseIdentifier: String(describing: TopicDetailHeaderCell.self))
        contentView.contentWebView.navigationDelegate = self
        initTopLoading()
        NotificationCenter.default.addObserver(self, selector: #selector(handlerContentSizeCategoryDidChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        contentView.contentWebView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc private func handlerContentSizeCategoryDidChanged() {
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.load(with: topicDetailModel)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change, let newContentSize = change[.newKey] as? NSValue {
            contentView.contentHeight = newContentSize.cgSizeValue.height
            if let lastContentCellHeightUnwrap = lastContentCellheight, lastContentCellHeightUnwrap == contentView.contentHeight {
                return
            }
            
            lastContentCellheight = contentView.contentHeight
            contentView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: contentView.contentHeight))
            tableView.tableFooterView = contentView
        }
    }
    
    override func topLoadingRequest() {
        V2request.Topic.getDetail(withTopicID: topicID) { [unowned self] response in
            self.stopLoading(withLoadingStyle: .top, success: response.success, completion: { (success) in
                if success, let topicDetailModel = response.value {
                    self.topicDetailModel = topicDetailModel
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - TopicDetailDelegate 
    func favorieBtnTapped() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshTopicToken { [unowned self] token in
            if let topicID = self.topicDetailModel.topicId {
                V2request.Topic.favoriteTopic(!self.topicDetailModel.isFavorite, topicID: topicID, token: token, completionHandler: { (response) in
                    if response.success {
                        self.refreshPage(completion: { (success) in
                            if success == true {
                                self.delegate?.isUnfavoriteTopic(!self.topicDetailModel.isFavorite)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        })
                    } else {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                })
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private func refreshTopicToken(completion: @escaping (String) -> Void) {
        V2request.Topic.getDetail(withTopicID: topicID) { (response) in
            if response.success, let topicDetailModel = response.value,
            let topicDetailModelUnwrap = topicDetailModel,
            let token = topicDetailModelUnwrap.token {
                completion(token)
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private func refreshPage(completion: @escaping (Bool) -> Void) {
        V2request.Topic.getDetail(withTopicID: topicID) { [unowned self] response in
            if response.success, let topicDetailModel = response.value {
                self.topicDetailModel = topicDetailModel
            }
            completion(response.success)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicDetailModel != nil ? 1 : 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicDetailHeaderCell.self), for: indexPath) as! TopicDetailHeaderCell
        guard let topicDetailModel = topicDetailModel  else {
            return cell
        }
        
        cell.topicDetailModel = topicDetailModel
        if let avatar = topicDetailModel.avatar, let url = URL(string: R.String.Https + avatar) {
            cell.avatarImageView.avatarImage(withURL: url)
        }
        cell.topicTitleLabel.text = topicDetailModel.topicTitle
        cell.userNameLabel.text = topicDetailModel.username
        cell.nodeNameBtn.setTitle(topicDetailModel.nodeName, for: .normal)
        cell.dateLabel.text = topicDetailModel.date
        cell.favoriteNumberLabel.text = topicDetailModel.favoriteNum ?? R.String.NoFavorite
        if topicDetailModel.topicCommentTotalCount != nil {
            cell.repliesNumberLabel.text = topicDetailModel.topicCommentTotalCount
        }
        if let token = topicDetailModel.token, token.isEmpty == false {
            cell.favoriteContainerview.isHidden = false
        }
        cell.likeImageView.tintColor = topicDetailModel.isFavorite ? .highlight : .desc
        cell.delegate = self
        return cell
    }
    
    private lazy var heightCell: TopicDetailHeaderCell = {
        let cell = TopicDetailHeaderCell()
        cell.bounds = self.tableView.bounds
        cell.autoresizingMask = [.flexibleWidth]
        return cell
    }()
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightCell.prepareForReuse()
        heightCell.topicTitleLabel.text = topicDetailModel.topicTitle
        heightCell.userNameLabel.text = R.String.Placeholder
        heightCell.dateLabel.text = R.String.Placeholder
        heightCell.setNeedsLayout()
        heightCell.layoutIfNeeded()
        let height = ceil(heightCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
        return height
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
