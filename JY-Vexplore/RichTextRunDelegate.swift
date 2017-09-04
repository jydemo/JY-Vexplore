//
//  RichTextRunDelegate.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

class RichTextRunDelegate {
    var ascent: CGFloat = 0.0
    var descent: CGFloat = 0.0
    var width: CGFloat = 0.0
    var ctrunDelegate: CTRunDelegate? {
        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateCurrentVersion, dealloc: { (refcon) -> Void in }, getAscent: { (refCon) -> CGFloat in
            let ref = unsafeBitCast(refCon, to: RichTextRunDelegate.self)
            return ref.ascent
        }, getDescent: { (refCon) -> CGFloat in
            let ref = unsafeBitCast(refCon, to: RichTextRunDelegate.self)
            return ref.descent
        }, getWidth: { (refCon) -> CGFloat in
            let ref = unsafeBitCast(refCon, to:  RichTextRunDelegate.self)
            return ref.width
        })
        let selfPtr = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        return CTRunDelegateCreate(&callbacks, selfPtr)
    }
}
