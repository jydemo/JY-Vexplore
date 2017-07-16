//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by atom on 2017/5/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import NotificationCenter
import SharedKit

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    fileprivate let rowHeight: CGFloat = 37.0
    fileprivate var data = [TopicItem]()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.rowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        view.addSubview(tableView)
        let bindings: [String: Any] = ["tableView": tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", metrics: nil, views: bindings))
        //loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       loadData()
    }
    
    func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        loadData()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: rowHeight * CGFloat(data.count))
        }
    }
    
    fileprivate func loadData() {
        let url = "https://www.v2ex.com/api/topics/hot.json"
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            print("back data\(response.debugDescription)")
        }
        task.resume()
        var topics = [TopicItem]()
        Networking.request(url, headers: SharedR.Dict.MobileClientHeaders).responseJSON { (response) in
            if  response.result.isSuccess, let value = response.result.value {
                let json = JSON(object: value)
                for (_, subJSON) in json {
                    if let topicID = subJSON["id"].string, let topicTitle = subJSON["title"].string {
                        let topicItem = TopicItem(id: topicID, title: topicTitle)
                        topics.append(topicItem)
                        print("topicItem \(topicItem)")
                    }
                }
                self.data = topics
                self.tableView.reloadData()
            }
        }
        
    }
    
    fileprivate  struct TopicItem {
        let id: String
        let title: String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicID  = data[indexPath.row].id
        if let url = URL(string: "todayExtension://?\(topicID)") {
            extensionContext?.open(url, completionHandler: nil)
        }
    }
    
}
