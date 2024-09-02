//
//  KyoTransitioningAlpha.swift
//  test1
//
//  Created by Kyo on 2019/9/26.
//  Copyright © 2019 Kyo. All rights reserved.
//

import UIKit

// MARK: -------------------------
// MARK: Const/Enum/Struct

class KyoTransitioningAlpha: KyoTransitioningAnimation {}

// MARK: ------------------------- UIViewControllerAnimatedTransitioning

extension KyoTransitioningAlpha {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(self.duartion)
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) ?? UIView()
        let from: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from) ?? UIView()
        
        switch self.operation {
        case .push:
            to.alpha = 0
            transitionContext.containerView.addSubview(to)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                to.alpha = 1
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .pop:
            from.alpha = 1
            transitionContext.containerView.insertSubview(to, belowSubview: from)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                from.alpha = 0
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        default: break
        }
    }
}
