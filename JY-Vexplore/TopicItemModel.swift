//
//  TopicItemModel.swift
//  JY-VeX
//
//  Created by atom on 2017/5/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class BaseTopicItemModel: NSObject {
    fileprivate(set) var topicID: String?
    fileprivate(set) var topicTitle: String?
    fileprivate(set) var nodeName: String?
    fileprivate(set) var nodeID: String?
    fileprivate(set) var lastReplayDate: String?
    fileprivate(set) var repliesNumber: String?
}

class TopicItemModel: BaseTopicItemModel {
    private(set) var avatar: String?
    private(set) var username: String?
    private(set) var lastReplayUserName: String?
    
    func  encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(topicID, forKey: "topicID")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(nodeName, forKey: "nodeName")
        aCoder.encode(nodeID, forKey: "nodeId")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(topicTitle, forKey: "topicTitle")
        aCoder.encode(lastReplayDate, forKey: "lastReplyDate")
        aCoder.encode(lastReplayUserName, forKey: "lastReplyUserName")
        aCoder.encode(repliesNumber, forKey: "repliesNumber")
    }
}
