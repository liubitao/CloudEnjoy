//
//  HPActivityIndicator.swift
//  Hopex
//
//  Created by 胡烽 on 10/23/18.
//  Copyright © 2018 bcsys. All rights reserved.
//

import UIKit

@objc class HPActivityIndicator: UIView {
    open var logoSize: CGSize = CGSize(width: 20, height: 20) {
        didSet{
            logoImage.size = logoSize
        }
    }
    @objc open var progressColor: UIColor = UIColor.white {
        didSet{
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    @objc open var backProgressColor: UIColor = UIColor.white.withAlphaComponent(0.3) {
        didSet{
            backLayer.strokeColor = backProgressColor.cgColor
        }
    }
    @objc open var progress: CGFloat = 0 {
        didSet{
            progressLayer.strokeEnd = progress
        }
    }
    
    @objc open func startAnimate(){
        self.progressLayer.strokeStart = 0
        self.progressLayer.strokeEnd = 0
        startTimer()
    }
    @objc open func stopAnimate(){
        stopTimer()
    }
    
    @objc open var logoImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "hayloufun_logo"))
    private var backLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    private var timer: Timer?
    
    static var isHideWhenStoped: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    deinit {
        stopTimer()
    }
    private func startTimer(){
        if timer == nil {
            timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(progressStart), userInfo: nil, repeats: true)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    private func _init(){
        let cen = CGPoint(x: width / 2, y: height / 2)
        let radius = width / 2
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "hayloufun_logo")
        logo.frame = CGRect(center: cen, size: CGSize(width: 20, height: 20))
        self.addSubview(logo)
        self.logoImage = logo
        
        let backPath = UIBezierPath(arcCenter: cen, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        backLayer = CAShapeLayer()
        backLayer.fillColor = nil
        backLayer.strokeColor = self.backProgressColor.cgColor
        backLayer.path = backPath.cgPath
        var fr = self.bounds
        fr.size.width = 2
        backLayer.frame = fr
        self.layer.insertSublayer(backLayer, at: 0)
        
        let progressPath = UIBezierPath(arcCenter: cen, radius: radius, startAngle: -(CGFloat.pi / 2), endAngle: (CGFloat.pi * 3 / 2), clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.path = progressPath.cgPath
        progressLayer.frame = fr
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(progressLayer)
        
        startTimer()
    }
    
    @objc func progressStart(){
        if self.progressLayer.strokeEnd >= 1 && self.progressLayer.strokeStart <= 1 {
            self.progressLayer.strokeStart += 0.1
        } else if self.progressLayer.strokeStart == 0 {
            self.progressLayer.strokeEnd += 0.1
        }
        
        if self.progressLayer.strokeEnd == 0 {
            self.progressLayer.strokeStart = 0
        }
        
        if self.progressLayer.strokeStart == self.progressLayer.strokeEnd {
            self.progressLayer.strokeEnd = 0
        }
    }
}
