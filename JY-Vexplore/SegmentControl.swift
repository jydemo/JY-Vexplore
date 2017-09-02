//
//  SegmentControl.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/1.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class SegmentControl: UIControl {
    
    fileprivate lazy var  indicatorView: IndicatorView = {
        let view = IndicatorView()
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.highlight
        return view
    }()
    
    private var titles: [String]{
        get {
           let titleLabels = titleLabelsView.subviews as! [UILabel]
            return titleLabels.map { $0.text! }
        }
        set {
            guard newValue.count > 1  else {
                return
            }
            let labels: [(UILabel, UILabel)] = newValue.map { (value) -> (UILabel, UILabel) in
                let titleLabel = UILabel()
                titleLabel.textColor = UIColor.desc
                titleLabel.text = value
                titleLabel.lineBreakMode = .byTruncatingTail
                titleLabel.textAlignment = .center
                titleLabel.font = R.Font.StaticMedium
                let selectedTitleLabel = UILabel()
                selectedTitleLabel.textColor = UIColor.background
                selectedTitleLabel.text = value
                selectedTitleLabel.lineBreakMode = .byTruncatingTail
                selectedTitleLabel.textAlignment = .center
                selectedTitleLabel.font = R.Font.StaticMedium
                return (titleLabel, selectedTitleLabel)
            }
            titleLabelsView.subviews.forEach { $0.removeFromSuperview() }
            selectedTitleLabelsview.subviews.forEach( { $0.removeFromSuperview() })
            for (inactiveLabel, activeLabel) in labels {
                titleLabelsView.addSubview(inactiveLabel)
                selectedTitleLabelsview.addSubview(activeLabel)
            }
            setNeedsLayout()
        }
    }
    
    var indicatorOffset: CGFloat {
        set {
            var newframe = indicatorView.frame
            newframe.origin.x = newframe.width * newValue + indicatorviewInset
            indicatorView.frame = newframe
        }
        get {
            fatalError("You cannot read from this object.")
        }
    }
    
    private let titleLabelsView = UIView()
    private let selectedTitleLabelsview = UIView()
    private var initialIndicatorViewFrame: CGRect?
    private var titleLabelsCount: Int { return titleLabelsView.subviews.count }
    private var titleLabels: [UILabel] { return titleLabelsView.subviews as! [UILabel] }
    private var selectedTitleLabels: [UILabel] { return selectedTitleLabelsview.subviews as! [UILabel]}
    private var alltitleLabels: [UILabel] { return titleLabels + selectedTitleLabels}
    private var indicatorviewInset: CGFloat = 2.0
    private var  totalInsetSize: CGFloat { return indicatorviewInset * 2.0}
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    private(set) var selectedIndex = 0
    init(titles: [String], selectedIndex: Int) {
        super.init(frame: .zero)
        self.selectedIndex = selectedIndex
        self.titles = titles
        setup()
    }
    private func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 13.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.note.cgColor
        backgroundColor = UIColor.clear
        addSubview(titleLabelsView)
        addSubview(indicatorView)
        addSubview(selectedTitleLabelsview)
        selectedTitleLabelsview.layer.mask = indicatorView.titleMaskView.layer
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    @objc private func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            initialIndicatorViewFrame = indicatorView.frame
        case .changed:
            var frame = initialIndicatorViewFrame!
            frame.origin.x += gestureRecognizer.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - indicatorviewInset - frame.width), indicatorviewInset)
            indicatorView.frame = frame
        case .ended, .failed, .cancelled: break
           setSelectedIndex(nearestIndex(toPoint: indicatorView.center))
        default:
            break
        }
    }
    @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        setSelectedIndex(nearestIndex(toPoint: location))
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard  titleLabelsCount > 1 else {
            return
        }
        titleLabelsView.frame = bounds
        selectedTitleLabelsview.frame = bounds
        indicatorView.frame = elementFrame(forIndex: selectedIndex)
        for index in 0..<titleLabelsCount {
            let frame = elementFrame(forIndex: index)
            titleLabelsView.subviews[index].frame = frame
            selectedTitleLabelsview.subviews[index].frame = frame
        }
    }
    
    func setSelectedIndex(_ index: Int, animated: Bool = true) {
        let oldIndex = selectedIndex
        selectedIndex = index
        moveIndicator(to: index, animated: animated, shouldSendEvent: selectedIndex != oldIndex)
    }
    
    private func elementFrame(forIndex index: Int) -> CGRect {
        let eleementWidth = (bounds.width - totalInsetSize) / CGFloat(titleLabelsCount)
        return CGRect(x: CGFloat(index) + eleementWidth + indicatorviewInset, y: indicatorviewInset, width: eleementWidth, height: bounds.height - totalInsetSize)
    }
    
    private func nearestIndex(toPoint point: CGPoint) -> Int {
        let distances = titleLabels.map { abs(point.x - $0.center.x)}
        return distances.index(of: distances.min()!)!
    }
    
    private func moveIndicatorView() {
        self.indicatorView.frame = self.titleLabels[selectedIndex].frame
        self.layoutIfNeeded()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
extension SegmentControl : UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            return indicatorView.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

private class IndicatorView: UIView {
    private var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
            titleMaskView.layer.cornerRadius = cornerRadius
        }
    }
    override var frame: CGRect {
        didSet {
            titleMaskView.frame = frame
        }
    }
    fileprivate let titleMaskView = UIView()
    init() {
        super.init(frame: .zero)
        layer.masksToBounds = true
        titleMaskView.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
