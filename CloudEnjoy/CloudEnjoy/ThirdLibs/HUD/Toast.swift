//
//  Toast.swift
//  HaylouBase
//
//  Created by fengke on 2021/4/9.
//

import UIKit
import LSNetwork
import LSBaseModules

extension MBProgressHUD {
    private struct AssociateKeys{
        static var hudType: Int = 0
    }
    /// 0为普通hud 1为progress
    public var hudType: Int {
        get{
            if let type = objc_getAssociatedObject(self, &AssociateKeys.hudType) as? Int {
                return type
            }
            return 0
        }
        set{
            objc_setAssociatedObject(self, &AssociateKeys.hudType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public class Toast: NSObject {
    enum ToastType {
        case text
        case progress
    }
    
    static let HUD: UIView = UIView(frame: UI.SCREEN_BOUNDS)
    
    static let hud = Toast()
    static let hudSuperView = UIView()
    private var mb: MBProgressHUD?
    
    public class func show(_ message: String?,duration:TimeInterval = 2.0) {
        show(with: nil, message: message)
    }
    
    public class func showHUD(_ message: String? = nil, isFullScreen: Bool = true){
        if hud.mb?.superview != nil {
            return
        }
        hud.mb?.removeFromSuperview()
        hud.mb = Toast._creatProgess(message, isFullScreen)
        hud.mb?.delegate = hud
    }
    
    public class func hiddenHUD(delay: TimeInterval = 0){
        hide(delay)
    }
}

extension Toast {
    static private func _creatHud(_ inView: UIView? = nil, isProgress: Bool = false ) -> MBProgressHUD{
        hudSuperView.frame = CGRect(x: 0, y: UI.STATUS_NAV_BAR_HEIGHT, width: UI.SCREEN_WIDTH, height: UI.SCREEN_HEIGHT - UI.STATUS_NAV_BAR_HEIGHT - 50 - UI.BOTTOM_HEIGHT)
        if hudSuperView.superview == nil && hudSuperView.superview != UIApplication.shared.keyWindow {
            UIApplication.shared.keyWindow?.addSubview(hudSuperView)
        }
        var view = inView
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        let mb = MBProgressHUD.showAdded(to: view!, animated: true)!
//        if !isProgress {
//            mb.minSize = CGSize(width: UI.SCREEN_WIDTH - 75, height: 100)
//        }
        mb.labelFont = UIFont(name: "PingFangSC-Regular", size: 14)
        mb.removeFromSuperViewOnHide = true
        mb.hudType = 0
        mb.tapHide = true
        return mb
    }
    
    /// 创建HUD 类型为Progress
    ///
    /// - Parameter message: 需要显示的message
    /// - Returns: 返回MBprogressHUD
    static private func _creatProgess(_ message: String? = nil, inView: UIView? = nil, _ shouldBottom: Bool = false) -> MBProgressHUD{
        let hHeight = UI.SCREEN_HEIGHT
        hudSuperView.frame = CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: hHeight)
        if hudSuperView.superview == nil && hudSuperView.superview != UIApplication.shared.keyWindow {
            UIApplication.shared.keyWindow?.addSubview(hudSuperView)
        }
        var spView = inView
        if spView == nil {
            spView = hudSuperView
        }
        
        let mb = MBProgressHUD.showAdded(to: spView!, animated: true)!
        mb.mode = .customView
        let view = UIView(frame: CGRect(center: CGPoint(x: spView!.width * 0.5, y: spView!.height * 0.5), size: CGSize(width: 78, height: 78)))
        view.backgroundColor = .clear
        let bgColor = UIColor.black.withAlphaComponent(0.7)
        view.backgroundColor = bgColor
        view.layer.cornerRadius = 5
//        view.backgroundImg = UIImage(color: UIColor.black.withAlphaComponent(0.7))?.byBlurLight()
//        view.view_cornerRadius = 2
//        let animateView = HPActivityIndicator(frame: CGRect(center: CGPoint(x: 39, y: 39), size: CGSize(width: 45, height: 45)))
        var animateView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        if #available(iOS 13.0, *) {
            animateView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
        }
        animateView.center = CGPoint(x: 39, y: 39)
        animateView.color = .white
        animateView.startAnimating()
        view.addSubview(animateView)
//        animateView.setNeedsLayout()
        
        if let message = message {
            let textLabel = UILabel()
            textLabel.textColor = mb.labelColor
            textLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            textLabel.text = message
            view.addSubview(textLabel)
            
            
            let textSize = NSString(string: message).boundingRect(with: CGSize(width: UI.SCREEN_WIDTH - 105, height: .greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont(name: "PingFangSC-Regular", size: 14)!], context: nil).size
            let viewHeight = 78 + textSize.height + 16.5
            let viewWidth = UI.SCREEN_WIDTH - 75
            view.frame = CGRect(x: 37.5, y: (spView!.height - viewHeight) / 2, width: viewWidth, height: viewHeight)
//            animateView.frame = CGRect(center: CGPoint(x: viewWidth / 2, y: 39), size: CGSize(width: 45, height: 45))
            animateView.center = CGPoint(x: viewWidth / 2, y: 39)
            textLabel.frame = CGRect(center: CGPoint(x: viewWidth / 2, y: animateView.ls_bottom + 16.5 + textSize.height / 2), size: textSize)
            animateView.setNeedsLayout()
        }
        
        mb.customView = view
        mb.color = .clear
        mb.hudType = 1
        mb.tapHide = false
        return mb
    }
    
    static func show(`with` icon: UIImage?, inView: UIView? = nil, title: String? = nil, message: String? = nil, delay: TimeInterval = 1.5) {

        hud.mb?.removeFromSuperview()
        hud.mb = Toast._creatHud(inView)
        
        if let img = icon {
            hud.mb?.mode = .customView
            hud.mb?.customView = UIImageView(image: img)
        } else {
            hud.mb?.mode = .text
        }
        
        if message == nil && title != nil {
            let tWidth = NSString(string: title!).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 16), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont(name: "PingFangSC-Regular", size: 14)!], context: nil).size.width
            if tWidth > UI.SCREEN_WIDTH - 100 {
                hud.mb?.detailsLabelText = title
            } else {
               hud.mb?.labelText = title
            }
        } else  {
            hud.mb?.detailsLabelText = message
            hud.mb?.labelText = title
        }
        
        hud.mb?.detailsLabelColor = UIColor.white
        hud.mb?.detailsLabelFont = UIFont(name: "PingFangSC-Regular", size: 14)
        hud.mb?.hide(true, afterDelay: delay)
        hud.mb?.delegate = hud
    }
    
    /// 隐藏HUD 可设置延时隐藏 当有新的HUD要显示的时候 会调用此方法隐藏之前的HUD
    ///
    /// - Parameter delay: 延迟几秒
    static func hide(_ delay: TimeInterval? = nil) {
        if delay == nil {
            if hud.mb?.hudType == 1 {
                hud.mb?.hide( true)
            }
        } else {
            if hud.mb?.hudType == 1 {
                hud.mb?.hide(true, afterDelay: delay!)
            }
        }
        hud.mb?.customView?.subviews.forEach({ (view) in
            if let act = view as? HPActivityIndicator {
                act.stopAnimate()
            }
        })
    }
}

extension Toast: MBProgressHUDDelegate {
    public func hudWasHidden(_ hud: MBProgressHUD!) {
        Toast.hudSuperView.removeFromSuperview()
    }
}
