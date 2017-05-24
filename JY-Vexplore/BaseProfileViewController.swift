//
//  BaseProfileViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
enum PersonInfoType: Int {
    case homepage = 0
    case twitter
    case location
    case github
    case twitch
    case psn
}

class BaseProfileViewController: SwipeTransitionViewController {
    enum ProfileSection: Int {
        case avatar = 0
        case favorite
        case followBlack
        case forumActivity
        case personInfo
        case bio
    }
    
    enum ForumAtivitySectionRow: Int {
        case header = 0
        case topics
        case replies
    }
    
    fileprivate lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = R.Constant.EstimatedRowHeight
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var personInfoIconDict = [String: String]()
    var username: String?
    var personInfos = [PersionInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(profileTableView)
        let bindings: [String: Any] = [
            "profileTableView": profileTableView,
            "top": topLayoutGuide
        ]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[profileTableView]|", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top][profileTableView]|", metrics: nil, views: bindings))
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: NSNotification.Name.Setting.NightModeDidChange, object: nil)
    }
    
    @objc private func refreshColorScheme() {
       navigationController?.navigationBar.setupNavigationbar()
        profileTableView.backgroundColor = .background
        view.backgroundColor = .background
    }
    
    func numberOfPersonalInfoforCell() -> Int {
       // var numberOfPersonalInfoCell = 0
        personInfos.removeAll()
        personInfoIconDict.removeAll()
        //if let website =
        return 0
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
    struct PersionInfo {
        let type: PersonInfoType
        let text: String
    }
}
extension BaseProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileSection = ProfileSection(rawValue: indexPath.section)!
        /*switch profileSection {
        case .forumActivity:
            let forumActivitySectionRow = ForumAtivitySectionRow(rawValue: indexPath.row)!
            switch forumActivitySectionRow {
            case .topics:
                //guard let userProfile =
            case .replies:
            default:
                break
            }
        case .personInfo:
            
        default:
            break
        }*/
    }
}
