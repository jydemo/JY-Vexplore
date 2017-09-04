//
//  Protocols.swift
//  JY-VeX
//
//  Created by atom on 2017/5/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

protocol AvatarTappedDelegate: class {
    func avatarTapped(withUsername username: String)
}

protocol TopicCellDelegate: AvatarTappedDelegate{
    func nodeTapped(withNodeID nodeID: String, nodeName: String?)
}


protocol TopicDetailDelegate:  TopicCellDelegate {
    func favorieBtnTapped()
}

protocol SwipCellDelegate: class {
    func cellWillBeginSwipe(at indexPath: IndexPath)
    func cellShouldBeginSwipe() -> Bool
}

extension SwipCellDelegate {
    func cellShouldBeginSwipe() -> Bool{
        return true
    }
}

protocol NotificationCellDelegate: AvatarTappedDelegate,SwipCellDelegate {
    func deleteNotification(withID notificationID: String)
}

protocol CommentCellDelegate: AvatarTappedDelegate, SwipCellDelegate {
    func thankBtnTapped(withReplyID replyID: String, indexPath: IndexPath)
    func igonreBtnTapped(withReplyID replyID: String)
    func replyBtnTapped(withUsername username: String)
    func longPress(at  indexPath: IndexPath)
}




