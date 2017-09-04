//
//  V2Request.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/25.
//  Copyright © 2017年 atom. All rights reserved.
//

import SharedKit

struct V2request {
    struct Topic {
        static func getTabList(withTabID tabID: String? = nil, completionHandler: @escaping (ValueResponse<[TopicItemModel]>) -> Void) -> Void {
            var params = [String: String]()
            if let tabID = tabID {
                params["tab"] = tabID
            } else {
                params["tab"] = "tech"
            }
            let url = R.String.BaseUrl
           Networking.request(url, parameters: params, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
            var resultArray: [TopicItemModel] = []
            if let htmlDoc = response.result.value {
                if let aRootNode = htmlDoc.xPath(".//div[@class='cell item']") {
                    for aNode in aRootNode {
                        let topic = TopicItemModel(rootNode: aNode)
                        resultArray.append(topic)
                    }
                    
                }
                if let aRootNode = htmlDoc.xPath(".//a[@href='/mission/daily']")?.first, aRootNode.content == "领取今日的登录奖励" {
                    
                }
            }
            let response = ValueResponse<[TopicItemModel]>(value: resultArray, success: response.result.isSuccess)
            completionHandler(response)
            }
        }
        
        static func getDetail(withTopicID topicID: String, completionHandler: @escaping (ValueResponse<TopicDetailModel?>) -> Void) -> Void {
            let url = R.String.BaseUrl + "/t/" + topicID
            Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
                if response.result.isSuccess, response.request?.url?.absoluteString != response.response?.url?.absoluteString {
                    let response = ValueResponse<TopicDetailModel?>(success: false, message: [R.String.NeedLoginError])
                    completionHandler(response)
                    return
                }
                var topicModel: TopicDetailModel?
                if let htmlDoc = response.result.value {
                    if let aRootModel = htmlDoc.xPath(".//*[@id='Wrapper']/div[@class='content']/div[@class='box'][1]")?.first {
                        topicModel = TopicDetailModel(id: topicID, rootNode: aRootModel)
                        
                    }
                    //User.shared.
                }
                let handler = ValueResponse<TopicDetailModel?>(value: topicModel, success: response.result.isSuccess)
                completionHandler(handler)
            }
        }
        
        static func favoriteTopic(_ favorite: Bool, topicID:String, token: String, completionHandler: @escaping (CommonResponse) -> Void) -> Void {
            let url = favorite ? (R.String.BaseUrl + "/favorite/topic/" + topicID + "?t=" + token) : (R.String.BaseUrl + "/unfavorite/topic/" + topicID + "?t=" + token)
            Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseString { (response) in
                if response.result.isSuccess {
                    completionHandler(CommonResponse(success: true))
                } else {
                    completionHandler(CommonResponse(success: false))
                }
            }
        }
        
        static func getComments(withTopicID topicID: String, page: Int, completionHandler: @escaping (ValueResponse<([TopicCommentModel], Int)>) -> Void) {
            let url = R.String.BaseUrl + "/t/" + topicID + "?p=\(page)"
            Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
                if response.result.isSuccess, response.request?.url?.absoluteString != response.response?.url?.absoluteString {
                    let response = ValueResponse<([TopicCommentModel], Int)>(success: false, message: [R.String.NeedLoginError])
                    completionHandler(response)
                    return
                }
                var topicCommentsArray: [TopicCommentModel] = []
                var totalCommentPAge: Int = 1
                if let htmlDoc = response.result.value {
                    if let aRootNode = htmlDoc.xPath(".//div[@class='box']/div[attribute::id]") {
                        for aNode in aRootNode {
                            topicCommentsArray.append(TopicCommentModel(rootNode: aNode))
                        }
                    }
                    if let totalCommentPageText = htmlDoc.xPath(".//a[@class='page_normal']")?.last?.content {
                        totalCommentPAge = Int(totalCommentPageText) ?? 1
                    }
                }
                let handler = ValueResponse(value: (topicCommentsArray, totalCommentPAge), success: response.result.isSuccess)
                completionHandler(handler)
            }
        }
        
        static func ignoreTopic(withTopicID topicID: String, completionHandler: @escaping (CommonResponse) -> Void) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    }
    
    struct Accout {
        static func Login(withUsername username: String, password: String, completionHandler: @escaping (ValueResponse<String>) -> Void) -> Request {
            User.shared.removeAllCookies()
            let url = R.String.BaseUrl + "/signin"
            let request = Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
                if let htmlDoc = response.result.value, let onceStr = htmlDoc.xPath(".//*[@name='once'][1]")?.first?["value"], let usernameFieldName = htmlDoc.xPath(".//input[@class='sl' and @type='text']")?.first?["name"], let passwordFieldName = htmlDoc.xPath(".//input[@class='sl' and @type='password']")?.first?["name"] {
                    Accout.Login(withUsername: username, password: password, once: onceStr, usernameFieldName: usernameFieldName, passwordFieldName: passwordFieldName, completionHandler: completionHandler)
                    return
                }
                completionHandler(ValueResponse(success: false))
            }
            return request
        }
        
        static func Login(withUsername username: String, password: String, once: String, usernameFieldName: String, passwordFieldName: String, completionHandler: @escaping (ValueResponse<String>) -> Void) {
            let parameters = ["once": once, "next": "/", passwordFieldName: password, usernameFieldName: username]
            var dict = SharedR.Dict.MobileClientHeaders
            dict["Refresh"] = "https://v2ex.com/signin"
            let url = R.String.BaseUrl + "/signin"
            Networking.request(url, method: .post, parameters: parameters, headers: dict).responseParsableHTML { (response) in
                if let htmlDoc = response.result.value {
                    if let memberNode = htmlDoc.xPath(".//*[@id='Top']//a[contains(@href,'/member/')]")?.first, var username = memberNode["href"], username.hasPrefix("/member/") {
                        username = username.replacingOccurrences(of: "/member", with: R.String.Empty)
                        completionHandler(ValueResponse(value: username, success: true))
                        return
                    }
                }
                completionHandler(ValueResponse(success: false))
            }
        }
        
        
    }
    
    struct Profile {
        @discardableResult static func getMemberInfo(withUsername username: String, completionHandler: ((ValueResponse<ProfileModel>) -> Void)? = nil) -> Request? {
            
            let url = R.String.BaseUrl + "/member/" + username
            let request = Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
                if let htmlDoc = response.result.value, let aRootNode = htmlDoc.xPath(".//*[@id='Wrapper']/div")?.first {
                    let member = ProfileModel(rootNode: aRootNode)
                    User.shared.getNotificationsNum(withNode: htmlDoc.rootNode!)
                    completionHandler?(ValueResponse(value: member, success: true))
                }
                completionHandler?(ValueResponse(success: false))
            }
            return request
        }
        
        static func getMemberTopics(withUsername username: String, page: Int, completionHandler: ((ValueResponse<([MemberTopicItemModel], Int, String)>) -> Void)? = nil) {
            let url = R.String.BaseUrl + "/member/" + username + "/topics?p=\(page)/"
            Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseParsableHTML { (response) in
                var topicArray = [MemberTopicItemModel]()
                if let htmldoc = response.result.value {
                    var topicsPage: Int = 1
                    if var topicsPageText = htmldoc.xPath(".//td[@align='center']/strong")?.first?.content, let range = topicsPageText.range(of: "/") {
                        topicsPageText = topicsPageText.substring(from: range.upperBound)
                        topicsPage = Int(topicsPageText) ?? 1
                    }
                    let topicsNum = htmldoc.xPath(".//span[contains(text(), '主题总数 ')]/following-sibling::strong")?.first?.content ?? R.String.Zero
                    if let nodes = htmldoc.xPath(".//div[@class='cell item']") {
                        for rootNode in nodes {
                            let item = MemberTopicItemModel(rootNode: rootNode)
                            topicArray.append(item)
                        }
                    }
                    completionHandler?(ValueResponse(value: (topicArray, topicsPage, topicsNum), success: true))
                    return
                }
                completionHandler?(ValueResponse(success: false))
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
