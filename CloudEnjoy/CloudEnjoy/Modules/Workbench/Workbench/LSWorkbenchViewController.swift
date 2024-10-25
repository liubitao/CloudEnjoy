//
//  LSWorkbenchViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/2.
//

import Foundation
import UIKit
import SwifterSwift
import LSBaseModules
import RxDataSources
import RxSwift

class LSWorkbenchViewController: LSBaseViewController {
    @IBOutlet weak var headBackImageView: UIImageView!
    @IBOutlet weak var headBackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var queryView: UIView!
    @IBOutlet weak var queryCllectionView: UICollectionView!
    @IBOutlet weak var queryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderCollectionView: UICollectionView!
    @IBOutlet weak var orderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var attendaceView: UIView!
    @IBOutlet weak var attendanceCollectionView: UICollectionView!
    @IBOutlet weak var attendanceHeight: NSLayoutConstraint!
    
    let dataSource: [[LSRoleType]] = [[.royalties, .clocks, .workorder, .userquery, .jsRank, .orderSummary],
                                      [.order, .addOrder, .sendWork],
                                      [.clockin, .leave]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vhl_navBarBackgroundAlpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vhl_navBarBackgroundAlpha = 1
    }
    
    override func setupViews() {
        self.headBackImageView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00AAB7")!, endColor: Color(hexString: "#00C294")!, width: UI.SCREEN_WIDTH, height: UI.STATUS_NAV_BAR_HEIGHT + 73, isTopToBottom: false)
        self.headBackHeight.constant = UI.STATUS_NAV_BAR_HEIGHT + 73
        
        let collectionViews: [UICollectionView] = [self.queryCllectionView, self.orderCollectionView, self.attendanceCollectionView]
        let contentViews: [UIView] = [self.queryView, self.orderView, self.attendaceView]

        let collectionHeight: [NSLayoutConstraint] = [self.queryHeight, self.orderHeight, self.attendanceHeight]
        for (index, collectionView) in collectionViews.enumerated() {
            let roleTypes = self.dataSource[index].filter{rolemapModel().contains($0)}
            contentViews[index].isHidden = roleTypes.isEmpty
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 10 * 2)/4.0, height: 80)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
            collectionView.register(nibWithCellClass: LSWorkbenchCell.self)
            let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, LSRoleType>> { dataSource, collectionView, indexPath, model in
                let cell = collectionView.dequeueReusableCell(withClass: LSWorkbenchCell.self, for: indexPath)
                cell.workbenchImageView.image = UIImage(named: model.title)
                cell.workbenchLab.text = model.title
                return cell
            }
            let items = Observable<[SectionModel<Int, LSRoleType>]>.just([SectionModel(model: index, items: roleTypes)])
            items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            collectionView.rx.modelSelected(LSRoleType.self).subscribe(onNext: { [weak self] roleType in
                guard let self = self else {return}
                switch roleType {
                case .royalties:
                    self.jumpRoyalties()
                    break
                case .clocks:
                    self.jumpClocks()
                    break
                case .workorder:
                    self.jumpWorkorder()
                    break
                case .userquery:
                    self.jumpUserquery()
                    break
                case .jsRank:
                    self.jumpJsRank()
                    break
                case .orderSummary:
                    self.jumpOrderSummary()
                    break
                case .order:
                    self.jumpOrder()
                    break
                case .addOrder:
                    self.jumpAddOrder()
                    break
                case .sendWork:
                    self.jumpSendWork()
                    break
                case .clockin:
                    self.jumpClockin()
                    break
                case .leave:
                    self.jumpLeave()
                    break
                case .other:
                    break
                }
            }).disposed(by: self.rx.disposeBag)
        }
        
        self.view.layoutIfNeeded()
        for index in 0..<collectionViews.count {
            collectionHeight[index].constant = collectionViews[index].collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    func jumpRoyalties() {
        self.navigationController?.pushViewController(LSRoyaltiesViewController(), animated: true)
    }
    
    func jumpClocks() {
        self.navigationController?.pushViewController(LSClocksViewController(), animated: true)
    }
    
    func jumpWorkorder() {
        self.navigationController?.pushViewController(LSWorkorderViewController(), animated: true)
    }
    
    func jumpOrderSummary() {
        self.navigationController?.pushViewController(LSOrderSummaryViewController(), animated: true)
    }
    
    func jumpJsRank() {
        self.navigationController?.pushViewController(LSJsRankViewController(), animated: true)
    }
    
    func jumpUserquery() {
        self.navigationController?.pushViewController(LSUserqueryViewController(), animated: true)
    }
    func jumpOrder() {
        self.navigationController?.pushViewController(LSOrderViewController(), animated: true)
    }
    func jumpAddOrder() {
        self.navigationController?.pushViewController(LSAddOrderViewController(), animated: true)
    }
    func jumpClockin() {
        self.navigationController?.pushViewController(LSClockinViewController(), animated: true)
    }
    func jumpLeave() {
        self.navigationController?.pushViewController(LSLeaveViewController(), animated: true)
    }
    func jumpSendWork() {
        if parametersModel().OperationMode == .roomAndBed {
            self.navigationController?.pushViewController(LSRoomChioceViewController(), animated: true)
        }else {
            self.navigationController?.pushViewController(LSHandCardChioceViewController(), animated: true)
        }
    }
    
    
    
 
   
}

