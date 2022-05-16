//
//  RegularSchedule.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 4/19/22.
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
    var schedule: [Period] = []
    
    mutating func getSchedule(_ date: Date) -> [Period] {
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: date)!,
                                          duration: 60,
                                          name: "Before Period 1"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 1"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 8, minute: 41, second: 0, of: date)!,
                                          duration: 4,
                                          name: "Before Period 2"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 2"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 9, minute: 26, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 3"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 9, minute: 31, second: 0, of: date)!,
                                          duration: 44,
                                          name: "Period 3"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 4"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 10, minute: 20, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 4"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 11, minute: 01, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 5"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 11, minute: 06, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 5"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 11, minute: 47, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 6"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 11, minute: 52, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 6"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 12, minute: 33, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 7"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 12, minute: 38, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 7"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 13, minute: 19, second: 0, of: date)!,
                                          duration: 5,
                                          name: "Before Period 8"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 13, minute: 24, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 8"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 14, minute: 05, second: 0, of: date)!,
                                          duration: 4,
                                          name: "Before Period 9"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 14, minute: 09, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 9"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 14, minute: 50, second: 0, of: date)!,
                                          duration: 4,
                                          name: "Before Period 10"))
        self.schedule.append(Period(startTime: Calendar.current.date(bySettingHour: 14, minute: 54, second: 0, of: date)!,
                                          duration: 41,
                                          name: "Period 10"))
        return schedule
    }
    
    mutating func getPeriod(_ date: Date) -> Period {
        let regSchedule = self.getSchedule(date)
        var period: Period = regSchedule[0]
        var minTime: Int = date.minutes(from: period.startTime)

        for i in 1..<regSchedule.count {
            let tryPeriod = date.minutes(from: regSchedule[i].startTime)
            if (tryPeriod >= 0) && (tryPeriod < minTime) {
                minTime = tryPeriod
                period = regSchedule[i]
            }
        }

        return period
    }
    
    mutating func getBlock(_ date: Date) -> [String] {
        let blockData = ["May 3, 2022": ["A1", "Science Testing"],
                         "May 4, 2022": ["B1", "WL, ELA and Health Testing"],
                         "May 5, 2022": ["A2", "Math Testing, Music, Art Testing"],
                         "May 6, 2022": ["B2", "CS, SS Testing and Technology"],
                         "May 9, 2022": ["A", "Science Testing"],
                         "May 10, 2022": ["B1", "Science Testing"],
                         "May 11, 2022": ["A1", "WL, ELA and Health Testing"],
                         "May 12, 2022": ["B2", "Math Testing, Music, Art Testing"],
                         "May 13, 2022": ["A2", "CS, SS Testing and Technology"],
                         "May 16, 2022": ["B", "Science Testing"],
                         "May 17, 2022": ["A1", "Science Testing"],
                         "May 18, 2022": ["B1", "WL, ELA and Health Testing"],
                         "May 19, 2022": ["A2", "Math Testing, Music, Art Testing"],
                         "May 20, 2022": ["B2", "CS, SS Testing and Technology"],
                         "May 23, 2022": ["A", "Science Testing"],
                         "May 24, 2022": ["B1", "Science Testing"],
                         "May 25, 2022": ["A1", "WL, ELA and Health Testing"],
                         "May 26, 2022": ["B2", "Math Testing, Music, Art Testing"],
                         "May 27, 2022": ["A2", "CS, SS Testing and Technology"],
                         "May 31, 2022": ["B1", "Science Testing"],
                         "June 2, 2022": ["A1", "Math Testing, Music, Art , Tech"],
                         "June 3, 2022": ["B2", "WL, ELA, CS, SS and Health Testing"],
                         "June 6, 2022": ["A2", "Science Testing In Class Finals or Unit Tests"],
                         "June 7, 2022": ["B1", "WL, ELA, Health In Class Finals or Unit Tests"],
                         "June 8, 2022": ["A1", "Math, Music, Art In Class Finals or Unit Tests"],
                         "June 10, 2022": ["B2", "CS, SS, Tech In Class Finals or Unit Tests"],
                         "June 13, 2022": ["A2", "No Finals/Units Makeup Test Day"],
                         "June 14, 2022": ["B", "Last Class Day Makeup Test Day"]
        ]
        
        for (key, value) in blockData {
            if key == date.formatted(date: .long, time: .omitted) {
                return value
            }
        }
        return ["N/A"]
    }
    
    mutating func aOrAn(_ block: String) -> String {
        for char in block {
            if (char == "A") {
                return "an"
            }
        }
        return "a"
    }
}
