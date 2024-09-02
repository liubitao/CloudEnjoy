//
//  KyoTransitioning.swift
//  test1
//
//  Created by Kyo on 2019/9/26.
//  Copyright © 2019 Kyo. All rights reserved.
//

import UIKit

// MARK: ------------------------- Const/Struct/Enum/Typealias

extension KyoTransitioningAnimation {
    
    typealias Operation = UINavigationController.Operation
    
    /** 动画类型 */
    enum AnimationType: Int, CaseIterable {
        /** 从底部弹出 */
        case bottom = 0
        /** 从头部弹出 */
        case top = 1
        /** 从右边弹出 */
        case right = 2
        /** 从左边弹出 */
        case left = 3
        /** 渐显 */
        case alpha = 4
        /** 从指定frame到全屏frame */
        case scaleToFull = 5
    }
    
}

// MARK: ------------------------- Propertys

class KyoTransitioningAnimation: NSObject {
        
    /** 动画类型 */
    var type: AnimationType = .right
    /** 类标注的操作类型 */
    var operation: Operation = .push
    /** 动画时间 */
    var duartion: Float = 0.4
}

// MARK: ------------------------- Static Methods

extension KyoTransitioningAnimation {
    
    /** 返回指定动画类型指定操作的动画实例，如果动画类型或指定操作为nil，则返回nil */
    class func generate(type: AnimationType?, operation: Operation?, duration: Float, animatorParams: [String: Any]?) -> KyoTransitioningAnimation? {
        guard let operation = operation, let type = type else {
            return nil
        }
        
        var transition: KyoTransitioningAnimation?
        
        switch type {
        case .alpha:
            transition = KyoTransitioningAlpha()
        case .left, .right, .top, .bottom:
            transition = KyoTransitioningPosition()
        case .scaleToFull:
            transition = KyoTransitioningScale()
            (transition as! KyoTransitioningScale).transform = animatorParams?[KyoTransitioningScale.Const.keyForTransform] as? CATransform3D
        }
        
        transition?.operation = operation
        transition?.duartion = duration
        transition?.type = type
        return transition
    }
    
}

// MARK: ------------------------- UIViewControllerAnimatedTransitioning

extension KyoTransitioningAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
}
