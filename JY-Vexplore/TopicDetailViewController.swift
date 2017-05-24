//
//  TopicDetailViewController.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import WebKit

protocol TopicDetailViewControllerDelegate: class {
    func  showMorIcon()
    func isUnfavoriteTopic(_ unfavorite: Bool)
}

class TopicDetailViewController: BasetableViewController, WKNavigationDelegate{
    var topicID = R.String.Zero
    var topicDetailModel: TopicDetailModel!
    var token: String?
    private var  cotentView = TopicDetailContentView()
    private var lastContentCellheight: CGFloat?
    weak var delegate: TopicDetailDelegate?
    var webViewReloadCount: UInt8 = 0
    
    // MARK: - TopicDetailDelegate 
    
}
