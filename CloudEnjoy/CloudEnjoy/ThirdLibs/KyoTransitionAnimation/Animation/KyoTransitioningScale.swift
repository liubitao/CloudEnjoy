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

extension KyoTransitioningScale {
    
    struct Const {
        static let keyForTransform: String = "transform"
    }
    
}

// MARK: ------------------------- Propertys

class KyoTransitioningScale: KyoTransitioningAnimation {
    var transform: CATransform3D?
}

// MARK: ------------------------- Methods

extension KyoTransitioningScale {
    
    /** oc调用，配置transform */
    @objc func oc_transform(from: CGRect, to: CGRect) {
        self.transform = KyoTransitioningScale.transform(from: from, to: to)
    }
}

// MARK: ------------------------- Static Methods

extension KyoTransitioningScale {
    
    /** 通过两个rect转化为CATransform3D */
    @objc class func transform(from: CGRect, to: CGRect) -> CATransform3D {
        let position: CGPoint = CGPoint(x: to.midX - from.midX,
                                        y: to.midY - from.midY)
        let scale: CGPoint = CGPoint(x: to.width / from.width,
                                     y: to.height / from.height)
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DScale(transform, scale.x, scale.y, 1)
        transform = CATransform3DTranslate(transform, position.x / scale.x, position.y / scale.y, 1)
        return transform
    }
    
}

// MARK: ------------------------- UIViewControllerAnimatedTransitioning

extension KyoTransitioningScale {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(self.duartion)
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) ?? UIView()
        let from: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from) ?? UIView()
        
        let transform: CATransform3D = self.transform ?? CATransform3DIdentity
        
        switch self.operation {
        case .push:
            to.layer.transform = transform
            transitionContext.containerView.addSubview(to)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                to.layer.transform = CATransform3DIdentity
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .pop:
            transitionContext.containerView.insertSubview(to, belowSubview: from)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                from.layer.transform = transform
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        default: break
        }
    }
}
