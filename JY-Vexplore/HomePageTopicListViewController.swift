//
//  HomePageTopicListViewController.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/25.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class HomePageTopicListViewController: TopicListViewController {
    fileprivate let TabBarHiddenDuration = 0.25
    var tabID = "tech"
    var isInitated = false
    var lastOffSetY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = R.Constant.EstimatedRowHeight
    }
    // MARK: - 从缓存中加载数据
    fileprivate func loadCache() {
        let cacheKey = String(format: R.Key.HomePageTopicList, tabID)
        if let diskCachePath = cachePathString(withfilename: cacheKey), let cacheTopicList = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePath) as? [TopicItemModel] {
            topicList = cacheTopicList
            tableView.reloadData()
        }
    }

    
    override func topLoadingRequest() {
        V2request.Topic.getTabList(withTabID: tabID) { [unowned self] (response) in
            self.stopLoading(withLoadingStyle: .top, success: response
                .success, completion: { (success) in
                    if success, let value = response.value {
                        self.topicList = value
                        self.tableView.reloadData()
                    }
                    
            })
        }
    }
    // MARK: - 重写scrollViewDidScroll方法
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if UserDefaults.isTabBarHiddenEnabled && scrollView.contentSize.height >= scrollView.frame.height {
            var inset = tableView.contentInset
            if inset.bottom != 0.0 {
                inset.bottom = 0.0
                tableView.contentInset = inset
            }
        } else {
            var inset = tableView.contentInset
            if let tabbarHeight = tabBarController?.tabBar.frame.height, inset.bottom != tabbarHeight {
                inset.bottom = tabbarHeight
                tableView.contentInset = inset
            }
        }
        
        guard isInitated && UserDefaults.isTabBarHiddenEnabled else {
            return
        }
        //底部tabbar的frame
        if let tabbarFrame = tabBarController?.tabBar.frame {
            
            if scrollView.contentSize.height < scrollView.frame.height {
                UIView.animate(withDuration: TabBarHiddenDuration, animations: { 
                    self.tabBarController?.tabBar.transform = .identity
                })
                return
            }
            if scrollView.contentOffset.y < 0 {
                UIView.animate(withDuration: TabBarHiddenDuration, animations: { 
                    self.tabBarController?.tabBar.transform = .identity
                })
                return
            }
            if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
                UIView.animate(withDuration: TabBarHiddenDuration, animations: { 
                    self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: tabbarFrame.height)
                })
                return
            }
            let srollOffsetY = scrollView.contentOffset.y - lastOffSetY
            if srollOffsetY > 2 {
                UIView.animate(withDuration: TabBarHiddenDuration, animations: { 
                    self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: tabbarFrame.height)
                })
            }
            if srollOffsetY < -2 {
                UIView.animate(withDuration: TabBarHiddenDuration, animations: { 
                    self.tabBarController?.tabBar.transform = .identity
                })
            }
        }
        lastOffSetY = scrollView.contentOffset.y
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
