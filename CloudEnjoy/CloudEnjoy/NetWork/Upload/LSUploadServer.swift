//
//  LSUploadServer.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import Foundation
import LSNetwork
import Moya
import RxSwift


//资源上传器
struct LSUploadServer {
    
    static let provider = LSProvider<LSUploadAPI>()
    
    static func upload(image: UIImage, progress: ProgressBlock? = .none) -> Single<LSUploadPhotoModel?> {
        return provider.lsUploadImages(.uploadImage(image: image), callbackQueue: .main, progress: progress).mapHandyModel(type: LSUploadPhotoModel.self)
    }
    
    static func fileUpload(image: UIImage, progress: ProgressBlock? = .none) -> Single<LSUploadFileModel?> {
        return provider.lsUploadImages(.fileUpload(image: image), callbackQueue: .main, progress: progress).mapHandyModel(type: LSUploadFileModel.self)
    }
}

