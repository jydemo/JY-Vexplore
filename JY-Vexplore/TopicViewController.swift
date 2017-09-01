//
//  TopicViewController.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TopicViewController: SwipeTransitionViewController {
    
    //private lazy var segmentedControl:
    fileprivate lazy var segmentedControl: SegmentControl = {
        let control = SegmentControl(titles: [R.String.Content, R.String.Comment], selectedIndex: 0)
        control.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    fileprivate lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = false
        view.scrollsToTop = false
        return view
    }()
    
    func segmentControlValueChanged(_ sender: SegmentControl) {
        currentIndex = sender.selectedIndex
        
    }
    var ignoreHandler: IgnoreHandler?
    var unfavoriteHandler: UnfavoriteHandler?
    var topicID = R.String.Zero
    fileprivate let topicdetailVC = TopicDetailViewController()
    fileprivate let topicCommentVC = UIViewController() //TopicCommentViewController()
    //private let inputVC = TopicReplyingViewController()
    //private let activityViewController: UIActivityViewController?
    fileprivate let unfavorite = false
    fileprivate var enableReplying = false
    fileprivate weak var presentingVC: UIViewController?
    fileprivate var currentIndex: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presentStyle = .horizental
        dismissStyle = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(contentScrollView)
        let bindings = ["contentScrollView": contentScrollView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentScrollView]|", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentScrollView]|", metrics: nil, views: bindings))
        let closeBtn = UIBarButtonItem(image: R.Image.Close, style: .plain, target: self, action: #selector(closeBtnTapped))
        navigationItem.leftBarButtonItem = closeBtn
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 120, height: 26)
        navigationItem.titleView = segmentedControl
        contentScrollView.backgroundColor = .background
        view.backgroundColor = .subBackground
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingVC = navigationController?.presentingViewController?.childViewControllers.first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func setup() {
        view.layoutIfNeeded()
        //topicdetailVC.delegate = self
        //topicdetailVC.inputView
        topicdetailVC.topicID = topicID
        
        addChildViewController(topicdetailVC)
        topicdetailVC.didMove(toParentViewController: self)
        topicdetailVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(topicdetailVC.view)
        
        addChildViewController(topicCommentVC)
        topicCommentVC.didMove(toParentViewController: self)
        topicCommentVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(topicCommentVC.view)
        
        let bindings: [String: Any] = ["detailView": topicdetailVC.view, "commentView": topicCommentVC.view]
        contentScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailView][commentView]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: bindings))
        topicdetailVC.view.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor).isActive = true
        topicCommentVC.view.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor).isActive = true
        topicdetailVC.view.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor).isActive = true
        topicdetailVC.view.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
    }
    
    @objc fileprivate func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
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
