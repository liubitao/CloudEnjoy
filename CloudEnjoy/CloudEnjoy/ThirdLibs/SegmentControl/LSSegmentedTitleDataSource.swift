//
//  LSSegmentedTitleDataSource.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/18.
//

import UIKit
import JXSegmentedView
import SwifterSwift

class LSSegmentedTitleDataSource: JXSegmentedTitleDataSource {
    var backgroundNormalColor = Color.clear
    var backgroundSelectedColor = Color.clear
    
    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return LSSegmentedTitleItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? LSSegmentedTitleItemModel else {
            return
        }

        itemModel.backgroundNormalColor = backgroundNormalColor
        itemModel.backgroundSelectedColor = backgroundSelectedColor
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(LSSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
