//
//  HomePageViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate, HorizontalTabsViewDelegate{
    
    fileprivate lazy var tabsScrollview: HorizontalTabsView = {
        let view = HorizontalTabsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tabsDelegate = self
        return view
    }()
    ///内容滚动视图
    lazy var contentSlideView: UIScrollView = {
        let view  = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = true
        return view
    }()
    fileprivate lazy var recentBtn: UIBarButtonItem = {
        let recentBtn = UIBarButtonItem(image: R.Image.Time, style: .plain, target: self, action: #selector(recentBtnTapped))
        return recentBtn
    }()
    
    fileprivate var tabs = R.Array.AllTabsTitle
    fileprivate var currentTab: String!
    fileprivate var tabsVC = [HomePageTopicListViewController]()
    override func loadView() {
        super.loadView()
        let userDefaults = UserDefaults.standard
        if let showedTabsTitle = userDefaults.array(forKey: R.Key.ShowedTabs) {
            //tabbar item上面的标题
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
        
        refreshColorScheme()
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func recentBtnTapped() {
    
    }
    @objc fileprivate func sortBtnTapped() {}
    
    @objc fileprivate func refreshColorScheme() {
       navigationController?.navigationBar.setupNavigationbar()
        contentSlideView.backgroundColor = .background
    }
    @objc fileprivate func didLogin() {
        navigationItem.leftBarButtonItem = recentBtn
    }
    @objc fileprivate func didLogout(){
        navigationItem.leftBarButtonItem = nil
    }
    // MARK: - Setup
    fileprivate func setup() {
        view.layoutIfNeeded()
        setupTabs()
        //设置当前标签
        var index = 0
        if let currentTab = UserDefaults.standard[R.Key.CurrentTab], let savedIndex = tabs.index(of: currentTab) {
            index = savedIndex
        }
        setupcontentSliderViewAndShowPage(atIndex: index)
    
    }
    // MARK: - setupTabs
    fileprivate func setupTabs() {
        var previousView: UIView?
        //循环tabs数组，取出标签
        for index in 0..<tabs.count {
            //新建HomePageTopicListViewController对象
            let topicListVC = HomePageTopicListViewController()
            //配置topicListVC
            topicListVC.view.translatesAutoresizingMaskIntoConstraints = false
            topicListVC.dismissStyle = .none
            addChildViewController(topicListVC)
            //把topicListVC添加到tabsVC数组
            tabsVC.append(topicListVC)
            //topicListVC添加到当前控制器
            topicListVC.didMove(toParentViewController: self)
            //topicListVC的视图作为子视图添加到contentSlideView
            contentSlideView.addSubview(topicListVC.view)
            //调整topicListVC视图布局
            topicListVC.view.widthAnchor.constraint(equalTo: contentSlideView.widthAnchor).isActive = true
            topicListVC.view.heightAnchor.constraint(equalTo: contentSlideView.heightAnchor).isActive = true
            topicListVC.view.topAnchor.constraint(equalTo: contentSlideView.topAnchor).isActive = true
            //如果存在previousView
            if let previousView = previousView {
                //调整topicListVC视图和previousView的位置关系，（左右对齐）
                topicListVC.view.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
            } else {
                //不存在，topicListVC视图左边直接对齐contentSlideView左边
                topicListVC.view.leadingAnchor.constraint(equalTo: contentSlideView.leadingAnchor).isActive = true
            }
            //如果topicListVC是第一个视图，topicListVC右边对齐contentSlideView右边
            if index == tabs.count - 1 {
                topicListVC.view.trailingAnchor.constraint(equalTo: contentSlideView.trailingAnchor).isActive = true
            }
            //把topicListVC的视图设置previousView（前视图）
            previousView = topicListVC.view
        }
    }
    // MARK: - resetTabs
    fileprivate func resetTabs() {
        //便利子控制器
        for childVC in childViewControllers {
            //子控制器和它的视图从当前控制器移除
            childVC.view.removeFromSuperview()
            childVC.willMove(toParentViewController: self)
            childVC.removeFromParentViewController()
        }
        //清空tabsVC数组
        tabsVC.removeAll()
        //重新设置tabBar
        setupTabs()
    }
    // MARK: - setupcontentSliderViewAndShowPage
    fileprivate func setupcontentSliderViewAndShowPage(atIndex index: Int) {
        //设置内容滚动视图的contentSize
        contentSlideView.contentSize = CGSize(width: CGFloat(tabs.count) * view.frame.width, height: 0)
        showPage(atIndex: index, animated: false)
    }
    
    // MARK: - showPage
    func showPage(atIndex index: Int, animated: Bool) {
//根据tableview视图在内容滚动视图的index，让对应标签处于选中状态
        let indexPath = IndexPath(row: index, section: 0)
        tabsScrollview.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
//根据index，滚动到相应的topicslist控制器
        let offsetX = contentSlideView.bounds.width * CGFloat(index)
        contentSlideView.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: animated)
//并设置为当前tab
        currentTab = tabs[index]
//UserDefaults保存currentTab
        saveCurrentTab(withTitle: currentTab)
//取出相应的HomePageTopicListViewController实例
        let tabVC = tabsVC[index]
//        配置tabVC
        if tabVC.isInitated == false, let tabID = R.Dict.TabsRequestMapping[tabs[index]] {
            tabVC.tabID = tabID
            tabVC.initTopLoading()
            tabVC.isInitated = true
        }
        
        
    }
    // MARK: - saveCurrentTab
    fileprivate func saveCurrentTab(withTitle title: String) {
        UserDefaults.standard[R.Key.CurrentTab] = title
    }
    
    // MARK: - 实现HorizontalTabsViewDelegate代理中的方法
    func numbetOfTabs(in horizontalTabsView: HorizontalTabsView) -> Int {
//        tabsScrollview包含几个标签
        return tabs.count
    }
    func titleOfTabs(in horizontalTabsView: HorizontalTabsView, forIndex index: Int) -> String {
//        标签的标题
        return tabs[index]
    }
    func horizontalTabsView(_ horizontalTabsView: HorizontalTabsView, didSelectItemAt index: Int) {
//        根据选中的标签，显示相应的内容
        showPage(atIndex: index, animated: true)
    }
    // MARK: - scrollView代理方法
//    滚动动画结束时
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        获取滚动到的位置
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        根据index显示相应的内容
        showPage(atIndex: index, animated: true)
//激活手势相应
        scrollView.panGestureRecognizer.isEnabled = true
    }
//    滚动要停下来
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x + scrollView.frame.width <= scrollView.contentSize.width {
            showPage(atIndex: index, animated: true)
        }
        scrollView.panGestureRecognizer.isEnabled = true
    }
//    开始滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }

}













