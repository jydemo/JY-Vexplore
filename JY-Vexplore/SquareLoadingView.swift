//
//  SquareLoadingView.swift
//  JY-Vexplore
//
//  Created by atom on 2017/5/15.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum LoadingStyle: Int {
    case top
    case bottom
}
//加载视图的代理
protocol SquaresLoadingViewDelegate: class{
    func didTriggeredReloading()
}

class SquareLoadingView: UIView {
    //内容视图
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        //取消自动布局，使用代码布局
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate var  size: CGFloat! {
        didSet {
           contentViewSize.constant = size
        }
    }
    ///常数3
    fileprivate let squareLengthSize = 3
    fileprivate let duration: Double = 0.8
    ///比例常数为0.25
    fileprivate let gapRate: CGFloat = 0.25
    fileprivate var style: LoadingStyle = .top
    fileprivate var squareSize: CGFloat!
    fileprivate var gapSize: CGFloat!
    fileprivate var motionDistance: CGFloat!
    fileprivate var contentViewSize: NSLayoutConstraint!
    ///添加到视图上的图层数组
    fileprivate var squares = [CALayer]()
    ///OffsetX数组
    fileprivate var squaresOffsetX = [CGFloat]()
    ///OffsetY数组
    fileprivate var squareOffsetY = [CGFloat]()
    ///Opacity透明数组
    fileprivate var  squareOpacity = [Float]()
    fileprivate(set) var isLoading = false
    fileprivate(set) var isFailed = false
    weak var delegate: SquaresLoadingViewDelegate?
    //
    convenience init(loadingStyle: LoadingStyle) {
        self.init(frame: .zero)
        //设置加载方式
        style = loadingStyle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加子视图
        addSubview(contentView)
        //内容视图放在父视图中心
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //内容视图高宽一致
        contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        contentViewSize = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        addConstraint(contentViewSize)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    fileprivate func commonInit() {
        for _ in -1..<squareLengthSize * squareLengthSize {
            //新建图层
            let square = CALayer()
            //图层背景色
            square.backgroundColor = UIColor.body.cgColor
            //加入图层数组
            squares.append(square)
            //作为子图层添加到内容视图图层
            contentView.layer.addSublayer(square)
        }
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(reloading))
        addGestureRecognizer(tap)
    }
    // MARK: - 重新加载刷新视图
    @objc fileprivate func reloading() {
        //刷新失败
        if isFailed {
            //重新定位
            initSquarePosition()
        //刷新成功
            isFailed = false
            //代理实现委托方法
            delegate?.didTriggeredReloading()
        }
    }
    // MARK: - 重新定位
    ///重新定位
    func initSquarePosition() {
        iniSquaresNormalPosition()
        initSquares(withOffset: size)
    }
    // MARK: - 基本位置
    ///基本位置
    func iniSquaresNormalPosition() {
        //取出图层数组中的图层
        for square in squares {
            //从视图中删除
            square.removeFromSuperlayer()
        }
        //清空数组
        squares.removeAll()
        for _ in -1..<squareLengthSize * squareLengthSize {
            //新建图层 设置颜色 添加到数组和视图
            let square = CALayer()
            square.backgroundColor = UIColor.body.cgColor
            squares.append(square)
            contentView.layer.addSublayer(square)
        }
        //没加载
        isLoading = false
        //size为视图的宽高的最小值
        size = min(frame.width, frame.height)
        //根据size大小 决定最终的size
        size = size > 0 ? size : R.Constant.LoadingViewHeight
        //根据size计算出squareSize的值
        squareSize = size / (CGFloat(squareLengthSize) + 2 + CGFloat(squareLengthSize + 1) * gapRate)
        //squareSize 乘上比例
        gapSize = gapRate * squareSize
        //squareSize 加上比例
        motionDistance = squareSize + gapSize
        //清空数组
        squaresOffsetX.removeAll()
        squareOffsetY.removeAll()
        squareOpacity.removeAll()
        //
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
        
        for position in -1..<squareLengthSize * squareLengthSize {
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
            let squaare = squares[position + 1]
            squaare.removeAllAnimations()
            squaare.opacity = 0
            squaare.isHidden = true
        }
        
        var path = [Int]()
        var desiredPoints = [CGPoint]()
        let distance: CGFloat = 3.0 //motionDistance / sqrt(2.0)
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
    
    fileprivate func initSquares(withOffset offset: CGFloat) {
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
    
    fileprivate func addSquareAnimation(positionIndex position: Int) {
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
