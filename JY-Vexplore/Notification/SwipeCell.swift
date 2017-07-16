//
//  SwipeCell.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/7/16.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class SwipeCell: UITableViewCell {
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        pangesture.delegate = self
        return pangesture
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapgestur = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapgestur.delegate = self
        return tapgestur
    }()
    
    var enableSwipe = true {
        didSet {
            panGestureRecognizer.isEnabled = enableSwipe
            tapGestureRecognizer.isEnabled = enableSwipe
        }
    }
    
    private var isStickState = false
    private var snapshot: UIView!
    private var originalcontentViewCenter: CGPoint!
    private var btnIcons = [UIView]()
    private var buttons = [UIView]()
    private lazy var btnwidth: CGFloat = self.widthForButton()
    var isDirty = false
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        contentView.backgroundColor = .white
        backgroundColor = UIColor.offWhite
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func widthForButton() -> CGFloat {
        return 50.0
    }
    
    @objc private func pan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if isDirty {
                originalcontentViewCenter = snapshot.center
            } else {
                isDirty = true
                buildUI()
                originalcontentViewCenter = contentView.center
            }
        case .cancelled:
            guard isDirty, isUserInteractionEnabled else {
                return
            }
            let translation = sender.translation(in: sender.view)
            let offsetX = min(originalcontentViewCenter.x + translation
            .x, contentView.center.x)
            snapshot.center = CGPoint(x: offsetX, y: originalcontentViewCenter.y)
            let count = numberOfButtons()
            for i in 0..<count {
                let icon = btnIcons[i]
                let scale = min(max(contentView.center.x - offsetX - btnwidth * CGFloat(i), 0) / btnwidth, 1.0)
                icon.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        default:
            if isStickState || snapshot.center.x > contentView.center.x - btnwidth * 0.5 {
                cancelCellDragging()
            } else {
                stickSnapshotView()
            }
        }
    }
    @objc private func tap() {
        
    }
    func numberOfButtons() -> Int {
        return 1
    }
    
    private func buildUI() {
        snapshot = contentView.snapshotView(afterScreenUpdates: true)
        snapshot.frame = contentView.frame
        contentView.isHidden = true
        insertSubview(snapshot, aboveSubview: contentView)
        let count = numberOfButtons()
        guard count > 0 else {
            return
        }
        for i in 0..<count {
            let button: UIButton = {
                let btn = UIButton(type: .custom)
                btn.tag = i
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.addTarget(self, action: #selector(didTappedButton(button:)), for: UIControlEvents.touchUpInside)
                return btn
            }()
            let icon = iconViewForButton(atIndex: i)
            icon.translatesAutoresizingMaskIntoConstraints = false
            btnIcons.append(icon)
            button.addSubview(icon)
            icon.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            buttons.append(button)
            addSubview(button)
            var previousView: UIView!
            if i == 0 {
                previousView = snapshot
            } else {
                previousView = buttons[i - 1]
            }
            button.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: btnwidth).isActive = true
        }
    }
    
    @objc  private func didTappedButton(button: UIButton) {
        let index = button.tag
        didTappedButton(atIndex: index)
    }
    private func removeallBtns() {
        for btn in buttons {
            btn.removeFromSuperview()
        }
        btnIcons.removeAll()
        buttons.removeAll()
    }
    private func minimizeBtnIcons() {
        for icon in btnIcons {
            icon.transform = CGAffineTransform(scaleX: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
        }
    }
    private func normalizeBtnIcons() {
        for icon in btnIcons {
            icon.transform = .identity
        }
    }
    private func stickSnapshotView() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.snapshot.center = CGPoint(x: self.contentView.center.x - self.btnwidth * CGFloat(self.numberOfButtons()), y: self.contentView.center.y)
            self.normalizeBtnIcons()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.isStickState = true
        }
    }
    
    func cancelCellDragging() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.snapshot.center = self.contentView.center
            self.minimizeBtnIcons()
            self.layoutIfNeeded()
        }) { (_) in
            self.contentView.isHidden = false
            self.snapshot.removeFromSuperview()
            self.removeallBtns()
            self.isStickState = false
            self.isDirty = false
            self.isUserInteractionEnabled = true
        }
    }
    func reset() {
        guard isDirty else {
            return
        }
        cancelCellDragging()
    }
    
    
    func didTappedButton(atIndex index: Int) {
        
    }
    
    func iconViewForButton(atIndex index: Int) -> UIView {
        return UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
