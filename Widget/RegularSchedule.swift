//
//  RegularSchedule.swift
//  stuy-schedule
//
//  Created by Paul Serbanescu on 4/14/22.
//

import Foundation

extension Date {
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}

struct RegularSchedule {
    func getSchedule() -> [Date?] {
        let date = Date()
        
        // all times are START times
        let before1 = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: date)
        let pd1 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: date)
        let before2 = Calendar.current.date(bySettingHour: 8, minute: 41, second: 0, of: date)
        let pd2 = Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: date)
        let before3 = Calendar.current.date(bySettingHour: 9, minute: 26, second: 0, of: date)
        let pd3 = Calendar.current.date(bySettingHour: 9, minute: 31, second: 0, of: date)
        let before4 = Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: date)
        let pd4 = Calendar.current.date(bySettingHour: 10, minute: 20, second: 0, of: date)
        let before5 = Calendar.current.date(bySettingHour: 11, minute: 01, second: 0, of: date)
        let pd5 = Calendar.current.date(bySettingHour: 11, minute: 06, second: 0, of: date)
        let before6 = Calendar.current.date(bySettingHour: 11, minute: 47, second: 0, of: date)
        let pd6 = Calendar.current.date(bySettingHour: 11, minute: 52, second: 0, of: date)
        let before7 = Calendar.current.date(bySettingHour: 12, minute: 33, second: 0, of: date)
        let pd7 = Calendar.current.date(bySettingHour: 12, minute: 38, second: 0, of: date)
        let before8 = Calendar.current.date(bySettingHour: 13, minute: 19, second: 0, of: date)
        let pd8 = Calendar.current.date(bySettingHour: 13, minute: 24, second: 0, of: date)
        let before9 = Calendar.current.date(bySettingHour: 14, minute: 05, second: 0, of: date)
        let pd9 = Calendar.current.date(bySettingHour: 14, minute: 09, second: 0, of: date)
        let before10 = Calendar.current.date(bySettingHour: 14, minute: 50, second: 0, of: date)
        let pd10 = Calendar.current.date(bySettingHour: 14, minute: 54, second: 0, of: date)
        let beforeEnd = Calendar.current.date(bySettingHour: 14, minute: 35, second: 0, of: date)
        
        let dateArr = [before1, pd1, before2, pd2, before3, pd3, before4, pd4, before5, pd5, before6, pd6, before7, pd7, before8, pd8, before9, pd9, before10, pd10, beforeEnd]
        
        print("len dateArr: \(dateArr.count)")
        
        return dateArr
    }
    func getNames() -> [String] {
        let names = ["Chill", "Before School", "Period 1", "Before Period 2", "Period 2", "Before Period 3", "Period 3", "Before Period 4", "Period 4", "Before Period 5", "Period 5", "Before Period 6", "Period 6", "Before Period 7", "Period 7", "Before Period 8", "Period 8", "Before Period 9", "Period 9", "Before Period 10", "Period 10", "After School"]
        print("len names: \(names.count)")
        return names
    }
    func getPeriod(_ date: Date) -> Int {
        var period: Int = 0
        let regSchedule = self.getSchedule()
        var minTime: Int = date.minutes(from: regSchedule[0]!)
        print(minTime)
        
        for i in 1..<regSchedule.count {
            let tryPeriod = date.minutes(from: regSchedule[i]!) * -1
            print("dateis: \(date)\ntrypd: \(tryPeriod)")
            if (tryPeriod > 0) && (tryPeriod < minTime) {
                print("\(tryPeriod), and I is:  \(i)")
                minTime = tryPeriod
                period = i
            }
        }
        
        return period
    }
}
