//
//  PresentAnimation.swift
//  JY-VeX
//
//  Created by atom on 2017/4/29.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class SwipeDismissInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    weak private var presentedVC: SwipeTransitionViewController!
    fileprivate var interactionEnabled = false
    private var shouldComplete = false
    private var touchStartPoint: CGPoint!
    fileprivate var dismissStyle: TransitionDismissStyle = .down
    
    convenience init(presentedVC  : SwipeTransitionViewController) {
        self.init()
        self.presentedVC = presentedVC
        dismissStyle = presentedVC.dismissStyle
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        presentedVC.view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            interactionEnabled = true
            presentedVC.dismiss(animated: true, completion: nil)
        case .changed:
            if let gestureView = gestureRecognizer.view {
                let translation = gestureRecognizer.translation(in: gestureView.superview)
                if let superView = gestureView.superview {
                    let superViewBounds = superView.bounds
                    var fraction: CGFloat = 0
                    switch dismissStyle {
                    case .down:
                        fraction = translation.y / superViewBounds.height
                    case .right:
                        fraction = translation.x / superViewBounds.height
                    default:
                        break
                    }
                    shouldComplete = (fraction > 0.25)
                    update(fraction)
                }
            }
        case .ended, .cancelled:
            interactionEnabled = false
            if !shouldComplete || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
        default:
            break
        }
    }
}

enum TransitionPresentStyle: Int {
    case vertical
    case horizental
}

class BouncePressentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let presentDuration = 0.6
    fileprivate var presentStyle: TransitionPresentStyle = .vertical
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return presentDuration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            let containerView = transitionContext.containerView
            let finalFrame = transitionContext.finalFrame(for: toVC)
            switch presentStyle {
            case .vertical:
                toVC.view.frame = finalFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
            case .horizental:
                toVC.view.frame = finalFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
            }
            containerView.addSubview(toVC.view)
            UIView.animate(withDuration: presentDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                fromVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                fromVC.view.alpha = 0.3
                toVC.view.frame = finalFrame
            }, completion: {(_) in
                fromVC.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
enum TransitionDismissStyle: Int {
    case down
    case right
    case none
}

class SwipeDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let dismissDuration = 0.45
    fileprivate var dismissStyle: TransitionDismissStyle = .down
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            let containerView = transitionContext.containerView
            let intialFrame = transitionContext.initialFrame(for: fromVC)
            var finalFrame: CGRect = .zero
            switch dismissStyle {
            case .down:
                finalFrame = intialFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
            case .right:
                finalFrame = intialFrame.offsetBy(dx: containerView.bounds.width, dy: 0)
            default:
                break
            }
            toVC.view.frame = intialFrame
            containerView.addSubview(toVC.view)
            containerView.sendSubview(toBack: toVC.view)
            toVC.view.alpha = 0.3
            toVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            let animations: (Void) -> Void = {
                fromVC.view.frame = finalFrame
                toVC.view.alpha = 1.0
                toVC.view.transform = CGAffineTransform.identity
            }
            
            let completion: (Bool) -> Void = { _ in
                if transitionContext.transitionWasCancelled {
                    toVC.view.transform = CGAffineTransform.identity
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            UIView.animate(withDuration: dismissDuration, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
        }
    }

    
}

class SwipeTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let presentTransition = BouncePressentTransition()
    private var dismissTransition: SwipeDismissTransition!
    private var swipeDismissInteractiveTransition: SwipeDismissInteractiveTransition!
    var presentStyle: TransitionPresentStyle = .vertical
    var dismissStyle: TransitionDismissStyle = .down
    var programaticScrollEnable = true
    override func viewDidLoad() {
        super.viewDidLoad()
        switch dismissStyle {
        case .down, .right:
            dismissTransition = SwipeDismissTransition()
            swipeDismissInteractiveTransition = SwipeDismissInteractiveTransition()
        default:
            break
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition.presentStyle = presentStyle
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissTransition.dismissStyle = dismissStyle
        return dismissTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        swipeDismissInteractiveTransition.dismissStyle = dismissStyle
        return swipeDismissInteractiveTransition.interactionEnabled ? swipeDismissInteractiveTransition : nil
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        switch dismissStyle {
        case .down:
            programaticScrollEnable = scrollView.contentOffset.y <= 0
        case .right:
            programaticScrollEnable = scrollView.contentOffset.x <= 0
        default:
            programaticScrollEnable = false
        }
    }
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        switch dismissStyle {
        case .down:
            programaticScrollEnable = scrollView.contentOffset.y <= 0
        case .right:
            programaticScrollEnable = scrollView.contentOffset.x <= 0
        default:
            programaticScrollEnable = false
        }
    }
}
