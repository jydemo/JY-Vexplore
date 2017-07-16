//
//  NotificationViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class NotificationViewController: BasetableViewController {
    private var currentPage = 1
    private var totalPageNum = 1
    var username: String?
    //private var notifications
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = R.String.Notification
        if currentPage >= totalPageNum {
            enableBottomLoading = false
        } else {
            tableView.tableFooterView = tableFooterView
            enableBottomLoading = true
            bottomLoadingView.iniSquaresNormalPosition()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
