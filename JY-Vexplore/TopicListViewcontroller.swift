//
//  topicListviewcontroller.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/20.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import NotificationCenter

class TopicListViewController: BasetableViewController {
    
   override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TopicCell.self, forCellReuseIdentifier: String(describing: TopicCell.self))
    //tableView.register(JYTableViewCell.self, forCellReuseIdentifier: String(describing: JYTableViewCell.self))
    
    //tableView.register(UINib(nibName: "JYTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: JYTableViewCell.self))
    NotificationCenter.default.addObserver(self, selector: #selector(handleFontsizeDidChanged), name: Notification.Name.Setting.FontsizeDidChange, object: nil)
    }
    
    @objc private func handleFontsizeDidChanged() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCell.self), for: indexPath) as! TopicCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JYTableViewCell.self), for: indexPath) as! JYTableViewCell
        let topicItem = topicList[indexPath.row]
        cell.model = topicItem
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topicID = topicList[indexPath.row].topicID {
            let topicVC = TopicViewController()
            topicVC.topicID = topicID
            topicVC.ignoreHandler = { topicID -> Void in
                print("topicID: \(topicID)")
                self.removeTopic(withID: topicID)
            }
            DispatchQueue.main.async(execute: { 
                self.bouncePresent(navigationVCWith: topicVC, completion: nil)
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    

}
