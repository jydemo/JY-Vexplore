//
//  Utils.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

func pageCacheDirPath() -> String? {
    if let sysCacheDirPAth = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
        let pageCacheDirPath = (sysCacheDirPAth as NSString).appendingPathComponent("pagesData")
        var isDir: ObjCBool = false
        let fileManager = FileManager.default
        var dirExists = fileManager.fileExists(atPath: pageCacheDirPath, isDirectory: &isDir)
        do {
            if dirExists == true && isDir.boolValue == false {
                try fileManager.removeItem(atPath: pageCacheDirPath)
                dirExists = false
            }
            if dirExists == false {
                try fileManager.createDirectory(atPath: pageCacheDirPath, withIntermediateDirectories: false, attributes: nil)
            }
            return pageCacheDirPath
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return nil
        }
    }
    return nil
}

func cachePathString(withfilename filename: String) -> String? {
    var filePath: String?
    if let dirPath = pageCacheDirPath() {
        filePath = (dirPath as NSString).appendingPathComponent(filename)
    }
    return filePath
}
