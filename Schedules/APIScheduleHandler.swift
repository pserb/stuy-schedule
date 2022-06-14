//
//  ParseWeekSchedule.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 6/4/22.
//

import Foundation

func getMonday(myDate: Date) -> Date {
    let cal = Calendar.current
    var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
    comps.weekday = 2 // Monday
    let mondayInWeek = cal.date(from: comps)!
    return mondayInWeek
}

struct ParseWeekSchedule: Decodable {
    let scheduleType: String
    let days: [ParseDay]
}

struct ParseDay: Decodable {
    // day format: Month day, year
    // there must always be a day
    let day: String
    // there must always be a bell (NO SCHOOL) if no school
    let bell: String
    // will be nil if no school
    let block: String?
    let testing: String?
    // will be nil if no announcement
    let announcement: String?
}

struct GetAPIData {
    
    var weekSchedule: [ParseDay] = []
    // format is day:announcement
    var announcements: [[String]] = []
    
    init(date: Date) {
//        print("initalizer called")
        generateWeekSchedule(date: date)
    }
    
    mutating func getWeekSchedule() -> [ParseDay]? {
        if weekSchedule.isEmpty {
            return nil
        } else {
            return weekSchedule
        }
    }
    
    mutating func generateWeekSchedule(date: Date) {
        let data: ParseWeekSchedule? = UserPrefs.parseData(fileName: "weekly-schedule")
        if data != nil {
//            print("data is not nil")
            let data = data!
            self.weekSchedule = data.days
            
            // reset array
//            announcements.removeAll()
            for day in weekSchedule {
//                print(day.announcement)
                if day.announcement != nil {
//                    print("not nil!")
                    let subarr: [String] = [day.day, day.announcement!]
                    announcements.append(subarr)
                }
            }
        }
//        print(announcements)
    }
    
    mutating func getToday(date: Date) -> ParseDay? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        for day in weekSchedule {
            // if it is today
            if day.day == formatter.string(from: date) {
                // if there is no school
                if day.bell == "NO SCHOOL" {
                    return nil
                }
                return day
            }
        }
        return nil
    }
    
    internal func parseLocalSchedule(jsonName: String) -> [ParsePeriod] {
        let jsonData = readLocalFile(forName: jsonName)!
        
        let parsedJSON = try! JSONDecoder().decode(ParseSchedule.self, from: jsonData)
        return parsedJSON.schedule
    }
    
    mutating func generateTodayBellSchedule(date: Date) -> [Period]? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        for day in weekSchedule {
            // find today
            if day.day == formatter.string(from: date) {
                // if it is not a school day: return false
                if day.bell == "NO SCHOOL" {
                    return nil
                } else {
                    // decode corresponding local json
                    let parsedPeriods: [ParsePeriod] = parseLocalSchedule(jsonName: day.bell)
                    var schedule: [Period] = []
                    
                    for period in parsedPeriods {
                        schedule.append(period.parse(date))
                    }
                    
                    return schedule
                }
            }
        }
        return nil
    }
    
    mutating func getCurrentPeriod(date: Date) -> Period? {
        let bellSchedule: [Period]? = generateTodayBellSchedule(date: date)
        
        if bellSchedule != nil {
            let bellSchedule = bellSchedule!
            
            var period: Period = bellSchedule[0]
            var minTime: Int = date.minutes(from: period.startTime)
            
            for i in 1..<bellSchedule.count {
                let tryPeriod = date.minutes(from: bellSchedule[i].startTime)
                if (tryPeriod >= 0) && (tryPeriod < minTime) {
                    minTime = tryPeriod
                    period = bellSchedule[i]
                }
            }
            
            return period
        }
        return nil
    }
    
    mutating func getTodayBlock(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        for day in weekSchedule {
            // find today
            if day.day == formatter.string(from: date) {
                if day.block == nil {
                    return nil
                } else {
                    return day.block
//                    let block = day.block!
//                    // a or an
//                    if (block == "A") || (block == "A1") || (block == "A2") {
//                        return "an \(block)"
//                    } else {
//                        return "a \(block)"
//                    }
                }
            }
        }
        return nil
    }
    
    mutating func getTodayAnnouncement(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        for day in weekSchedule {
            // if today
            if day.day == formatter.string(from: date) {
                return day.announcement
            }
        }
        return nil
    }
    
    mutating func getNextAnnouncement(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        var N: Int = 0
        // find start pos
        for day in weekSchedule {
            if day.day == formatter.string(from: date) {
                break
            } else {
                N += 1
            }
        }
        
        if !weekSchedule.isEmpty && N <= weekSchedule.count-1 {
            if getTodayAnnouncement(date: date) == nil {
                for i in N...weekSchedule.count-1 {
                    // find next announcement
                    if weekSchedule[i].announcement != nil {
                        return "\(weekSchedule[i].day): \(weekSchedule[i].announcement!)"
                    }
                }
            }
        }
        return getTodayAnnouncement(date: date)
    }
    
    
}
