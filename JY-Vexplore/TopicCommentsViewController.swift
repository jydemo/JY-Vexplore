//
//  TopicCommentsViewController.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TopicCommentsViewController: BasetableViewController, commentImageDelegate, CommentCellDelegate {
    
    var topicID = R.String.Zero
    private var  currentPage = 1
    private var totalPageNum = 1
    private var topicComments = [TopicCommentModel]()
    private var ownerComments = [TopicCommentModel]()
    private var isOwnerView = false
    private var isCommentContext = false
    var ownerName: String? {
        didSet {
            if let ownerName = ownerName, ownerName.isEmpty == false, topicComments.count > 0 {
                if let indexPaths = tableView.indexPathsForVisibleRows {
                    tableView.reloadRows(at: indexPaths, with: .none)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TopiCommentCell.self, forCellReuseIdentifier: String(describing: TopiCommentCell.self))
        enableBottomLoading = false
        tableView.scrollsToTop = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func topLoadingRequest() {
        V2request.Topic.getComments(withTopicID: topicID, page: 1) { [unowned self] (response) in
            self.stopLoading(withLoadingStyle: .top, success: response.success, completion: { (success) in
                if success, let comments = response.value {
                    self.topicComments = comments.0
                    self.totalPageNum = comments.1
                    self.currentPage = 2
                    if self.currentPage > self.totalPageNum {
                        self.enableBottomLoading = false
                    } else {
                        self.tableView.tableFooterView = self.tableFooterView
                        self.enableBottomLoading = true
                        self.bottomLoadingView.iniSquaresNormalPosition()
                    }
                    if self.topicComments.count == 0 {
                        self.topMessageLabel.text = R.String.NoRepliesNow
                        self.topMessageLabel.isHidden = false
                        self.topLoadingView.isHidden = true
                    } else  {
                        self.tableView.reloadData()
                        UIView.animate(withDuration: R.Constant.InsetAnimationDuration, delay: 0, options: .beginFromCurrentState, animations: {
                            self.tableView.contentInset = .zero
                        }, completion: { (_) in
                            if User.shared.isLogin {
                                self.topReminderLabel.text = R.String.SwipeToDoMore
                                self.topReminderLabel.isHidden = false
                            }
                            self.tableView.tableHeaderView = nil
                        })
                    }
                    self.isTopLoadingFail = false
                    self.enableTopLoading = false
                } else {
                    if response.message.count > 0,  response.message[0] == R.String.NeedLoginError {
                        self.topMessageLabel.text = R.String.NeedLoginToViewThisTopic
                        self.topMessageLabel.isHidden = false
                        self.topLoadingView.isHidden = true
                        User.shared.logout()
                    }
                    self.isTopLoadingFail = true
                }
                self.isTopLoading = false
            })
        }
    }
    override func bottomLoadingrequest() {
        V2request.Topic.getComments(withTopicID: topicID, page: currentPage) { [unowned self] (response) in
            self.stopLoading(withLoadingStyle: .bottom, success: response.success, completion: { (success) in
                if success, let value = response.value {
                    self.bottomLoadingView.isHidden = true
                    let oldRowsCount = self.topicComments.count
                    self.topicComments.append(contentsOf: value.0)
                    let newRowsCount = self.topicComments.count
                    var insertIndexPaths = [IndexPath]()
                    for index in oldRowsCount..<newRowsCount {
                        let indexPath = IndexPath(row: index, section: 0)
                        insertIndexPaths.append(indexPath)
                    }
                    self.currentPage += 1
                    self.tableView.insertRows(at: insertIndexPaths, with: .none)
                    if self.currentPage > self.totalPageNum {
                        self.tableView.tableFooterView = nil
                        self.enableBottomLoading = false
                    }
                } else {
                    self.isBottomLoadingFail = true
                }
                self.isBottomLoading = false
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOwnerView ? ownerComments.count : topicComments.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopiCommentCell.self), for: indexPath) as! TopiCommentCell
        let comment = isOwnerView ? ownerComments[indexPath.row] : topicComments[indexPath.row]
        cell.commentModel = comment
        if let avatar = comment.avatar, let url = URL(string: R.String.Https + avatar) {
            cell.avatarImageView.avatarImage(withURL: url)
        }
        cell.userNameLabel.text = comment.username
        cell.dateLabel.text = comment.date
        cell.likeNumLabel.text = String(comment.likeNum)
        if User.shared.isLogin, comment.isThanked {
            cell.likeImageView.tintColor = UIColor.highlight
        }
        if let commentIndex = comment.commentIndex, commentIndex.isEmpty == false {
            cell.commentIndexLabel.text = String(format: R.String.CommentIndex, commentIndex)
        }
        if comment.username == ownerName {
            cell.ownerLabel.isHidden = false
        }
        let size = CGSize(width: view.frame.width - 64, height: CGFloat.greatestFiniteMagnitude)
        if let layout = RichTextLayout(with: size, text: comment.contentAttributedString) {
            cell.commentLabel.textLayout = layout
            for attachment in layout.attachments {
                if let image = attachment as? CommentImageView {
                    image.delegate = self
                }
            }
        }
        cell.commentLabel.highlightTapAction = { [unowned self] (url) -> Void in
            URLAnalyzer.Analyze(url: url, handleViewController: self)
        }
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = isOwnerView ? ownerComments[indexPath.row] : topicComments[indexPath.row]
        let size = CGSize(width: view.frame.width - 64, height: CGFloat.greatestFiniteMagnitude)
        let layout = RichTextLayout(with: size, text: comment.contentAttributedString)
        let contentheight = ceil(layout!.bounds.height)
        let height = 10 + ceil(R.Font.Small.lineHeight) + 4 + contentheight + 8 + ceil(R.Font.ExtraSmall.lineHeight) + 4
        return height
    }
    
    func tableView(_ tableView: UITableView, willdisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if UserDefaults.isHightlightOwnerrepliesEnabled {
            let comment = isOwnerView ? ownerComments[indexPath.row] : topicComments[indexPath.row]
            if comment.username == ownerName {
                cell.contentView.backgroundColor = UIColor.highlight.withAlphaComponent(0.07)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells as! [TopiCommentCell] {
            cell.reset()
        }
    }
    
    func commentImnageSingleTap(_ imageView: CommentImageView) {
        
    }
    func cellWillBeginSwipe(at indexPath: IndexPath) {
        
    }
    func thankBtnTapped(withReplyID replyID: String, indexPath: IndexPath) {}
    func igonreBtnTapped(withReplyID replyID: String){}
    func replyBtnTapped(withUsername username: String){}
    func longPress(at  indexPath: IndexPath){}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
