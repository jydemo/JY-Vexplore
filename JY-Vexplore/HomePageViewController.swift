//
//  HomePageViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate, HorizontalTabsViewDelegate{
    
    private lazy var tabsScrollview: HorizontalTabsView = {
        let view = HorizontalTabsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tabsDelegate = self
        return view
    }()
    
    lazy var contentSlideView: UIScrollView = {
        let view  = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = true
        return view
    }()
    private lazy var recentBtn: UIBarButtonItem = {
        let recentBtn = UIBarButtonItem(image: R.Image.Time, style: .plain, target: self, action: #selector(recentBtnTapped))
        return recentBtn
    }()
    
    private var tabs = R.Array.AllTabsTitle
    private var currentTab: String!
    private var tabsVC = [String]()
    override func loadView() {
        super.loadView()
        let userDefaults = UserDefaults.standard
        if let showedTabsTitle = userDefaults.array(forKey: R.Key.ShowedTabs) {
            tabs = showedTabsTitle as! [String]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = R.String.Homepage
        
        view.addSubview(tabsScrollview)
        view.addSubview(contentSlideView)
        let bindings: [String: Any] = [
            "top": topLayoutGuide,
            "tabsScrollView": tabsScrollview,
            "contentSlideView": contentSlideView
        ]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabsScrollView]|", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top][tabsScrollView(34)][contentSlideView]|", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: bindings))
        
        if User.shared.isLogin {
            navigationItem.leftBarButtonItem = recentBtn
        }
        let sortBtn = UIBarButtonItem(image: R.Image.Sort, style: .plain, target: self, action: #selector(sortBtnTapped))
        navigationItem.rightBarButtonItem = sortBtn
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func recentBtnTapped() {
    
    }
    @objc private func sortBtnTapped() {}
    
    @objc private func refreshColorScheme() {
       navigationController?.navigationBar.setupNavigationbar()
        contentSlideView.backgroundColor = .background
    }
    @objc private func didLogin() {
        navigationItem.leftBarButtonItem = recentBtn
    }
    @objc private func didLogout(){
        navigationItem.leftBarButtonItem = nil
    }
    private func setup() {
        view.layoutIfNeeded()
        setupTabs()
        var index = 0
        if let currentTab = UserDefaults.standard[R.Key.CurrentTab], let savedIndex = tabs.index(of: currentTab) {
            index = savedIndex
        }
    
    }
    private func setupTabs() {
       
    }
    private func setupcontentSliderViewAndShowPage(atIndex index: Int) {
        contentSlideView.contentSize = CGSize(width: CGFloat(tabs.count) * view.frame.width, height: 0)
        showPage(atIndex: index, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showPage(atIndex index: Int, animated: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        tabsScrollview.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
        let offsetX = contentSlideView.bounds.width * CGFloat(index)
        contentSlideView.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: animated)
        currentTab = tabs[index]
        saveCurrentTab(withTitle: currentTab)
        
        let tabVC = tabsVC[index]
       /* if tabVC.isInitiated == false, let tabID = R.Dict.TabsRequestMapping[tabs[index]] {
            tabsVC.tabID = tabID
            tabsVC.initTopLoading()
            tabsVC.isInitiated = true
        }*/
        
    }
    private func saveCurrentTab(withTitle title: String) {
        UserDefaults.standard[R.Key.CurrentTab] = title
    }
    
    func numbetOfTabs(in horizontalTabsView: HorizontalTabsView) -> Int {
        return tabs.count
    }
    func titleOfTabs(in horizontalTabsView: HorizontalTabsView, forIndex index: Int) -> String {
        return tabs[index]
    }
    func horizontalTabsView(_ horizontalTabsView: HorizontalTabsView, didSelectItemAt index: Int) {
        showPage(atIndex: index, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        showPage(atIndex: index, animated: true)
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x + scrollView.frame.width <= scrollView.contentSize.width {
            showPage(atIndex: index, animated: true)
        }
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }

}













