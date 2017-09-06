//
//  AvatarImageView.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {
    fileprivate var imageDownloadID: ImageDownloadId?
    
    func avatarImage(withURL url: URL) {
        setImage(withURL: url, placeholerImage: R.Image.AvatarPlaceholder, imageProcessing: { (image) -> UIImage in
            return image.roundCornerImage()
        })
    }
    
    func cancelImageDownloadTaskIfNeed() {
        guard let imageDownloadId = imageDownloadID else {
            return
        }
        ImageDownloader.default.cancelImageDownloadTask(for: imageDownloadId)
        self.imageDownloadID = nil
    }
    
    
    private func setImage(withURL url: URL, placeholerImage: UIImage?, imageProcessing: ((_ image: UIImage) -> UIImage)?) {
        image = placeholerImage
        ImageCache.default.retrieveImage(forKey: url.cacheKey) { (image) in
            if image != nil {
                dispatch_async_safely_to_main_queue {
                    self.image = image
                }
            } else {
                self.cancelImageDownloadTaskIfNeed()
                self.imageDownloadID = ImageDownloader.default.downloadImage(with: url, completionHandler: { (image, originalData, error) in
                    if let image = image, let roundedImage = imageProcessing?(image) {
                        ImageCache.default.cache(image: image, originalData: originalData, forKey: url.cacheKey)
                        dispatch_async_safely_to_main_queue {
                            self.image = roundedImage
                        }
                    }
                })!
            }
        }
    }
    
    
    
    
    
    
    

}
