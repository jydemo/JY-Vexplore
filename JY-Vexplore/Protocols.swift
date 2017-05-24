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
