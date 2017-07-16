//
//  BasetableViewController.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SharedKit
import MessageUI

class BasetableViewController: SwipeTransitionViewController, UITableViewDataSource, UITableViewDelegate, SquaresLoadingViewDelegate, TopicCellDelegate, MFMailComposeViewControllerDelegate {
    
    lazy var tableHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0))
        view.autoresizingMask = .flexibleWidth
        return view
    }()
    
    lazy var tableFooterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0))
        view.autoresizingMask = .flexibleWidth
        return view
    }()
    
    lazy var topLoadingView: SquareLoadingView = {
        let view = SquareLoadingView(loadingStyle: .top)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomLoadingView: SquareLoadingView = {
        let view = SquareLoadingView(loadingStyle: .bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var topReminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Small
        label.textColor = .border
        label.isHidden = true
        return label
    }()
    
    lazy var topMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Small
        label.textColor = .desc
        label.isHidden = true
        return label
    }()
    
    lazy var centerMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Font.Small
        label.textColor = .desc
        label.isHidden = true
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        return tableView
    }()
    
    var topicList = [TopicItemModel]()
    var isTopLoading = false
    var enableBottomLoading = false
    var enableTopLoading = false
    var isBottomLoading = false
    var isTopLoadingFail = false
    var isBottomLoadingFail = false
    var request: Request?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(topicList, forKey: "topicList")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        topicList = aDecoder.decodeObject(forKey: "topicList") as! [TopicItemModel]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableHeaderView.addSubview(topLoadingView)
        tableHeaderView.addSubview(topMessageLabel)
        tableHeaderView.addSubview(bottomLoadingView)
        let bindings = ["topLoadingView": topLoadingView,
                        "bottomLoadingView": bottomLoadingView]
        tableHeaderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[topLoadingView]|", metrics: nil, views: bindings))
        topLoadingView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor).isActive = true
        topLoadingView.heightAnchor.constraint(equalToConstant: R.Constant.LoadingViewHeight).isActive = true
        //tableFooterView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomLoadingView]|", metrics: nil, views: bindings))
        //bottomLoadingView.topAnchor.constraint(equalTo: tableFooterView.topAnchor).isActive = true
        //bottomLoadingView.heightAnchor.constraint(equalToConstant: R.Constant.LoadingViewHeight).isActive = true
        
        tableView.addSubview(centerMessageLabel)
        tableView.addSubview(topReminderLabel)
        view.addSubview(tableView)
        topMessageLabel.centerXAnchor.constraint(equalTo: tableHeaderView.centerXAnchor).isActive = true
        topMessageLabel.centerYAnchor.constraint(equalTo: tableHeaderView.centerYAnchor).isActive = true
        centerMessageLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        centerMessageLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        topReminderLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        topReminderLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -32.0).isActive = true
        
        tableView.tableHeaderView = tableHeaderView
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: NSNotification.Name.Setting.NightModeDidChange, object: nil)
        topLoadingRequest()
    }
    @objc private func refreshColorScheme() {
        navigationController?.navigationBar.setupNavigationbar()
        topReminderLabel.textColor = .border
        topMessageLabel.textColor = .desc
        centerMessageLabel.textColor = .desc
        tableView.backgroundColor = .background
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopLoading(withLoadingStyle style: LoadingStyle, success: Bool, completion: CompletionTask?) {
        switch style {
        case .top:
            topLoadingView.stopLoading(withSuccess: success, completion: completion)
        case .bottom:
             bottomLoadingView.stopLoading(withSuccess: success, completion: completion)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCell.self), for: indexPath) as! TopicCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !isTopLoading && !isTopLoadingFail && scrollView.contentOffset.y < 0 && enableTopLoading {
            let offset = -scrollView.contentOffset.y
            topLoadingView.showLoadingView(withOffset: offset)
        }
        if enableBottomLoading && scrollView.contentSize.height < scrollView.frame.height && !isBottomLoading && !isBottomLoadingFail {
            beginBottomLoading()
        }
        
        if enableBottomLoading && scrollView.contentSize.height > scrollView.frame.height && !isBottomLoading && !isBottomLoadingFail {
            tableFooterView.frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: R.Constant.LoadingViewHeight)
            tableView.tableFooterView = tableFooterView
            if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - (tableView.tableFooterView?.bounds.height ?? 0) {
                beginBottomLoading()
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard enableTopLoading == true else {
            return
        }
        
        let offset = -scrollView.contentOffset.y
        if offset > R.Constant.LoadingViewHeight && !isTopLoading {
            if  isTopLoadingFail {
                
            } else {
                beginBottomLoading()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard enableTopLoading == true && (scrollView.contentOffset.y < 0 || scrollView.contentSize.height == 0) else {
            return
        }
        
        var contentInsetTop = tableView.contentInset
        contentInsetTop.top = R.Constant.LoadingViewHeight
        tableView.contentInset = contentInsetTop
        isTopLoading = true
        topLoadingView.beginLoading()
        topLoadingRequest()
    }
    
    func initTopLoading(shouldResetContent reset: Bool = false) {
        if reset {
            resetContent()
        }
        topLoadingView.initSquarePosition()
        let offsetY = tableView.contentOffset.y - R.Constant.LoadingViewHeight
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: offsetY), animated: true)
    }
    
    private func resetContent() {
        topicList.removeAll()
        tableView.reloadData()
        isTopLoading = false
        tableView.setContentOffset(.zero, animated: false)
    }
    
    func didTriggeredReloading() {
        beginBottomLoading()
    }
    
    func avatarTapped(withUsername username: String) {
        
    }
    
    func nodeTapped(withNodeID nodeID: String, nodeName: String?) {
        
    }
    
    private func beginBottomLoading() {
        bottomLoadingView.isHidden = false
        bottomLoadingView.initSquarePosition()
        bottomLoadingView.beginLoading()
        isBottomLoading = true
        bottomLoadingrequest()
    }
    
    func removeTopic(withID topicID: String) {
        if let index = topicList.index(where: { $0.topicID == topicID }) {
            topicList.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func prepareForReuse() {
        topReminderLabel.font = R.Font.Small
        topMessageLabel.font = R.Font.Small
        centerMessageLabel.font = R.Font.Small
    }
    
    func topLoadingRequest() {
    }
    
    func bottomLoadingrequest() {
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

