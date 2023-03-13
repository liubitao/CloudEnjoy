//
//  KyoCenterRefresh.swift
//  LiYu
//
//  Created by Kyo on 2019/5/30.
//  Copyright © 2019 liyu. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

@objc open class KyoCenterRefreshControl: UIView, KyoCenterRefreshProtocol {
    
    public required init(scrollView: UIScrollView!, delegate: KyoCenterRefreshDelegate!) {
        super.init(frame: scrollView.frame)
        self.scrollView = scrollView
        self.delegate = delegate
        self.setupDefault()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefault()
    }
    
    func setupDefault() {
        self.backgroundColor = UIColor.clear
        self.alpha = 0
        self.scrollView?.addSubview(self)
        self.animationView = self.createAnimationView()
    }
}

/**< 协议属性 */
@objc extension KyoCenterRefreshControl {
    
    private static let KYO_CENTER_REFRESH_SCROLL_VIEW_KEY: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "KYO_CENTER_REFRESH_SCROLL_VIEW_KEY".hashValue)
    weak public var scrollView: UIScrollView? {
        get {
            let container: KyoCenterWeakContainer? = objc_getAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_SCROLL_VIEW_KEY) as? KyoCenterWeakContainer
            return container?.object as? UIScrollView
        }
        set {
            let container = KyoCenterWeakContainer(object: newValue)
            objc_setAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_SCROLL_VIEW_KEY, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static let KYO_CENTER_REFRESH_DELEGATE_KEY: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "KYO_CENTER_REFRESH_DELEGATE_KEY".hashValue)
    weak public var delegate: KyoCenterRefreshDelegate? {
        get {
            let container: KyoCenterWeakContainer? = objc_getAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_DELEGATE_KEY) as? KyoCenterWeakContainer
            return container?.object as? KyoCenterRefreshDelegate
        }
        set {
            let container = KyoCenterWeakContainer(object: newValue)
            objc_setAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_DELEGATE_KEY, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static let KYO_CENTER_REFRESH_IS_LOADING_KEY: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "KYO_CENTER_REFRESH_IS_LOADING_KEY".hashValue)
    public var isLoading: Bool {
        get {
            let value: NSNumber? = objc_getAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_IS_LOADING_KEY) as? NSNumber
            return value?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_IS_LOADING_KEY, NSNumber(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var centerOffsetY: CGFloat {
        get { return self.layoutCenterY?.constant ?? 0 }
        set { self.layoutCenterY?.constant = newValue }
    }
}

/**< 协议方法 */
@objc extension KyoCenterRefreshControl {
    
    /**< 显示 */
    public func refreshOperation() {
        self.frame = self.superview?.bounds ?? .zero
        self.alpha = 1
        self.isLoading = true
        self.startAnimation()
        self.scrollView?.isScrollEnabled = false
        if self.delegate != nil && self.delegate!.responds(to: #selector(KyoCenterRefreshDelegate.refreshDidRefresh(refresh:))) {
            self.delegate!.refreshDidRefresh(refresh: self)
        }
    }
    
    /**< 隐藏 */
    public func refreshDidFinished() {
        self.alpha = 0
        self.isLoading = false
        self.stopAnimation()
        self.scrollView?.isScrollEnabled = true
    }
}

/**< 动画实现 */
extension KyoCenterRefreshControl {
    
    private static let KYO_CENTER_REFRESH_ANIMATION_VIEW_KEY: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "KYO_CENTER_REFRESH_ANIMATION_VIEW_KEY".hashValue)
    var animationView: KyoCircleLoadView? {
        get {
            var view = objc_getAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_ANIMATION_VIEW_KEY) as? KyoCircleLoadView
            if view == nil {
                view =  self.createAnimationView()
                self.animationView = view
            }
            return view
        }
        set {
            objc_setAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_ANIMATION_VIEW_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static let KYO_CENTER_REFRESH_LAYOUT_CENTER_Y_KEY: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "KYO_CENTER_REFRESH_LAYOUT_CENTER_Y_KEY".hashValue)
    var layoutCenterY: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_LAYOUT_CENTER_Y_KEY) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, KyoCenterRefreshControl.KYO_CENTER_REFRESH_LAYOUT_CENTER_Y_KEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func createAnimationView() -> KyoCircleLoadView {
        let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
        let view = KyoCircleLoadView(frame: rect)
        view.circleColor = Color(hexString: "#00AAB7");
        view.circleWidth = 2;
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24))  //宽
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)) //高
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))    //centerX
        self.layoutCenterY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(self.layoutCenterY!)    //centerY
        
        return view
    }
    
    private func startAnimation() {
        self.animationView?.showLoading()
    }
    
    private func stopAnimation() {
        self.animationView?.hideLoading()
    }
}

/**< weak容器，用于实现关联属性weak */
class KyoCenterWeakContainer {
    weak var object: Optional<AnyObject>
    
    required init(object: Optional<AnyObject>) {
        self.object = object
    }
}
