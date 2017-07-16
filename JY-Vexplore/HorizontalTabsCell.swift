//
//  HorizontalTabsCell.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/17.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import NotificationCenter

protocol HorizontalTabsViewDelegate: class {
    func numbetOfTabs(in horizontalTabsView: HorizontalTabsView) -> Int
    func titleOfTabs(in horizontalTabsView: HorizontalTabsView, forIndex index: Int) -> String
    func horizontalTabsView(_ horizontalTabsView: HorizontalTabsView, didSelectItemAt index: Int)
}

class HorizontalTabsCell: UICollectionViewCell {
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: self.contentView.bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = R.Font.StaticMedium
        label.highlightedTextColor = .highlight
        return label
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .body
        view.isHidden = true
        return view
    }()
    fileprivate lazy var  leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        view.isHidden = true
        return view
    }()
    fileprivate lazy var rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        view.isHidden = true
        return view
    }()
    fileprivate var bottomLineWidth: NSLayoutConstraint!
    override var isSelected: Bool {
        didSet {
            label.isHighlighted = isSelected
            if isSelected {
                bottomLine.isHidden = false
                contentView.layoutIfNeeded()
                UIView.animate(withDuration: 0.25, animations: { 
                    self.contentView.backgroundColor = .background
                    self.bottomLineWidth.isActive = false
                    self.bottomLineWidth = self.bottomLine.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
                    self.bottomLineWidth.isActive = true
                    self.contentView.layoutIfNeeded()
                }, completion: { (_) in
                    self.leftLine.isHidden = false
                    self.rightLine.isHidden = false
                })
            } else {
                contentView.layoutIfNeeded()
                UIView.animate(withDuration: 0.25, animations: { 
                    self.contentView.backgroundColor = .subBackground
                    self.bottomLineWidth.isActive = false
                    self.bottomLineWidth = self.bottomLine.widthAnchor.constraint(equalToConstant: 0.0)
                    self.bottomLineWidth.isActive = true
                    self.contentView.layoutIfNeeded()
                }, completion: {(_) in
                    self.leftLine.isHidden = true
                    self.rightLine.isHidden = true
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(bottomLine)
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        let bindings = [
            "label": label,
            "bottomLine": bottomLine,
            "leftLine": leftLine,
            "rightLine": rightLine
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomLine(2)]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftLine(0.5)]", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftLine]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rightLine(0.5)]|", metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rightLine]|", metrics: nil, views: bindings))
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bottomLineWidth = bottomLine.widthAnchor.constraint(equalToConstant: 0.0)
        bottomLineWidth.isActive = true
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: Notification.Name.Setting.NightModeDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftLine.isHidden = true
        rightLine.isHidden = true
        bottomLine.isHidden = true
        contentView.backgroundColor = .subBackground
        label.isHighlighted = false
    }
    @objc private func refreshColorScheme() {
        label.textColor = .body
        label.highlightedTextColor = .highlight
        bottomLine.backgroundColor = .body
        leftLine.backgroundColor = .border
        rightLine.backgroundColor = .border
        contentView.backgroundColor = .subBackground
    }
}

class HorizontalTabsView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    fileprivate let cellwith: CGFloat = 66.0
    weak var tabsDelegate: HorizontalTabsViewDelegate?
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(HorizontalTabsCell.self, forCellWithReuseIdentifier: String(describing: HorizontalTabsCell.self))
        dataSource = self
        delegate = self
        allowsMultipleSelection = false
        refreshColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshColorScheme), name: NSNotification.Name.Setting.NightModeDidChange, object: nil)
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let leftInse = max((frame.width - contentSize.width) * 0.5, 0)
        var newContentInset = contentInset
        newContentInset.left = leftInse
        contentInset = newContentInset
    }
    @objc private func refreshColorScheme() {
        backgroundColor = .subBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabsDelegate?.numbetOfTabs(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HorizontalTabsCell.self), for: indexPath) as! HorizontalTabsCell
        cell.label.text = tabsDelegate?.titleOfTabs(in: self, forIndex: indexPath.row)
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems, selectedIndexPaths.count > 0 {
            cell.isSelected = (selectedIndexPaths[0].compare(indexPath) == .orderedSame)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellwith, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //tabsDelegate?.horizontalTabsView(self, dudSelectItemAt: indexPath.row)
        tabsDelegate?.horizontalTabsView(self, didSelectItemAt: indexPath.row)
    }
}
























