////  StringEx.swift
//  Haylou_Fun
//
//  Created by 胡烽 on 2021/12/31
//  Copyright © 2021 lieSheng. All rights reserved.
//

import Foundation
import SwifterSwift

extension String {
    /// 获取小数点后几位
    func digt(_ def: Int = 0) -> Int{
        if !self.contains(".") {
            return 0
        }
        let coms = self.components(separatedBy: ".")
        return coms.last?.count ?? def
    }
    
    func toMoney(contain count: Int = 0) -> String{
        let v = doubleValue(retain: count)
        
        return NSNumber(value: v).formatterString(contain: count)
    }
    
    func doubleValue(retain count: Int) -> Double {
        return Double(self)?.roundTo(places: count) ?? 0
    }
    
    func float(retain count: Int) -> Float {
        return Double(self)?.roundTo(places: count).float ?? 0
    }
    
    var hexToData: Data {
        if self.isEmpty {
            return Data()
        }
        var data = Data(capacity: self.count / 2)
        let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex?.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        return data
    }

    
    func imageURL() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            LSPrintLog(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Swift.Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension NSNumber{
    func formatterString(contain count: Int = 0) -> String {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = count
        formatter.minimumFractionDigits = count
        return formatter.string(from: self)!
    }
}

extension String {
    var isValidateEmail:  Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    var isValidatePassword: Bool {
        let passwordRules = "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,16}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", passwordRules)
        return regexPassword.evaluate(with: self)
    }
    
    var isValidatePassword2: Bool {
        let passwordRules = "^(?:(?=.*[a-zA-Z])(?=.*[\\d])|(?=.*[!#+,.\\=:=@-])(?=.*[\\d])|(?=.*[!#+,.\\=:=@-])(?=.*[a-zA-Z])).+$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", passwordRules)
        return regexPassword.evaluate(with: self)
    }
    
    var isValidateMobile: Bool {
        let phoneRegex: String = "^(13|15|17|16|19|18|14)[0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    /// 将账号加密  手机: 134****4325  邮箱 123****@qq.com
    func securetAccount() -> String{
        if self.isValidateEmail {
            return self.securetEmail()
        }
        if self.isValidateMobile {
            return self.securetPhoneNum()
        }
        return self
    }
    
    /// 对手机加密 手机: 134****4325
    func securetPhoneNum() -> String{
        if !self.isValidateMobile {
            return self
        }
        let sec = self as NSString
        return sec.replacingCharacters(in: NSRange(location: 3, length: 4), with: "****")
    }
    
    /// 对邮箱加密 邮箱 123****@qq.com
    func securetEmail() -> String{
        if !self.isValidateEmail {
            return self
        }
        let coms = self.components(separatedBy: "@")
        guard coms.count >= 2 else {
            return self
        }
        var firstCom = ""
        if coms[0].count <= 3 {
            firstCom = coms[0] + "****"
        } else {
            firstCom = coms[0].subString(to: 2) + "****"
        }
        return firstCom + "@" + coms[1]
    }
    
    /// 获取从0到index的子字符串
    public func subString(to index: Int) -> String {
        if self.count > index {
            let startIndex = self.startIndex
            let endIndex = self.index(self.startIndex, offsetBy: index)
            return String(self[startIndex..<endIndex])
        }
        return self
    }
}

extension String {
    
    /// 设置文本高亮
    /// - Parameters:
    ///   - subStrings: 需要高亮的文本
    ///   - hilightColor: 高亮的文字颜色
    ///   - normalColor: 普通文字颜色
    /// - Returns: 返回富文本
    func setHight(of subStrings: [String], hilightColor: UIColor, normalColor: UIColor = .white, space: CGFloat = 5) -> NSAttributedString {
        let tempString = NSMutableAttributedString.init(string: self)
        let paraGraph = NSMutableParagraphStyle()
        paraGraph.lineSpacing = space
        paraGraph.alignment = .left
        let range = NSRange(location: 0, length: count )
        tempString.addAttributes([NSAttributedString.Key.paragraphStyle: paraGraph], range: range)
        // 设置普通文本颜色
        let normal = [NSAttributedString.Key.foregroundColor : normalColor]
        let nRange = (self as NSString).range(of: self)
        tempString.addAttributes(normal, range: nRange)
        for subString in subStrings {
            // 如果设置的高亮文本不在父文本中 返回原文本的富文本
            guard let _ = self.lowercased().range(of: subString.lowercased()) else {
                continue
            }
            // 设置文本高亮
            let att = [NSAttributedString.Key.foregroundColor : hilightColor]
            let nsRange = (self as NSString).range(of: subString)
            tempString.addAttributes(att, range: nsRange)
        }
        
        return tempString as NSAttributedString
    }
    
    /** 设置文字高亮
     * @param subString  文本中包含子文字
     * @param hilightColor 高亮文字颜色
     * @return 带子文字高亮的富文本 (如果文字中不包含子文字或子文字为nil，返回原文本的富文本)
     */
    func setHilight(`of` subString: String?, hilightColor: UIColor, normalColor: UIColor = .white, forLast: Bool = false, space: CGFloat = 5) -> NSAttributedString{
        let tempString = NSMutableAttributedString.init(string: self)
        let paraGraph = NSMutableParagraphStyle()
        paraGraph.lineSpacing = space
        paraGraph.alignment = .left
        let range = NSRange(location: 0, length: count )
        tempString.addAttributes([NSAttributedString.Key.paragraphStyle: paraGraph], range: range)
        // 如果传入的子文本为空 则返回原文本的富文本
        guard let subString = subString else {
            return tempString as NSAttributedString
        }
        
        // 如果设置的高亮文本不在父文本中 返回原文本的富文本
        guard let _ = self.lowercased().range(of: subString.lowercased()) else {
            return tempString as NSAttributedString
        }
        // 设置普通文本颜色
        let normal = [NSAttributedString.Key.foregroundColor : normalColor]
        let nRange = (self as NSString).range(of: self)
        tempString.addAttributes(normal, range: nRange)
        // 设置文本高亮
        let att = [NSAttributedString.Key.foregroundColor : hilightColor]
        if forLast {
            if let ranges = getAllRange(of: subString).last {
                tempString.addAttributes(att, range: ranges)
            }
        } else {
            let nsRange = (self as NSString).range(of: subString)
            tempString.addAttributes(att, range: nsRange)
        }
        return tempString as NSAttributedString
    }
    
    func getAllRange(of subString: String?) -> [NSRange] {
        var ranges = [NSRange]()
        guard let subString = subString else {
            return ranges
        }
        let nsSelf = self as NSString
        var range = nsSelf.range(of: subString)
        if range.location == NSNotFound {
            return ranges
        }
        
        var temp = nsSelf
        var location = 0
        while range.location != NSNotFound {
            if location == 0 {
                location += range.location
            } else {
                location += range.location + subString.count
            }
            
            let tmpRange = NSRange(location: location, length: subString.count)
            ranges.append(tmpRange)
            
            temp = temp.substring(from: range.location + range.length) as NSString
            range = temp.range(of: subString)
        }
        return ranges
    }
    
}

extension String {
    
    func textWidth(font: UIFont) -> CGFloat {
        let dict = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: Double.infinity,height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        return rect.size.width
        
    }
    
    /// 根据字符串的实际内容，在固定的宽度和字体的大小下，动态的计算出实际的高度
    func textHeight(textWidth: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGFloat {
        let dict = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: textWidth,height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        return rect.size.height
        
    }
    
    /// 根据字符串的实际内容，在固定的宽度和字体的大小下，动态的计算出实际的高度
    func textHeightFromTextString(textWidth: CGFloat, fontSize: CGFloat = 14.0, isBold: Bool = false) -> CGFloat {
        
        var dict: NSDictionary = NSDictionary()
        if (isBold) {
            dict = NSDictionary(object: UIFont.boldSystemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        } else {
            dict = NSDictionary(object: UIFont.systemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        }
        
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: textWidth,height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        
        return rect.size.height
        
    }
    
    /// 根据字符串的实际内容，在固定的宽度和字体的大小下，动态的计算出实际的size
    func textSizeFromTextString(size: CGSize, fontSize: CGFloat = 14.0, isBold: Bool = false) -> CGSize {
        
        var dict: NSDictionary = NSDictionary()
        if (isBold) {
            dict = NSDictionary(object: UIFont.boldSystemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        } else {
            dict = NSDictionary(object: UIFont.systemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        }
        
        let rect: CGRect = (self as NSString).boundingRect(with: size, options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        
        return rect.size
        
    }
    
}
