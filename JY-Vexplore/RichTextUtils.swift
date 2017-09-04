//
//  RichTextUtils.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/3.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation
let AttachmentAttributeName = "vexplore.textAttributeName.attachment"
let HighlightAttributedName = "vexplore.textAttributeName.highlight"
extension NSMutableAttributedString {
    class func attachmentString(with imageView: UIImageView, size: CGSize, alignTo font: UIFont) -> NSMutableAttributedString {
        let attrs = NSMutableAttributedString(string: " ")
        attrs.addAttribure(AttachmentAttributeName, value: imageView)
       let delegate = RichTextRunDelegate()
        delegate.width = size.width
        delegate.ascent = max(size.height + font.descender, 0)
        delegate.descent = size.height - delegate.ascent
        if let ctRunDelegate = delegate.ctrunDelegate {
            attrs.addAttribure(kCTRunDelegateAttributeName as String, value: ctRunDelegate)
        }
        return attrs
    }
    func setHighlightText(withcolor color: UIColor, url: String ) {
        addAttribure(NSForegroundColorAttributeName, value: color)
        addAttribure(HighlightAttributedName, value: url)
    }
    func set(lineSpacing: CGFloat) {
        let style = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.lineSpacing = lineSpacing
        addAttribure(NSParagraphStyleAttributeName, value: style)
    }
    func addAttribure(_ name: String, value: Any) {
        addAttribute(name, value: value, range: NSMakeRange(0, length))
    }
}
