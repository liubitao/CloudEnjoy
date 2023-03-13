//
//  KyoCenterRefreshProtocol.swift
//  LiYu
//
//  Created by Kyo on 2019/5/30.
//  Copyright © 2019 liyu. All rights reserved.
//

import Foundation

/**< 中央刷新控件需要实现的属性方法，其它自定义视图通过实现这个协议达到自定义中央刷新控件 */
@objc public protocol KyoCenterRefreshProtocol: NSObjectProtocol {
    weak var scrollView: UIScrollView? { get set }
    weak var delegate: KyoCenterRefreshDelegate? { get set }
    var isLoading: Bool { get set}
    var centerOffsetY: CGFloat { get set}
    
    init(scrollView: UIScrollView!, delegate: KyoCenterRefreshDelegate!)
    func refreshOperation() /**< 开始刷新 */
    func refreshDidFinished() /**< 刷新结束 */
}

/**< 中央刷新控件绑定的KyoRefreshControl需要实现的代理方法 */
@objc public protocol KyoCenterRefreshDelegate: NSObjectProtocol {
    func refreshDidRefresh(refresh: KyoCenterRefreshProtocol)
}
