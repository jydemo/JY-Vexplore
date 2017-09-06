//
//  MainViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
//    单例
    static let shared = MainViewController()
//    tabbar对应的控制器
    fileprivate let homeVC = HomePageViewController()
    fileprivate let nodesVc = NodesViewController()
    fileprivate let searchVC = SiteSearchViewController()
    fileprivate var notificationVC: NotificationViewController!
    fileprivate var profileVC: MyProfileViewController!
//
    fileprivate var notificationTabItem: UITabBarItem!
    
    fileprivate init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildUI()
    }
    //MARK: - buildUI
    fileprivate func buildUI() {
//        是否登陆，是， 从缓存中加载 NodesViewController
        if User.shared.isLogin == true, let diskCachePAth = cachePathString(withFilename: NodesViewController.description()), let unarchiveVC = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePAth), unarchiveVC is NotificationViewController {
//            配置从缓存中加载的NotificationViewController
            let VC = unarchiveVC as! NotificationViewController
            if VC.username == User.shared.username {
                notificationVC = VC
            }
        } else {
            notificationVC = NotificationViewController()
        }
//        如果没有登录，新生成一个NotificationViewController控制器  notificationVC = notificationVC ?? NotificationViewController()
//       同上面的循环体一样，这里是获得MyProfileViewController控制器
        if User.shared.isLogin == true, let diskCachePAth = cachePathString(withFilename: MyProfileViewController.description()), let unarchiveVC = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePAth), unarchiveVC is MyProfileViewController {
            profileVC = unarchiveVC as! MyProfileViewController
        } else {
            profileVC = MyProfileViewController()
        }
        
//        把控制器放在导航控制下面
        let homeNav = UINavigationController(rootViewController: homeVC)
        let nodesNav = UINavigationController(rootViewController: nodesVc)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let notificationNav = UINavigationController(rootViewController: notificationVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
//        设置控制器对应的tabbar信息
        homeNav.tabBarItem = UITabBarItem(title: nil, image: R.Image.Home, selectedImage: R.Image.Home)
        nodesNav.tabBarItem = UITabBarItem(title: nil, image: R.Image.Nodes, selectedImage: R.Image.Nodes)
        searchNav.tabBarItem = UITabBarItem(title: nil, image: R.Image.TabarSearch, selectedImage: R.Image.TabarSearch)
        notificationNav.tabBarItem = UITabBarItem(title: nil, image: R.Image.Notification, selectedImage: R.Image.Notification)
        profileNav.tabBarItem = UITabBarItem(title: nil, image: R.Image.Profile, selectedImage: R.Image.Profile)
//        tabbar控制器的子控制器数组
        viewControllers = [homeNav, nodesNav, searchNav, notificationNav, profileNav]
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: NSNotification.Name.Setting.NightModeDidChange, object: nil)
        
    }
    
    
    
    
    
    @objc private func refreshColorScheme() {
        tabBar.setuptabBar()
    }
    
    func setNotificationNum(_ number: Int) {
        notificationTabItem.badgeValue = number > 0 ? String(number) : nil
    }

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
