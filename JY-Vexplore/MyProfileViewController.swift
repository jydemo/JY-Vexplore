//
//  MyProfileViewController.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SharedKit

class MyProfileViewController: BaseProfileViewController, ProfileAvatarCellDelegate {
//    导航栏上的退出按钮
    private lazy var logoutBtn: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: R.Image.Logout, style: .plain, target: self, action: #selector(logoutBtnTapped))
        barButtonItem.tintColor = .middlegray
        return barButtonItem
    }()
//导航栏上的设置按钮
    private lazy var settingBtn: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: R.Image.Setting, style: .plain, target: self, action: #selector(settingBtnTapped))
        barButtonItem.tintColor = .middlegray
        return barButtonItem
    }()
    
    fileprivate var favoritesNodesNum = R.String.Zero
    fileprivate var favoriteTopicsNum = R.String.Zero
    fileprivate var followingsNum = R.String.Zero
    private var needRefreshProfile = false
    //private inputVC = Topic
    private var cacheSize: String?
    private var geMemberInfoRequest: Request?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dismissStyle = .none
    }
    
    override func encode(with aCoder: NSCoder) {
//
        aCoder.encode(userProfile, forKey: "userProfile")
        aCoder.encode(favoritesNodesNum, forKey: "favoritesNodesNum")
        aCoder.encode(favoriteTopicsNum, forKey: "favoriteTopicsNum")
        aCoder.encode(followingsNum, forKey: "followingsNum")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        userProfile = aDecoder.decodeObject(forKey: "userProfile") as? ProfileModel
        favoritesNodesNum = aDecoder.decodeObject(forKey: "favoritesNodesNum") as! String
        favoriteTopicsNum = aDecoder.decodeObject(forKey: "favoriteTopicsNum") as! String
        followingsNum = aDecoder.decodeObject(forKey: "followingsNum") as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        设置导航栏标题
        navigationItem.title = R.String.Profile
//        注册cell
        profileTableView.register(MyFavoriteCell.self, forCellReuseIdentifier: String(describing: MyFavoriteCell.self))
        navigationItem.leftBarButtonItem = settingBtn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.transform = .identity
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // if let presentedVC  = presentationController, presentedVC is
        if needRefreshProfile || userProfile == nil {
            
        }
        
    }
    
    @objc private func profileDidChanged() {
        needRefreshProfile = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - logoutBtnTapped
    @objc private func logoutBtnTapped() {
        
    }
    //MARK: - settingBtnTapped
    @objc private func settingBtnTapped() {
        
    }
    //MARK: - refreshProfile
    func refreshProfile() {
//        判断是否登录
        if User.shared.isLogin {
//            已经登录，获取用户名 设置退出按钮
            username = User.shared.username
            navigationItem.rightBarButtonItem = logoutBtn
        } else {
            return
        }
//        在进行网络请求的时候，在状态栏显示网路请求指示器
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    //MARK: - refreshFavorites
    private func refreshFavorites() {
//        判断是否登录
        guard User.shared.isLogin == true else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    //MARK: - resetProfileView
    private func resetProfileView() {
//        更新个人信息的时候，清空已经设置的个人信息
        userProfile = nil
        username = nil
        profileTableView.reloadData()
        navigationItem.rightBarButtonItem = nil
    }

}
extension MyProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
//        表格有6部分
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
//        根据section，决定每个section多少个cell
        let profileSection = ProfileSection(rawValue: section)!
        switch profileSection {
        case .avatar:
            numberOfRow = 1
        case .favorite:
            numberOfRow = 1
        case .forumActivity:
            numberOfRow = 3
        case .personInfo:
            numberOfRow = numberOfPersonalInfoforCell()
        case .bio:
            if let bio = userProfile?.bio, bio.isEmpty == false {
                numberOfRow = 2
            }
        default:
            break
        }
        return numberOfRow
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileSection = ProfileSection(rawValue: indexPath.section)!
        switch profileSection {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileAvatarCell.self), for: indexPath) as! ProfileAvatarCell
            cell.delegate = self
            cell.writeBtn.isHidden = !User.shared.isLogin
            cell.nameLabel.text = userProfile?.username ?? R.String.NotLogin
            if let avatar = userProfile?.avatar {
                let url = URL(string: R.String.Https + avatar)!
                cell.avatarImageView.avatarImage(withURL: url)
            }
            cell.jointimeLabel.text = userProfile?.createdInfo
            if let tagline = userProfile?.tagline, tagline.isEmpty == false {
                cell.contentLabel.text = R.String.PersonalTagline + tagline
            }
            return cell
        case .favorite:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyFavoriteCell.self), for: indexPath) as! MyFavoriteCell
            if userProfile != nil {
                cell.topicsView.numLabel.text = favoriteTopicsNum
                cell.nodesView.numLabel.text = favoritesNodesNum
                cell.followingView.numLabel.text = followingsNum
                cell.delegate = self
            }
            return cell
        case .forumActivity:
            let forumActivitySectionrow = ForumAtivitySectionRow(rawValue: indexPath.row)!
            switch forumActivitySectionrow{
                case .header:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileSectionHeaderCell.self), for: indexPath) as! ProfileSectionHeaderCell
                cell.titleLabel.text = R.String.ForumActivity
                return cell
            case .topics:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalInfoCell.self), for: indexPath) as! PersonalInfoCell
                if userProfile == nil || userProfile?.topicsNum == 0 {
                    cell.contentLabel.text = R.String.AllTopicsZero
                } else {
                    cell.contentLabel.text = String(format: R.String.AllTopicsMoreThan, userProfile?.topicsNum ?? 0)
                }
                cell.iconImageView.image = R.Image.Topics
                cell.iconImageView.tintColor = UIColor.darkGray
                return cell
            case .replies:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalInfoCell.self), for: indexPath) as! PersonalInfoCell
                if userProfile == nil || userProfile?.repliesNum == 0 {
                    cell.contentLabel.text = R.String.AllRepliesZero
                } else {
                    cell.contentLabel.text = String(format: R.String.AllRepliesMoreThan, userProfile?.repliesNum ?? 0)
                }
                cell.longLine.isHidden = false
                cell.iconImageView.image = R.Image.Replies
                cell.iconImageView.tintColor = UIColor.darkGray
                return cell
            }
            
        case .personInfo:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileSectionHeaderCell.self), for: indexPath) as! ProfileSectionHeaderCell
                cell.titleLabel.text = R.String.PersonalInfo
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalInfoCell.self), for: indexPath) as! PersonalInfoCell
                if personInfos.count > indexPath.row - 1 {
                    let personInfo = personInfos[indexPath.row - 1]
                    cell.iconImageView.image = R.Dict.PersonInfoIcons[personInfo.type]
                    cell.iconImageView.tintColor = UIColor.darkGray
                    cell.contentLabel.text = personInfo.text
                }
                cell.longLine.isHidden = (indexPath.row != personInfos.count)
                return cell
            }
        case .bio:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileSectionHeaderCell.self), for: indexPath) as! ProfileSectionHeaderCell
                cell.titleLabel.text = R.String.PersonalBio
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutMeCell.self), for: indexPath) as! AboutMeCell
                cell.contentLabel.text = userProfile?.bio
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if User.shared.isLogin {
            super.tableView(tableView, didSelectRowAt: indexPath)
        } else {
            
        }
    }
}
extension MyProfileViewController: MyFavoriteCellDelegate {
    func favoriteTopicsTapped() {
        guard favoriteTopicsNum != R.String.Zero else {
            return
        }
        
    }
    func favoriteNodesTapped() {
        
        
    }
    
    func myFollowingtapped() {
        
    }
}




extension MyProfileViewController {
    func writeBtnTapped() {
        
    }
}
