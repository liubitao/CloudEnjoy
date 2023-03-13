//
//  LSCalendarViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import UIKit
import SwifterSwift

class LSCalendarViewController: LSBaseViewController {

    var calender: FSCalendar!
    var beginDate: Date?
    var endDate: Date?
    var selectAction = false
    
    typealias SelectedClosure = (Date, Date) -> Void
    var selectedClosure: SelectedClosure?
    
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSCalendarViewController")
        return vc as! Self
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .doNothing
        transitionAnimationDelegate.viewAnimationType = .transformFromBottom
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        presentingViewController.present(self, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 370+UI.BOTTOM_HEIGHT);
        
        self.calender = {
            let calendar = FSCalendar(frame: CGRect(x: 10, y: 45, width: UI.SCREEN_WIDTH - 20, height: 250))
            calendar.dataSource = self
            calendar.delegate = self
            calendar.placeholderType = .none
            calendar.firstWeekday = 2
            calendar.weekdayHeight = 35
            calendar.calendarWeekdayView.backgroundColor = UIColor(hexString: "#F5F5F5")
            calendar.allowsMultipleSelection = true
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
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let beginDate = self.beginDate else {
            Toast.show("请选择时间范围")
            return
        }
        self.selectedClosure?(beginDate, self.endDate ?? beginDate)
        self.dismiss(animated: true)
    }
    
    func numberOfDaysWithFromDate(fromDate: Date, toDate: Date) -> Int{
        let calendar = Calendar(identifier: .gregorian)
        let comp = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return comp.day ?? 0
    }

}

extension LSCalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !self.selectAction {
            let selectArray = calendar.selectedDates
            selectArray.forEach{calendar.deselect($0)}
            calendar.select(date)
            self.selectAction = true
            self.beginDate = date
            self.endDate = nil
        }else {
            let number = self.numberOfDaysWithFromDate(fromDate: self.beginDate!, toDate: date)
            if number < 0 {
                self.endDate = self.beginDate
                self.beginDate = date
            }else {
                self.endDate = date
            }
            self.selectAction = false
            for i in 0..<abs(number) {
                calendar.select(self.beginDate?.adding(.day, value: i))
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectArray = calendar.selectedDates
        selectArray.forEach{calendar.deselect($0)}

        calendar.select(date)
        self.selectAction = true
        self.beginDate = date
        self.endDate = nil
    }
}


