//
//  URLAnalyzer.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

struct URLAnalysisResult {
    enum URLType: Int {
        case  url = 0
        case memeber
        case topic
        case node
        case email
        case undefined
    }
    
    static let ppatternsRE: [NSRegularExpression] = R.Array.URLPatterns.map { try!  NSRegularExpression(pattern: $0, options: .caseInsensitive)}
    var type: URLType = .undefined
    var value: String?
    init(url: String) {
        for (index, regex) in URLAnalysisResult.ppatternsRE.enumerated() {
            if regex.numberOfMatches(in: url, options: .withoutAnchoringBounds, range: NSMakeRange(0, url.length)) > 0 {
                type = URLType(rawValue: index)!
                switch type {
                case .url:
                    value = url
                case .memeber:
                    if let range = url.range(of: "/memeber/") {
                        let username  = url.substring(from: range.upperBound)
                        value = username
                    }
                case .topic:
                    if let range = url.range(of: "/t/") {
                        var topicID = url.substring(from: range.upperBound)
                        if let range = topicID.range(of: "?") {
                            topicID = topicID.substring(to: range.lowerBound)
                        }
                        if let range = topicID.range(of: "#") {
                            topicID = topicID.substring(to: range.lowerBound)
                        }
                        value = topicID
                    }
                case .node:
                    if let range = url.range(of: "/go/") {
                        let nodeID = url.substring(from: range.upperBound)
                        value = nodeID
                    }
                case .email:
                    if let rang = url.range(of: "mailto:") {
                        let recipient = url.substring(from: rang.upperBound)
                        value = recipient
                    }
                default:
                    break
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
