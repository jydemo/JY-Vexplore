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
    private lazy var segmentedControl: SegmentControl = {
        let control = SegmentControl(titles: [R.String.Comment], selectedIndex: 0)
        control.addTarget(self, action: #selector(segmentControlValueChanged(sender:)), for: .valueChanged)
        return control
    }()
    private lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = false
        view.scrollsToTop = false
        return view
    }()
    
    func segmentControlValueChanged(sender: SegmentControl) {
        currentIndex = sender.selectedIndex
        
    }
    var ignoreHandler: IgnoreHandler?
    private var currentIndex: Int = 0
    var topicID = R.String.Zero
    private weak var presentingVC: UIViewController?
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingVC = navigationController?.presentingViewController?.childViewControllers.first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func closeBtnTapped() {
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
