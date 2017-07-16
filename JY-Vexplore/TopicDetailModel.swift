//
//  TopicDetailModel.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/15.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

class TopicDetailModel: NSObject
{
    fileprivate(set) var avatar: String?
    fileprivate(set) var nodeName: String?
    fileprivate(set) var nodeId: String?
    fileprivate(set) var username: String?
    fileprivate(set) var topicTitle: String?
    fileprivate(set) var topicContent: String!
    fileprivate(set) var date: String?
    fileprivate(set) var favoriteNum: String?
    fileprivate(set) var token: String?
    fileprivate(set) var commentTotalPages = 1
    fileprivate(set) var isFavorite = false
    fileprivate(set) var topicCommentTotalCount: String?
    fileprivate(set) var reportUrl: String?
    fileprivate(set) var topicId: String?
    
    init(id: String, rootNode: HTMLNode)
    {
        self.topicId = id
        
        if let node = rootNode.xPath("./div[1]/a[2]").first
        {
            nodeName = node.content
            if var href = node["href"],
                let range = href.range(of: "/go/")
            {
                href.replaceSubrange(range, with: R.String.Empty)
                nodeId = href
            }
        }
        avatar = rootNode.xPath(".//img[@class='avatar']").first?["src"]
        username = rootNode.xPath(".//small[contains(text(),'By')]/a").first?.content
        topicTitle = rootNode.xPath(".//h1").first?.content
        topicContent = rootNode.xPath("./div[@class='cell']/div").first?.rawContent ?? R.String.Empty
        
        // Append
        let appendNodes = rootNode.xPath("./div[@class='subtle']")
        for node in appendNodes
        {
            if let content = node.rawContent
            {
                topicContent = topicContent + content
            }
        }
        date = rootNode.xPath("./div[1]/small/text()").last?.content
        favoriteNum = rootNode.xPath(".//div[@class='inner']/div/span").first?.content?.stringbyRemoveingNewLinesAndWhitespace()
        if rootNode.xPath(".//a[text()='取消收藏']").count > 0
        {
            isFavorite = true
        }
        if let token = rootNode.xPath(".//a[@class='op'][1][text()='加入收藏' or text()='取消收藏']").first?["href"]
        {
            let array = token.components(separatedBy: "?t=")
            if array.count == 2
            {
                self.token = array[1]
            }
        }
        if let topicCommentTotalCountText = rootNode.xPath("//div[@class='box']/div[@class='cell']/span").first?.content,
            let range = topicCommentTotalCountText.range(of: " 回复")
        {
            topicCommentTotalCount = topicCommentTotalCountText.substring(to: range.lowerBound)
        }
        if let id = rootNode.xPath("//a[contains(@onclick,'报告这个主题')]").first?["onclick"],
            let startRange = id.range(of: "/report/topic/"),
            let endRange = id.range(of: "\'; }")
        {
            reportUrl = id.substring(with: Range(startRange.upperBound..<endRange.lowerBound))
        }
    }
    
    
}
