////  UIViewEx.swift
//  Haylou_Fun
//
//  Created by 胡烽 on 2021/11/27
//  Copyright © 2021 lieSheng. All rights reserved.
//

import UIKit

extension UIView{
    // MARK : 坐标尺寸
    public var ls_origin:CGPoint {
         get { frame.origin }
         set {
             var rect = frame
             rect.origin = newValue
             self.frame = rect
         }
     }
     
    public var ls_size:CGSize {
         get { frame.size }
         set {
             var rect = frame
             rect.size = newValue
             self.frame = rect
         }
     }
     
    public var ls_left:CGFloat {
         get { frame.origin.x }
         set {
             var rect = self.frame
             rect.origin.x = newValue
             self.frame = rect
         }
     }
     
    public var ls_top:CGFloat {
         get { frame.origin.y }
         set {
             var rect = frame
             rect.origin.y = newValue
             self.frame = rect
         }
     }
     
    public var ls_right:CGFloat {
         get { frame.origin.x + frame.size.width }
         set {
             var rect = frame
             rect.origin.x = newValue - frame.size.width
             frame = rect
         }
     }
     
    public var ls_bottom:CGFloat {
         get { frame.origin.y + frame.size.height }
         set {
             var rect = frame
             rect.origin.y = newValue - frame.size.height
             frame = rect
         }
     }
    
    public var ls_centerX: CGFloat {
        get { frame.center.x }
        set {
            self.center = CGPoint(x: newValue, y: ls_centerY)
        }
    }
    
    public var ls_centerY: CGFloat {
        get { frame.center.y }
        set {
            self.center = CGPoint(x: self.ls_centerX, y: newValue)
        }
    }
    
    public var ls_width: CGFloat {
        get { frame.size.width }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    
    public var ls_height: CGFloat {
        get { frame.size.height }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
}

class HPLineView: UIView {
    enum Direction {
        case top
        case left
        case bottom
        case right
    }
}

extension UIView {
    
    open func showSepline(in rect: CGRect, color: UIColor) {
        let sepRect = rect
        let sepLine = HPLineView()
        sepLine.isOpaque = false
        sepLine.frame = sepRect
        sepLine.backgroundColor = color
        
        if !self.subviews.contains(where: { (view) -> Bool in
            return view is HPLineView
        }) {
            self.insertSubview(sepLine, at: 0)
        }
    }

    
    open func addDashLine(in rect: CGRect, lineColor: UIColor, lineWidth: CGFloat = 0.5, spacing: CGFloat = 3){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = rect
        shapeLayer.position = rect.center
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: Double(spacing))]
        let path = CGMutablePath()
        
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    open func hideSepline(){
        self.subviews.forEach { (view) in
            if view is HPLineView {
                view.isHidden = true
                view.removeFromSuperview()
            }
        }
    }
    
    /// 给view添加圆角 利用shapelayer 画的 可设置部分圆角
    ///
    /// - Parameters:
    ///   - roundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft] 默认4过角都有圆角
    ///   - cornerRadii: 圆角大小
    public func addCorner(roundingCorners: UIRectCorner = [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGFloat) {
        let roundLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        roundLayer.path = path.cgPath
//        roundLayer.fillColor = backgroundColor?.cgColor
        self.layer.mask = roundLayer
    }
    
    
    public func addShadow(color: UIColor, opacity: Float = 1, radius: CGFloat = 3, offset: CGSize = .zero, type: UIViewShadowType = .common, shadowWidth: CGFloat, contentRect: CGRect? = nil) {
        
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
//        layer.mixedShadowColor = color
        layer.shadowColor = color.cgColor
        var rect = contentRect ?? bounds
        
        switch type {
            case .top:
                rect = CGRect(x: 0, y: -shadowWidth / 2, width: rect.width, height: shadowWidth)
            case .bottom:
                rect = CGRect(x: 0, y: height - shadowWidth / 2, width: rect.width, height: shadowWidth)
            case .left:
                rect = CGRect(x: -shadowWidth / 2, y: 0, width: shadowWidth, height: rect.height)
            case .right:
                rect = CGRect(x: width - shadowWidth / 2, y: 0, width: shadowWidth, height: rect.height)
            case .around:
                rect = CGRect(x: -shadowWidth / 2, y: -shadowWidth / 2, width: rect.width + shadowWidth, height: rect.height + shadowWidth)
            default:
            rect = CGRect(x:  -shadowWidth / 2, y: 2, width: rect.width + shadowWidth, height: rect.height + shadowWidth / 2)
        }
        let beierPath = UIBezierPath(rect: rect)
        self.layer.shadowPath = beierPath.cgPath
        
    }
    
    func asImage() -> UIImage{
        let render = UIGraphicsImageRenderer(bounds: bounds)
        return render.image { (context) in
            layer.render(in: context.cgContext)
        }
    }
    
    func generatePicture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.masksToBounds = true
        self.layer.mask = maskLayer
    }
    
    func rotate(){
        let animator = UIViewPropertyAnimator(duration: 5, curve: .linear) {
            [weak self] in
            guard let self = self else {return}
            
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        animator.addAnimations {
            [weak self] in
            guard let self = self else {return}
            self.transform = self.transform.rotated(by: .pi)
        }
        
        animator.addCompletion {[weak self] (_) in
            guard let self = self else {return}
            
            self.rotate()
        }
        
        animator.startAnimation()
    }
    
    func stopRotete(){
        self.layer.removeAllAnimations()
    }
}


public enum UIViewShadowType {
    case top
    case left
    case right
    case bottom
    case common
    case around
}


extension UIViewController{
    
    func customNavigationBack(_ backImg: String = "icon-return") {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon-return"), style: .plain, target: self, action: #selector(clickBack))
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func clickBack() {
        self.navigationController?.popViewController(animated: true)
        if self.navigationController?.viewControllers.count ?? 0 > 0 {
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = self.navigationController?.viewControllers.last
        }
    }
    
    func hiddenBackItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
}
