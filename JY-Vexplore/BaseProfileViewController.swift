//
//  BaseProfileViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SafariServices

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
    
    lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileAvatarCell.self, forCellReuseIdentifier: String(describing: ProfileAvatarCell.self))
        tableView.register(ProfileSectionHeaderCell.self, forCellReuseIdentifier: String(describing: ProfileSectionHeaderCell.self))
        tableView.register(AboutMeCell.self, forCellReuseIdentifier: String(describing: AboutMeCell.self))
        tableView.register(PersonalInfoCell.self, forCellReuseIdentifier: String(describing: PersonalInfoCell.self))
        tableView.estimatedRowHeight = R.Constant.EstimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    fileprivate var personInfoIconDict = [String: String]()
    var userProfile: ProfileModel?
    var username: String?
    var personInfos = [PersionInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isTranslucent = false
        
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
        view.backgroundColor = .white
    }
    
    func numberOfPersonalInfoforCell() -> Int {
       var numberOfPersonalInfoCell = 0
        personInfos.removeAll()
        personInfoIconDict.removeAll()
        if let website = userProfile?.website, website.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personIfno = PersionInfo(type: .homepage, text: website)
            personInfos.append(personIfno)
        }
        if let twitter = userProfile?.twitter, twitter.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personInfo = PersionInfo(type: .twitter, text: twitter)
            personInfos.append(personInfo)
            
        }
        if let location = userProfile?.location, location.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personIfno = PersionInfo(type: .location, text: location)
            personInfos.append(personIfno)
        }
        if let github = userProfile?.github, github.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personIfno = PersionInfo(type: .github, text: github)
            personInfos.append(personIfno)
        }
        if let twitch = userProfile?.twitch, twitch.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personInfo = PersionInfo(type: .twitch, text: twitch)
            personInfos.append(personInfo)
        }
        if let psn = userProfile?.psn, psn.isEmpty == false {
            numberOfPersonalInfoCell += 1
            let personInfo = PersionInfo(type: .psn, text: psn)
            personInfos.append(personInfo)
        }
        return numberOfPersonalInfoCell > 0 ? (numberOfPersonalInfoCell + 1) : 0
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
        switch profileSection {
        case .forumActivity:
            let forumActivitySectionRow = ForumAtivitySectionRow(rawValue: indexPath.row)!
            switch forumActivitySectionRow {
            case .topics:
                guard let userProfile = userProfile, userProfile.topicHidden == false, userProfile.topicsNum > 0 else {
                    return
                }
                let membertopicsVC = MemberTopicsViewController()
                membertopicsVC.username = username
                DispatchQueue.main.async(execute: {
                    self.bouncePresent(navigationVCWith: membertopicsVC, completion: {
                        
                    })
                })
            case .replies:
                guard let userProfile = userProfile, userProfile.topicHidden == false, userProfile.topicsNum > 0 else {
                    return
                }
                let memberrepliesVC = MemberTopicsViewController()
                memberrepliesVC.username = username
                DispatchQueue.main.async(execute: {
                    self.bouncePresent(navigationVCWith: memberrepliesVC, completion: {
                        
                    })
                })
            default:
                break
            }
            
        case .personInfo:
            if indexPath.row > 0 {
                let personInfo = personInfos[indexPath.row - 1]
                let escapedString = personInfo.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let urlString = escapedString, let url = URL(string: urlString) {
                    let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    present(safariVC, animated: true, completion: nil)
                }
                
            }
            
        default:
            break
        }
    }
}
