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
    fileprivate(set) var avatar: String?
    fileprivate(set) var username: String?
    fileprivate(set) var lastReplayUserName: String?
    
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
    
    init(rootNode: HTMLNode) {
        super.init()
        avatar = rootNode.xPath(".//img[@class='avatar']").first?["src"]
        username = rootNode.xPath(".//a[@class='node']/following-sibling::strong/a").first?.content
        if let node = rootNode.xPath(".//a[@class='node']").first {
            nodeName = node.content
            if var href = node["href"], let range = href.range(of: "/go/") {
                href.replaceSubrange(range, with: R.String.Empty)
                nodeID = href
            }
        }
        if let topicNode = rootNode.xPath(".//span[@class='item_title']/a").first {
            topicTitle = topicNode.content
            let topicIDURL = topicNode["href"]
            topicID = topicIDURL?.extractID()
        }
        
        lastReplayDate = rootNode.xPath("./table/tr/td[3]/span[3]").first?.content
        lastReplayUserName = rootNode.xPath("./table/tr/td[3]/span[3]/strong[1]/a[1]").first?.content
        repliesNumber = rootNode.xPath("./table/tr/td[4]/a[1]").first?.content
    }
}

class MemberTopicItemModel: BaseTopicItemModel {
    private(set) var lastReplyUserName: String?
    
    init(rootNode: HTMLNode)
    {
        super.init()
       /* nodeName = rootNode.xPath(".//a[@class='node']").first?.content
        if var href = rootNode.xPath(".//a[@class='node']").first?["href"], let range = href.range(of: "/go/")
        {
            href.replaceSubrange(range, with: R.String.Empty)
            nodeID = href
        }
        topicTitle = rootNode.xPath(".//span[@class='item_title']").first?.content
        let topicIdUrl = rootNode.xPath(".//span[@class='item_title']/a").first?["href"]
        topicIDtopicID = topicIdUrl?.extractId()
        lastReplayDate = rootNode.xPath("./table/tr/td[1]/span[3]").first?.content
        lastReplyUserName  = rootNode.xPath("./table/tr/td[1]/span[3]/strong[1]/a[1]").first?.content
        repliesNumber  = rootNode.xPath("./table/tr/td[2]/a[1]").first?.content*/
    }
}
