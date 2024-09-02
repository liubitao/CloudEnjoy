//
//  KyoTransitioningDelegate.swift
//  test1
//
//  Created by Kyo on 2019/9/25.
//  Copyright © 2019 Kyo. All rights reserved.
//

import UIKit

// MARK: -------------------------
// MARK: Const/Enum/Struct

extension KyoTransitioning {
    
    /** 常量  */
    struct Const {
        /** 默认动画时间（没设置时间时使用） */
        static let defaultDuartion: Float = 0.4
        /** 默认开启pop手势 */
        static let defaultEnableInteractive: Bool = true
    }
    
}

@objc class KyoTransitioning: NSObject {
    
    // MARK: -------------------------
    // MARK: Propertys
    
    /** 动画控制的controller  */
    weak var controller: UIViewController?
    /** 操作类型 push或pop */
    var operation: KyoTransitioningAnimation.Operation?
    /**  动画类型 */
    var animationType: KyoTransitioningAnimation.AnimationType?
    /** 动画时间 需要默认时间则不传 */
    var duration: Float?
    /** 动画实例需要的参数 key对应属性名，value对应值 */
    var animatorParams: [String: Any]?
    /** 是否开启手势pop 默认开启 */
    var isEnableInteractive: Bool = Const.defaultEnableInteractive
    
    /** 动画实例 */
    @objc var transition: KyoTransitioningAnimation?
    /** 交互手势实例 */
    @objc var interactive: KyoTransitioningInteractive?
    
    // MARK: -------------------------
    // MARK: CycLife
    
    /** 初始化，传入动画需要的数据 */
    init(controller: UIViewController? = nil,
         operation: KyoTransitioningAnimation.Operation? = nil,
         animationType: KyoTransitioningAnimation.AnimationType? = nil,
         duration: Float? = nil,
         animatorParams: [String: Any]? = nil,
         isEnableInteractive: Bool? = true) {
        super.init()
        self.controller = controller
        self.operation = operation
        self.animationType = animationType
        self.duration = duration
        self.animatorParams = animatorParams
        self.isEnableInteractive = isEnableInteractive ?? Const.defaultEnableInteractive
        self.controller?.navigationController?.delegate = self
        
        self.transition = KyoTransitioningAnimation.generate(type: self.animationType,
                                                             operation: operation,
                                                             duration: self.duration ?? Const.defaultDuartion,
                                                             animatorParams: self.animatorParams)
        self.interactive = KyoTransitioningInteractive.generate(controller: self.controller,
                                                                type: self.animationType)
    }
    
    /** oc调用 初始化 */
    @objc convenience init(controller: UIViewController,
                           operation: Int,
                           animationType: Int,
                           duration: Float,
                           animatorParams: [String: Any]?,
                           isEnableInteractive: Bool) {
        self.init(controller: controller,
                  operation: KyoTransitioningAnimation.Operation(rawValue: operation),
                  animationType: KyoTransitioningAnimation.AnimationType(rawValue: animationType),
                  duration: duration,
                  animatorParams: animatorParams,
                  isEnableInteractive: isEnableInteractive)
    }
    
    deinit {
        if self.controller?.navigationController?.delegate?.isEqual(self) ?? false {
            self.controller?.navigationController?.delegate = nil
        }
    }
    
    // MARK: -------------------------
    // MARK: Events
    
    // MARK: -------------------------
    // MARK: Methods
    
}

extension KyoTransitioning: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard self.operation == operation else {
            return nil
        }
        return self.transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard self.isEnableInteractive == true,
            self.transition?.isEqual(animationController) ?? false,
            self.operation == .pop,
            self.interactive?.isInPopGesture() ?? false else {
            return nil
        }
        
        return self.interactive?.interactive
    }
    
}
