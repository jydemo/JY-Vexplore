//
//  AvatarImageView.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {
    fileprivate var imageDownloadID: ImageDownload?
    
    func avatarImage(withURL url: URL) {
        /*setImage(withURL: url, placeholerImage: R.Image.AvatarPlaceholder, imageProcessing: { (image) -> UIImage in
            return image.roundCornerImage()
        })*/
    }
    
    func cancelImageDownloadTaskIfNeed() {
        guard let _ = imageDownloadID else {
            return
        }
        //ImageDownload
        
        self.imageDownloadID = nil
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /*private func setImage(withURL url: URL, placeholerImage: UIImage?, imageProcessing: ((_ image: UIImage) -> UIImage)?) {
        image = placeholerImage
        //ImageCache.default
        return image
    }*/
    
    
    
    
    
    
    

}
