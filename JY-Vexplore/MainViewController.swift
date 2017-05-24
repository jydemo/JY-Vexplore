//
//  MainViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    static let shared = MainViewController()
    
    private let homeVC = HomePageViewController()
    private let nodesVc = NodesViewController()
    private let searchVC = SiteSearchViewController()
    private var notificationVC: NotificationViewController!
    private var profileVC: MyProfileViewController!
    private var notificationTabItem: UITabBarItem!
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func buildUI() {
        if User.shared.isLogin == true, let diskCachePAth = cachePathString(withfilename: NodesViewController.description()), let unarchiveVC = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePAth), unarchiveVC is NotificationViewController {
            let VC = unarchiveVC as! NotificationViewController
            if VC.username == User.shared.username {
                notificationVC = VC
            }
        }
        notificationVC = notificationVC ?? NotificationViewController()
        if User.shared.isLogin == true, let diskCachePAth = cachePathString(withfilename: MyProfileViewController.description()), let unarchiveVC = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePAth), unarchiveVC is MyProfileViewController {
            profileVC = unarchiveVC as! MyProfileViewController
        } else {
            profileVC = MyProfileViewController()
        }
        
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
