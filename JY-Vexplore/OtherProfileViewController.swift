//
//  OtherViewController.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/9.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class OtherProfileViewController : BaseProfileViewController {
    
    private var isFowlling = true
    var unfollowingHandler: UnfavoriteHandler?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileTableView.bounces = false
        if let diskCachePath = cachePathString(withfilename: classForCoder.description()), let userProfile = NSKeyedUnarchiver.unarchiveObject(withFile: diskCachePath) as? ProfileModel, userProfile.username  == username {
            self.userProfile = userProfile
            self.profileTableView.reloadData()
        } else {
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let username = username, isFowlling == false {
            self.unfollowingHandler?(username)
            
        }
        super.viewWillDisappear(animated)
    }
    
    func profileLoadingRequest() {
        guard let username = username else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        V2request.Profile.getMemberInfo(withUsername: username) { [unowned self] (response: ValueResponse<ProfileModel>) in
            if response.success, let value = response.value {
                self.userProfile = value
                self.profileTableView.reloadData()
                if let diskCachePath = cachePathString(withfilename: self.classForCoder.description()) {
                        NSKeyedArchiver.archiveRootObject(self.userProfile!, toFile: diskCachePath)
                    
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

/*extension OtherProfileViewController: MemberFollowBlockCell {
    func followViewTapped() {}
    func blockViewTapped() {}
}*/

extension OtherProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userProfile != nil ? 6 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = 0
        let profileSection = ProfileSection(rawValue: section)!
        /*switch profileSection {
        case .avatar:
            numberOfRow = 1
        case .followBlock:
            if User.shared.isLogin, username != User.shared.username {
                numberOfRow = 1
                
            }
        case .forumActivity:
            numberOfRow = 3
        case .personInfo:
            numberOfRow = numberOfPersonalInfoforCell()
        case .bio:
            if let bio = userProfile.bio, bio.isEmpty == false {
                numberOfRow = 2
                
            }
        default:
            break
        }*/
        return numberOfRow
    }
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileSection = ProfileSection(rawValue: indexPath.row)
        switch profileSection {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileAvatarCell.self), for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }*/
    
    
    
    
}
