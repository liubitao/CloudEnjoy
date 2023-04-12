//
//  LSClockListViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/30.
//

import UIKit
import JXSegmentedView
import RxDataSources
import SwifterSwift
import RxSwift
import LSNetwork

class LSClockListViewController: LSBaseViewController {
    var calender: FSCalendar!
    
    
    var placePunchinModels = [LSPlacePunchinItemModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupViews() {
        self.calender = {
            let calendar = FSCalendar(frame: CGRect(x: 10, y: 10, width: UI.SCREEN_WIDTH - 20, height: 250))
            calendar.backgroundColor = UIColor.white
            calendar.cornerRadius = 5
            calendar.dataSource = self
            calendar.delegate = self
            calendar.placeholderType = .none
            calendar.firstWeekday = 2
            calendar.weekdayHeight = 35
            calendar.calendarWeekdayView.backgroundColor = UIColor(hexString: "#F5F5F5")
            calendar.allowsMultipleSelection = false
            let appearance = calendar.appearance
            appearance.titleFont = Font.pingFangRegular(15)
            appearance.weekdayFont = Font.pingFangRegular(13)
            appearance.headerTitleFont = Font.pingFangRegular(18)
            appearance.caseOptions = .weekdayUsesSingleUpperCase
            appearance.weekdayTextColor = Color(hexString: "#999999")!
            appearance.headerTitleColor = Color(hexString: "#010101")!
            appearance.headerDateFormat = "yyyy年MM月"
            appearance.headerMinimumDissolvedAlpha = 0
            appearance.titleDefaultColor = Color(hexString: "#333333")
            appearance.titleSelectionColor = Color(hexString: "#FFFFFF")
            calendar.today = nil
            appearance.selectionColor = Color(hexString: "#00AAB7")
            view.addSubview(calendar)
            return calendar
        }()
    }
    override func setupData() {
        self.workData()
    }
    
    func workData() {
        Toast.showHUD()
        LSWorkbenchServer.getPlacePunchinList(datetime: Date().string(withFormat: "yyyy-MM-dd")).subscribe { listModel in
            self.placePunchinModels = listModel?.list ?? []
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
}

extension LSClockListViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.workData()
    }
}


extension LSClockListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
