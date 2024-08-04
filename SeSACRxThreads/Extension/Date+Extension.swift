//
//  Date+Extension.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/5/24.
//

import Foundation

extension Date {
    // Date에서 Component에 해당되는 값 가져오기
    var year: Int {
        let cal = Calendar.current
        return cal.component(.year, from: self)
    }
    var month: Int {
        let cal = Calendar.current
        return cal.component(.month, from: self)
    }
    var day: Int {
        let cal = Calendar.current
        return cal.component(.day, from: self)
    }
    var hour: Int {
        let cal = Calendar.current
        return cal.component(.hour, from: self)
    }
    var minute: Int {
        let cal = Calendar.current
        return cal.component(.minute, from: self)
    }
    var onlyDate: Date {
        let dateformtter = DateFormatter()
        dateformtter.dateFormat = "yyyy-MM-dd"
        let dateString = dateformtter.string(from: self)
        var date = dateformtter.date(from: dateString)!
        let components = DateComponents(year: date.year, month: date.month, day: date.day, hour: 0, minute: 0, second: 0)
        date = Calendar.current.date(from: components) ?? Date()
        return date
    }
}
