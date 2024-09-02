//
//  KyoTransitioningPosition.swift
//  test1
//
//  Created by Kyo on 2019/9/26.
//  Copyright © 2019 Kyo. All rights reserved.
//

import UIKit

// MARK: -------------------------
// MARK: Const/Enum/Struct

class KyoTransitioningPosition: KyoTransitioningAnimation {}

// MARK: ------------------------- Methods

extension KyoTransitioningPosition {
    
    /** 设置动画前位置坐标 */
    private func setViewOriginalPosition(view: UIView, type: AnimationType) {
        switch type {
        case .bottom:
            view.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height + view.bounds.height / 2.0)
        case .top:
            view.center = CGPoint(x: view.center.x, y: -view.bounds.height / 2.0)
        case .right:
            view.center = CGPoint(x: UIScreen.main.bounds.width + view.bounds.width / 2.0, y: view.center.y)
        case .left:
            view.center = CGPoint(x: -view.bounds.width / 2.0, y: view.center.y)
        default: break
        }
    }
    
    /** 设置动画后位置坐标 */
    private func setViewAfterPosition(view: UIView, type: AnimationType, center: CGPoint) {
        switch type {
        case .bottom:
            view.center = CGPoint(x: center.x, y: UIScreen.main.bounds.height - center.y)
        case .top:
            view.center = CGPoint(x: center.x, y: center.y)
        case .right:
            view.center = CGPoint(x: center.x, y: center.y)
        case .left:
            view.center = CGPoint(x: UIScreen.main.bounds.width - center.x, y: center.y)
        default: break
        }
    }
}

// MARK: ------------------------- UIViewControllerAnimatedTransitioning

extension KyoTransitioningPosition {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(self.duartion)
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) ?? UIView()
        let from: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from) ?? UIView()
        
        switch self.operation {
        case .push:
            let center: CGPoint = to.center
            self.setViewOriginalPosition(view: to, type: self.type)
            transitionContext.containerView.addSubview(to)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.setViewAfterPosition(view: to, type: self.type, center: center)
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .pop:
            transitionContext.containerView.insertSubview(to, belowSubview: from)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.setViewOriginalPosition(view: from, type: self.type)
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        default: break
        }
    }
}
