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
    NotificationCenter.default.addObserver(self, selector: #selector(handleFontsizeDidChanged), name: Notification.Name.Setting.FontsizeDidChange, object: nil)
    }
    
    @objc private func handleFontsizeDidChanged() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCell.self), for: indexPath) as! TopicCell
        let topicItem = topicList[indexPath.row]
        cell.model = topicItem
        /*cell.topicItemModel = topicItem
        cell.topicTitleLabel.text = topicItem.topicTitle
        cell.userNameLabel.text = topicItem.username
        cell.nodeNameBtn.setTitle(topicItem.nodeName, for: .normal)
        if let repliesNumberString = topicItem.repliesNumber, repliesNumberString.isEmpty == false {
            cell.repliesNumberLabel.text = repliesNumberString
        }
        if let avatar = topicItem.avatar, let url = URL(string: R.String.Https + avatar) {
           // cell.avatarImageView.avatarImage(withURL: url)
        }
        cell.userNameLabel.text = topicItem.username
        cell.avatarImageView.image = UIImage(named: "IMG_0173.jpg")
        cell.lastReplayDateAndUserLabel.text = R.String.NoRepliesNow
        if let lastReplyDate = topicItem.lastReplayDate {
            if topicItem.lastReplayUserName != nil {
                cell.lastReplayDateAndUserLabel.text = lastReplyDate
            } else  {
                cell.lastReplayDateAndUserLabel.text = String(format: R.String.PublicDate, lastReplyDate)
            }
        }*/
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
