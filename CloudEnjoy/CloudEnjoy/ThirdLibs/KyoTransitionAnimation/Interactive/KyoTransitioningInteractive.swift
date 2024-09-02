//
//  KyoTransitioningInteractive.swift
//  test1
//
//  Created by Kyo on 2019/9/27.
//  Copyright © 2019 Kyo. All rights reserved.
//

import UIKit

// MARK: -------------------------
// MARK: Const/Enum/Struct

extension KyoTransitioningInteractive {
    
    /**< 常量 */
    struct Const {
        /** 小于这个时间都算快速滑动并执行侧滑 */
        static let defaultDuration: TimeInterval = 0.25
        //达到pop的临界百分比 50%
        static let defaultPercentage: CGFloat = 0.5
    }
    
}

class KyoTransitioningInteractive: NSObject {
 
    // MARK: ------------------------- Propertys
    
    /** 控制器 */
    weak var viewController: UIViewController?
    /** 动画类型 */
    var type: KyoTransitioningAnimation.AnimationType?
    /** 手势 */
    var gestureRecogniser: KyoTransitioningPanGestureRecognizer = KyoTransitioningPanGestureRecognizer()
    /** 交互实例 */
    var interactive: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    /** 滑动手势最小时长（小于等于这个值算作快速滑动，执行pop） */
    var duration: TimeInterval = Const.defaultDuration
    /** 达到pop的临界百分比（慢速滑动，滑动距离超出这个百分比说明达到pop状态） */
    var percentage: CGFloat = Const.defaultPercentage
    
    /** 手势开始的时间戳 */
    private var interval: TimeInterval = 0
    
    // MARK: ------------------------- CycLife
    
    deinit {
        if self.viewController?.view.gestureRecognizers?.contains(self.gestureRecogniser) ?? false {
            self.viewController?.view.removeGestureRecognizer(self.gestureRecogniser)
        }
    }
    
    override init() {
        super.init()

        self.interactive.completionCurve = .linear //使得手势关闭平滑（手指放开达到关闭临界点，自动关闭时平滑动画）
    }
}

// MARK: ------------------------- Methods

extension KyoTransitioningInteractive {
    
    /** 当前是否在处理pop手势交互中 */
    func isInPopGesture() -> Bool {
        return self.gestureRecogniser.state == .began || self.gestureRecogniser.state == .changed
    }
    
}

// MARK: ------------------------- Static Methods

extension KyoTransitioningInteractive {
    
    /** 返回交互手势实例，如果控制器或动画类型为nil，则返回nil */
    class func generate(controller: UIViewController?,
                        type: KyoTransitioningAnimation.AnimationType?,
                        duration: TimeInterval = Const.defaultDuration,
                        percentage: CGFloat = Const.defaultPercentage) -> KyoTransitioningInteractive? {
        guard let type = type else {
            return nil
        }
        
        let interactive: KyoTransitioningInteractive = KyoTransitioningInteractive()
        interactive.viewController = controller
        interactive.type = type
        interactive.duration = duration
        interactive.percentage = percentage
        interactive.gestureRecogniser.addTarget(interactive, action: #selector(popPanGestureRecognizer(_:)))
        interactive.viewController?.view.addGestureRecognizer(interactive.gestureRecogniser)
        return interactive
    }
    
}

// MARK: ------------------------- Gesture

extension KyoTransitioningInteractive {
    
    @objc func popPanGestureRecognizer(_ recognizer: KyoTransitioningPanGestureRecognizer) {
        var translation: CGPoint = recognizer.translation(in: recognizer.view)
        let transform: CATransform3D? = recognizer.view?.layer.transform
        translation = CGPoint(x: translation.x * (transform?.m11 ?? 1),
                              y: translation.y * (transform?.m22 ?? 1))
        var currentPercentage: CGFloat = 0
        let viewSize: CGSize = recognizer.view?.bounds.size ?? CGSize.zero
        switch self.type {
        case .right, .left:
            currentPercentage = max(translation.x / viewSize.width, 0)
        case .top, .bottom:
            currentPercentage = max(translation.y / viewSize.height, 0)
        case .scaleToFull, .alpha, .none:
            let hPercentage: CGFloat = max(translation.x / viewSize.width, 0)
            let vPercentage: CGFloat = max(translation.y / viewSize.height, 0)
            currentPercentage = max(hPercentage, vPercentage)
            print(hPercentage, vPercentage, currentPercentage, translation, viewSize)
        }
        
        switch recognizer.state {
        case .began:
            self.interval = Date().timeIntervalSince1970
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            self.interactive.update(currentPercentage)
        case .ended:
            if currentPercentage >= self.percentage ||
                NSDate().timeIntervalSince1970 - self.interval <= self.duration {
                self.interactive.finish()
            } else {
                self.interactive.cancel()
            }
        default:
            self.interactive.cancel()
        }
    }
    
}














class KyoTransitioningPanGestureRecognizer: UIPanGestureRecognizer {}
