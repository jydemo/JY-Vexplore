//
//  SquareLoadingView.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/15.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

enum LoadingStyle: Int {
    case top
    case bottom
}
protocol SquaresLoadingViewDelegate: class{
    func didTriggeredReloading()
}

class SquareLoadingView: UIView {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var  size: CGFloat! {
        didSet {
           contentViewSize.constant = size
        }
    }
    
    private let squareLengthSize = 3
    private let duration: Double = 0.8
    private let gapRate: CGFloat = 0.25
    private var style: LoadingStyle = .top
    private var squareSize: CGFloat!
    private var gapSize: CGFloat!
    private var motionDistance: CGFloat!
    private var contentViewSize: NSLayoutConstraint!
    private var squares = [CALayer]()
    private var squaresOffsetX = [CGFloat]()
    private var squareOffsetY = [CGFloat]()
    private var  squareOpacity = [Float]()
    private(set) var isLoading = false
    private(set) var isFailed = false
    weak var delegate: SquaresLoadingViewDelegate?
    
    convenience init(loadingStyle: LoadingStyle) {
        self.init(frame: .zero)
        style = loadingStyle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        contentViewSize = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        addConstraint(contentViewSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        for _ in -1..<squareLengthSize * squareLengthSize {
            let square = CALayer()
            square.backgroundColor = UIColor.body.cgColor
            squares.append(square)
            contentView.layer.addSublayer(square)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(reloading))
        addGestureRecognizer(tap)
    }
    
    @objc private func reloading() {
        if isFailed {
            initSquarePosition()
            isFailed = false
            delegate?.didTriggeredReloading()
        }
    }
    
    func initSquarePosition() {
        iniSquaresNormalPosition()
        initSquares(withOffset: size)
    }
    
    func iniSquaresNormalPosition() {
        for square in squares {
            square.removeFromSuperlayer()
        }
        squares.removeAll()
        for _ in -1..<squareLengthSize * squareLengthSize {
            let square = CALayer()
            square.backgroundColor = UIColor.body.cgColor
            squares.append(square)
            contentView.layer.addSublayer(square)
        }
        isLoading = false
        size = min(frame.width, frame.height)
        size = size > 0 ? size : R.Constant.LoadingViewHeight
        
        squareSize = size / (CGFloat(squareLengthSize) + 2 + CGFloat(squareLengthSize + 1) * gapRate)
        gapSize = gapRate * squareSize
        motionDistance = squareSize + gapSize
        squaresOffsetX.removeAll()
        squareOffsetY.removeAll()
        squareOpacity.removeAll()
        
        for row in 0..<squareLengthSize {
            for colum in 0..<squareLengthSize {
                var offsetX: CGFloat!
                var offsetY: CGFloat!
                if row&1 == 1 {
                    offsetX = motionDistance + motionDistance * CGFloat(squareLengthSize - 1 - colum)
                } else {
                    offsetX = motionDistance + motionDistance * CGFloat(colum)
                }
                offsetY = motionDistance * CGFloat(row + 1)
                squaresOffsetX.append(offsetX)
                squareOffsetY.append(offsetY)
                let indexFloat = Float(squareLengthSize * row + colum + 1)
                squareOpacity.append(indexFloat / Float(squareLengthSize * squareLengthSize))
            }
        }
        
        for position in -1..<squareLengthSize {
            let square = squares[position + 1]
            square.isHidden = false
            square.setAffineTransform(.identity)
            if position == -1 {
                square.frame = CGRect(x: motionDistance, y: 0, width: squareSize, height: squareSize)
                square.opacity = 0
            } else {
                square.frame = CGRect(x: squaresOffsetX[position], y: squareOffsetY[position], width: CGFloat(squareSize), height: CGFloat(squareSize))
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func beginLoading() {
        if isLoading {
            return
        }
        for position in -1..<squareLengthSize * squareLengthSize {
            addSquareAnimation(positionIndex: position)
        }
        isLoading = true
    }
    
    func showLoadingView(withOffset offset: CGFloat) {
        let height = frame.height
        for row in 0..<squareLengthSize {
            for colum in 0..<squareLengthSize {
                let index = squareLengthSize * row + colum
                let square = squares[index + 1]
                let squareCount = squareLengthSize * squareLengthSize
                let startPoint = motionDistance + squareSize
                let startThreshold = CGFloat(squareCount - index - 1) / CGFloat(squareCount)
                let endThreshold = CGFloat(squareCount - index) / CGFloat(squareCount)
                let relativeOffset = (offset - startPoint) / (height - startPoint)
                if relativeOffset > startThreshold {
                    square.isHidden = false
                    if relativeOffset >= endThreshold {
                        square.setAffineTransform(.identity)
                    } else {
                        let realOffset = size * (endThreshold - relativeOffset) / (endThreshold - startThreshold)
                        if (row&1) == 0 {
                            square.setAffineTransform(CGAffineTransform(translationX: -realOffset, y: 0))
                        } else {
                            square.setAffineTransform(CGAffineTransform(translationX: realOffset, y: 0))
                        }
                    }
                } else {
                    square.isHidden = true
                }
            }
        }
    }
    
    func stopLoading(withSuccess success: Bool, completion: CompletionTask?) {
        for position in -1..<squareLengthSize * squareLengthSize {
            let square = squares[position + 1]
            square.removeAllAnimations()
            square.opacity = 0
            square.isHidden = true
        }
        
        var path = [Int]()
        var desiredPoints = [CGPoint]()
        let distance = motionDistance / sqrt(2.0)
        var centerSquare: CALayer!
        if success {
            centerSquare = squares[8]
            path = [2, 3, 5]
            desiredPoints = [CGPoint(x: centerSquare.position.x + 2 * distance, y: centerSquare.position.y - 2 * distance),
                CGPoint(x: centerSquare.position.x + distance, y: centerSquare.position.y - distance), CGPoint(x: centerSquare.position.x - distance, y: centerSquare.position.y - distance)]
        } else {
            centerSquare = squares[5]
            path = [0, 2, 6, 8]
            desiredPoints = [CGPoint(x: centerSquare.position.x - distance, y: centerSquare.position.y - distance),
                             CGPoint(x: centerSquare.position.x + distance, y: centerSquare.position.y - distance), CGPoint(x: centerSquare.position.x - distance, y: centerSquare.position.y + distance),
                             CGPoint(x: centerSquare.position.x + distance, y: centerSquare.position.y + distance)
            ]
        }
        centerSquare.opacity = 1
        centerSquare.isHidden = false
        centerSquare.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 4))
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setCompletionBlock { 
            self.isLoading = false
            self.isFailed = !success
            completion?(success)
        }
        
        for i in 0..<path.count {
            let square = squares[path[i] + 1]
            square.opacity = 1
            square.isHidden = false
            let desiredPoint = desiredPoints[i]
            var transform = CGAffineTransform(translationX: desiredPoint.x - square.position.x, y: desiredPoint.y - square.position.y)
            transform = transform.rotated(by: .pi / 4)
            square.setAffineTransform(transform)
        }
        CATransaction.commit()
    }
    
    private func initSquares(withOffset offset: CGFloat) {
        if style == .top {
            for row in 0..<squareLengthSize {
                for column in 0..<squareLengthSize {
                    let index = squareLengthSize * row + column
                    let square = squares[index + 1]
                    if (row&1) == 0 {
                        square.setAffineTransform(CGAffineTransform(translationX: -offset, y: 0))
                    } else {
                        square.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
                    }
                    square.isHidden = true
                }
            }
        }
    }
    
    private func addSquareAnimation(positionIndex position: Int) {
        let square = squares[position + 1]
        square.isHidden = false
        
        let squareCount = squareLengthSize * squareLengthSize
        let squareCountDouble = Double(squareCount)
        let keytimes = [0.0, 1.0 / squareCountDouble, (squareCountDouble - 1.0) / squareCountDouble, (squareCountDouble - 1.0) / squareCountDouble, 1.0]
        let startAlpha = (position ==  -1) ? 0.0 : squareOpacity[position]
        let endAlpha = (position == squareCount - 1) ? 0.0 : squareOpacity[position + 1]
        let alphas = [startAlpha, endAlpha, endAlpha, 0, 0]
        let isFirstOrLastSquare = (position == -1 || position == squareCount - 1)
        let tx: CGFloat = isFirstOrLastSquare ? 0.0 : squaresOffsetX[position + 1] - squaresOffsetX[position]
        let ty: CGFloat = isFirstOrLastSquare ? motionDistance : squareOffsetY[position + 1] - squareOffsetY[position]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: square.position.x, y: square.position.y))
        path.addLine(to: CGPoint(x: square.position.x + tx, y: square.position.y + ty))
        path.addLine(to: CGPoint(x: square.position.x + tx, y: square.position.y + ty))
        path.addLine(to: CGPoint(x: square.position.x + tx, y: square.position.y + ty))
        path.addLine(to: CGPoint(x: square.position.x + tx, y: square.position.y + ty))
        let positionAnimation: CAKeyframeAnimation = {
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.isRemovedOnCompletion = false
            animation.duration = duration
            animation.keyTimes = keytimes as [NSNumber]?
            animation.path = path
            return animation
        }()
        
        let alphaAnimation: CAKeyframeAnimation = {
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.isRemovedOnCompletion = false
            animation.duration = duration
            animation.keyTimes = keytimes as [NSNumber]?
            animation.values = alphas
            return animation
        }()
        
        let motionTime = duration / squareCountDouble
        let beginTime = motionTime * (squareCountDouble - 1.0 - Double(position))
        let groupAnimation: CAAnimationGroup = {
            let animation = CAAnimationGroup()
            animation.animations = [positionAnimation, alphaAnimation]
            animation.beginTime = CACurrentMediaTime() + beginTime
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            animation.duration = duration
            return animation
        }()
        
        square.add(groupAnimation, forKey: nil)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
