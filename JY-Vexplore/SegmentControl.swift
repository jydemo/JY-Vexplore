//
//  SegmentControl.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class SegmentControl: UIControl, UIGestureRecognizerDelegate {
    
    
    private let titleLabelsView = UIView()
    private let selectedTitleLabeslView = UIView()
    private var initialIndicatorViewFrame: CGRect?
    private var titleLabelsCount: Int { return titleLabelsView.subviews.count}
    private var titleLabels: [UILabel] { return titleLabelsView.subviews as! [UILabel]}
    private var selectedtitleLabels: [UILabel] { return selectedTitleLabeslView.subviews as! [UILabel]}
    private var allTitleLabels: [UILabel] { return titleLabels + selectedtitleLabels}
    private let indicatorViewInset: CGFloat = 2.0
    private var totalInsetSize: CGFloat { return indicatorViewInset * 2.0}
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private(set) var selectedIndex = 0
    
    private class IndicationView: UIView {
        private var cornerRadius: CGFloat! {
            didSet {
                layer.cornerRadius = cornerRadius
                titleMaskView.layer.cornerRadius = cornerRadius
            }
        }
        
        fileprivate let titleMaskView = UIView()
        override var frame: CGRect {
            didSet {
                titleMaskView.frame = frame
            }
        }
        init() {
            super.init(frame: CGRect.zero)
            layer.masksToBounds = true
            titleMaskView.backgroundColor = .black
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    private lazy var indicatorView: IndicationView = {
        let view = IndicationView()
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
        view.backgroundColor = .highlight
        return view
    }()
    
    private var titles: [String] {
        get {
            let titleLabels = titleLabelsView.subviews as! [UILabel]
            return titleLabels.map { $0.text!}
        }
        set {
            guard newValue.count > 1 else {
                return
            }
            
            let labels: [(UILabel, UILabel)] = newValue.map { (string) -> (UILabel, UILabel) in
                let titleLabel = UILabel()
                titleLabel.textColor = .desc
                titleLabel.text = string
                titleLabel.lineBreakMode = .byTruncatingTail
                titleLabel.textAlignment = .center
                titleLabel.font = R.Font.StaticMedium
                
                let selectedtitleLabel = UILabel()
                selectedtitleLabel.textColor = .background
                selectedtitleLabel.text = string
                selectedtitleLabel.lineBreakMode = .byTruncatingTail
                selectedtitleLabel.textAlignment = .center
                selectedtitleLabel.font = R.Font.StaticMedium
                return (titleLabel, selectedtitleLabel)
            }
            titleLabelsView.subviews.forEach({ $0.removeFromSuperview()})
            selectedTitleLabeslView.subviews.forEach({ $0.removeFromSuperview()})
            for (inacttiveLabel, activeLabel) in labels {
                titleLabelsView.addSubview(inacttiveLabel)
                selectedTitleLabeslView.addSubview(activeLabel)
            }
            setNeedsLayout()
        }
    }
    
    var indicatorOffset: CGFloat {
        set {
            var newFrame = indicatorView.frame
            newFrame.origin.x = newFrame.width * newValue + indicatorViewInset
            indicatorView.frame = newFrame
        }
        get {
            fatalError("You cannot read from this object.")
        }
    }
    
    init(titles: [String], selectedIndex: Int) {
        super.init(frame: .zero)
        self.selectedIndex = selectedIndex
        self.titles = titles
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 13.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.note.cgColor
        backgroundColor = .clear
        addSubview(titleLabelsView)
        addSubview(indicatorView)
        addSubview(selectedTitleLabeslView)
        selectedTitleLabeslView.layer.mask = indicatorView.titleMaskView.layer
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            return indicatorView.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        setSelectedIndex(nearesIndex(toPoint: location))
    }
    
    @objc private func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            initialIndicatorViewFrame = indicatorView.frame
        case .changed:
            var frame = initialIndicatorViewFrame!
            frame.origin.x += gestureRecognizer.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - indicatorViewInset - frame.width), indicatorViewInset)
            indicatorView.frame = frame
        case .ended, .failed, .cancelled:
            setSelectedIndex(nearesIndex(toPoint: indicatorView.center))
        default:
            break
        }
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard titleLabelsCount > 1 else {
            return
        }
        
        titleLabelsView.frame = bounds
        selectedTitleLabeslView.frame = bounds
       indicatorView.frame = elementFrame(forindex: selectedIndex)
        for index in 0..<titleLabelsCount {
            let frame = elementFrame(forindex: index)
            titleLabelsView.subviews[index].frame = frame
            selectedTitleLabeslView.subviews[index].frame = frame
        }
    }
    
    private func elementFrame(forindex index: Int) -> CGRect {
        let elementWidth = (bounds.width - totalInsetSize) / CGFloat(titleLabelsCount)
        return CGRect(x: CGFloat(index) * elementWidth + indicatorViewInset, y: indicatorViewInset, width: elementWidth, height: bounds.height - totalInsetSize)
    }
    
    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        let oldIndex = selectedIndex
        selectedIndex = index
        moveIndicator(to: index, animated: animated, shouldSendEvent: selectedIndex != oldIndex)
    }
    
    private func moveIndicator(to index: Int, animated: Bool, shouldSendEvent: Bool) {
        if shouldSendEvent {
            sendActions(for: .valueChanged)
        }
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: { 
                self.moveIndicatorView()
            }, completion: nil)
        } else {
            moveIndicatorView()
        }
    }
    
    private func moveIndicatorView() {
        self.indicatorView.frame = self.titleLabels[selectedIndex].frame
        self.layoutIfNeeded()
    }
    private func nearesIndex(toPoint point: CGPoint) -> Int {
        let distances = titleLabels.map { abs(point.x - $0.center.x )}
        return distances.index(of: distances.min()!)!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
