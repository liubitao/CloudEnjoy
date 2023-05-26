//
//  LSLSPrintLog.swift
//  LSBaseModules
//
//  Created by liubitao on 2022/5/11.
//

import Foundation
import CocoaLumberjack
import SwifterSwift

public func initLSPrintLog() {
    removeLogFile(days: 7)
    //不同的日志通道配置格式
    DDLog.add(DDOSLogger.sharedInstance)
    
    let applicationDocumentsDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    let fileLoggerManager =  DDLogFileManagerDefault.init(logsDirectory: applicationDocumentsDir)
    fileLoggerManager.maximumNumberOfLogFiles = 7       // 最多 7份
    let fileLogger = DDFileLogger(logFileManager: fileLoggerManager)
    fileLogger.rollingFrequency = 24 * 60 * 60          // 一天记录一份
    fileLogger.maximumFileSize  = 0                     // 大小无上限
    DDLog.add(fileLogger)
    
    LSPrintLog("APP start ---------------------------------------------------------------------------------------------------------")
}
///全局函数
public func LSPrintLog(_ message: Any..., file:String = #file, funcName:String = #function, lineNum:Int = #line){
    LSPrint(message, file: file, funcName: funcName, lineNum: lineNum)
}

private func LSPrint(_ items: Any..., file:String = #file,funcName:String = #function,lineNum:Int = #line) {
    
    let file = (file as NSString).lastPathComponent;
    
    let date = Date().stringTime24(withFormat: "HH:mm:ss")
    let itemsDes = items.reduce("") { partialResult, result in
        var temp = "\(result)"
        if let resultArray = result as? [Any] {
            temp = resultArray.reduce("") { arg1 , arg2 in
                return arg1 + " \(arg2)"
            }
        }
        return partialResult + temp
    }
    let consoleStr = "\n\(date) \(file) \(funcName)[\(lineNum)]:\(itemsDes)"
    
    #if DEBUG
    Swift.print(consoleStr)
    #endif

    saveLog(original: consoleStr,fileName: "Log-")
}

private func saveLog(original: String, fileName: String? = nil) {
    //将内容同步写到文件中去（Caches文件夹下）
    guard let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                        in: .userDomainMask).first  else {
        return
    }
    
    let today = Date().stringTime24(withFormat: "yyyy-MM-dd")
    
    let logURL = cachePath.appendingPathComponent("\(fileName!)-\(today).txt")
    
    appendText(fileURL: logURL, string: "\(original)")
    
}

//在文件末尾追加新内容
private func appendText(fileURL: URL, string: String) {
    
    //如果文件不存在则新建一个
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
    }
    
    guard let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
        return
    }
    
    let stringToWrite = "\n" + string
    //找到末尾位置并添加
    fileHandle.seekToEndOfFile()
    
    guard let d = stringToWrite.data(using: String.Encoding.utf8) else {
        return
    }
    
    fileHandle.write(d)
    fileHandle.closeFile()
    
}

/// 删除前几天的Log
/// - Parameter days: 几天前。前7天， days： 7
private func removeLogFile(days: Int) {
    
    let preDate = Date().adding(.day, value: -days)
    let preDateStr = preDate.stringTime24(withFormat: "yyyy-MM-dd")
    
    let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                in: .userDomainMask)[0]
    let preDateLogURL = cachePath.appendingPathComponent("Log--\(preDateStr).txt")
    
    let fileManager = FileManager.default
    
    guard let items = try? fileManager.contentsOfDirectory(at: cachePath, includingPropertiesForKeys: [URLResourceKey.init("Log-")], options: [.skipsSubdirectoryDescendants, .skipsPackageDescendants, .skipsHiddenFiles]) else {
        LSPrint("Could not search for urls of files in documents directory")
        return
    }
    
    //删掉过期的Log文件
    for item in items {
        let path = item.absoluteString
        if path.contains("Log--") , path.suffix(15) < preDateLogURL.absoluteString.suffix(15) {
            guard let fileUrl = URL(string: "\(path)") else { return }
            try? FileManager.default.removeItem(at: fileUrl)
        }
    }
    
}
