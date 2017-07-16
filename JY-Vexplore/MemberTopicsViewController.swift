//
//  MemberTopicsViewController.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/10.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class MemberTopicsViewController: BasetableViewController {
    lazy var pageNumview: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: R.Constant.defaulViewtSize, height: R.Constant.defaulViewtSize))
        label.textAlignment = .right
        label.font = R.Font.Small
        label.textColor = UIColor.middlegray
        return label
    }()
    
    private var membertopicList = [MemberTopicItemModel]()
    private var currentPage = 1
    private var totalPageNum = 1
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(format: R.String.MemberAllTopics, username)
        //tableView.register(, forCellReuseIdentifier: <#T##String#>)
        let closeBtn = UIBarButtonItem(image: R.Image.Close, style: .plain, target: self, action: #selector(closeBtnTapped))
        closeBtn.tintColor = UIColor.middlegray
        navigationItem.leftBarButtonItem = closeBtn
        let pageNumItem = UIBarButtonItem(customView: pageNumview)
        navigationItem.rightBarButtonItem = pageNumItem
       // enableBottomLoading = false
        
    }
    @objc private func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func topLoadingRequest() {
        V2request.Profile.getMemberTopics(withUsername: username, page: 1) { [unowned self] (response) in
            self.stopLoading(withLoadingStyle: .top, success: response.success, completion: { (success) in
                if success, let value = response.value {
                    self.membertopicList = value.0
                    self.currentPage = 1
                    self.pageNumview.text = value.2
                    self.totalPageNum = value.1
                    if self.currentPage > self.totalPageNum {
                        self.enableBottomLoading = false
                    } else {
                        self.tableView.tableFooterView = self.tableFooterView
                        self.enableBottomLoading = true
                    }
                    self.tableView.reloadData()
                    UIView.animate(withDuration: R.Constant.InsetAnimationDuration, delay: 0, options: .beginFromCurrentState, animations: {
                        self.tableView.contentInset = .zero
                    }, completion: { (_) in
                        self.tableView.tableHeaderView = nil
                    })
                    self.isTopLoadingFail = false
                    self.enableTopLoading = false
                    self.programaticScrollEnable = true
                } else {
                    self.programaticScrollEnable = false
                    self.isTopLoadingFail = true
                }
                self.isTopLoading = false
            })
        }
    }
}
