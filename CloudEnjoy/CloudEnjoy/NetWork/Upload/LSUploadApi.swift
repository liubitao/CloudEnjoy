//
//  LSUploadApi.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import Foundation
import LSNetwork
import Moya
import LSBaseModules
import SwifterSwift

extension LSUploadAPI.APIPath {
    static let uploadUserImg = "sysuser/uploadUserImg"
    static let fileUpload = "bi/product/fileUpload"
}

enum LSUploadAPI: TargetType {
    struct APIPath {}

    case uploadImage(image: UIImage)
    case fileUpload(image: UIImage)
    
}

extension LSUploadAPI: LSTargetType{
    var path: String {
        switch self {
        case .uploadImage:
            return APIPath.uploadUserImg
        case .fileUpload:
            return APIPath.fileUpload
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .uploadImage(image):
            let imgData = image.compressedData() ?? Data()
            let formData = MultipartFormData(provider: .data(imgData), name: "data", fileName: "image_\(Date()).png", mimeType: "image/png")
            
            var parameters = ["spid": userModel().spid.string,
                              "sid": userModel().sid.string,
                              "userid": userModel().userid]
            if !LSLoginModel.shared.token.isEmpty {
                parameters["token"] = LSLoginModel.shared.token
            }
            parameters["sign"] = "83690002"
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        case let .fileUpload(image):
            let imgData = image.compressedData() ?? Data()
            let formData = MultipartFormData(provider: .data(imgData), name: "data", fileName: "image_\(Date()).png", mimeType: "image/png")
            
            var parameters = [String: Any]()
            if !LSLoginModel.shared.token.isEmpty {
                parameters["token"] = LSLoginModel.shared.token
            }
            parameters["sign"] = "83690002"
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        }
    }
    
    
    
}


