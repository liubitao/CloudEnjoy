//
//  LSSegmentedTitleCell.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/18.
//

import UIKit
import JXSegmentedView

class LSSegmentedTitleCell: JXSegmentedTitleCell {
    public let bgView = UIView()

    open override func commonInit() {
        super.commonInit()

        bgView.backgroundColor = UIColor(hexString: "")
        bgView.layer.masksToBounds = true
        contentView.insertSubview(bgView, at: 0)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        bgView.frame = self.bounds
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? LSSegmentedTitleItemModel else {
            return
        }

        bgView.backgroundColor = myItemModel.isSelected ? myItemModel.backgroundSelectedColor : myItemModel.backgroundNormalColor
        setNeedsLayout()
    }
}
