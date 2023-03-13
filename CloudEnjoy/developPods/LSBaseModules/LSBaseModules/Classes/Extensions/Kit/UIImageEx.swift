import UIKit
////  UIImageEx.swift
//  Haylou_Fun
//
//

extension UIImage {
    /**< 创建渐变色图片 */
    public class func createGradientImage(startColor:UIColor, endColor:UIColor, width: CGFloat, height: CGFloat, isTopToBottom: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGColor] = [startColor.cgColor,
                                 endColor.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let startPoint: CGPoint = isTopToBottom ? CGPoint(x: 0, y: 0) : CGPoint(x: 0, y: height / 2.0)
        let endPoint: CGPoint = isTopToBottom ? CGPoint(x: width, y: height) : CGPoint(x: width, y: height / 2.0)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
