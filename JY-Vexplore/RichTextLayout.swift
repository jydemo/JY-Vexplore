//
//  RichTextLayout.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/6.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class RichTextLayout {
    private(set) var text: NSAttributedString!
    //private(set) var lines = []
    private(set) var attachments = [UIImageView]()
    private(set) var attachmentRects = [CGRect]()
    private(set) var bounds: CGRect = .zero
    private(set) var hasHightlightText = false
    private(set) var needsDrawText = false
    private(set) var needsDrawAttachments = false
    
    init?(with size: CGSize, text: NSAttributedString) {
        guard size.width > 0, size.height > 0 else {
            return nil
        }
        self.text = text
        let rect = CGRect(x: 0, y: 0, width: size.width, height: min(size.height, 0x0FFFFFFF))
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        let cgPath = CGPath(rect: rect, transform: &transform)
        let frameSetter = CTFramesetterCreateWithAttributedString(text)
        let cfFrame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: text.length), cgPath, nil)
        let ctLines = CTFrameGetLines(cfFrame) as! [CTLine]
        var lineOrigins = [CGPoint](repeating: .zero, count: ctLines.count)
        CTFrameGetLineOrigins(cfFrame, CFRange(location: 0, length: 0), &lineOrigins)
        for i in 0..<ctLines.count {
            let ctLine = ctLines[i]
            let ctRuns = CTLineGetGlyphRuns(ctLine)
            guard CFArrayGetCount(ctRuns) > 0 else {
                continue
            }
            let ctLineOrigin = lineOrigins[i]
            let position = CGPoint(x: rect.origin.x + ctLineOrigin.x, y: rect.maxY - ctLineOrigin.y)
            //let line =
            bounds = bounds.union(.zero)
        }
        let visibleRange = NSRange(with: CTFrameGetVisibleStringRange(cfFrame))
        if visibleRange.length > 0 {
            needsDrawText = true
            text.enumerateAttributes(in: visibleRange, options: .longestEffectiveRangeNotRequired, using: { (attrs, range, stop) in
                if attrs[HighlightAttributedName] != nil {
                    hasHightlightText = true
                }
                if attrs[AttachmentAttributeName] != nil {
                    needsDrawAttachments = true
                }
            })
        }
    }
    
    func drawtext(in context: CGContext, size: CGSize, origin: CGPoint) {
        guard needsDrawText else {
            return
        }
        context.saveGState()
        context.translateBy(x: origin.x, y: origin.y)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        /*for line in lines {
            
        }*/
    }
    func drawAttachment(in targetView: UIView, origin: CGPoint) {
        guard needsDrawAttachments, attachments.count == attachmentRects.count else {
            return
        }
        for i in 0..<attachmentRects.count {
            let attachment = attachments[i]
            var rect = attachmentRects[i]
            rect = rect.pixelRound()
            rect.origin = CGPoint(x: rect.origin.x + origin.x, y: rect.origin.y + origin.y)
            attachment.frame = rect
            targetView.addSubview(attachment)
        }
    }
    
    func glyphIndex(for location: CGPoint) -> Int? {
        return 0
    }
    
    
    
    
    
    
    
    
}
