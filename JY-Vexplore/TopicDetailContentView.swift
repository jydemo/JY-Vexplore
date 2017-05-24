//
//  TopicDetailContentView.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/15.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import WebKit
class TopicDetailContentView: UIView {
    lazy var contentWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.allowsLinkPreview = true
        return webView
    }()
    
    var imgSrcArray = [String]()
    var contentHeight = CGFloat.leastNormalMagnitude
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentWebView)
        let bindings = ["contentWebView": contentWebView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentWebView]|", metrics: nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentWebView]|", metrics: nil, views: bindings))
        backgroundColor = .background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   /* private func customizeHtml(_ html: String) -> String {
        let htmlHeader = "<html><head><title>VeXplore_Customize_Title</title><meta content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0' name='viewport'>"
        let script = try! String(contentsOfFile: Bundle.main.path(forResource: "ImageClick", ofType: "js")!, encoding: .utf8)
        let style = "<style>" + CSSStyle.default + "</style><script>" + script + "</script></head>"
        let customizedHtml = htmlHeader + style + html + "</html>"
        return customizedHtml
    }*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 

}
