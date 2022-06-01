//
//  GetParsedSchedule.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/18/22.
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

private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//            return String(decoding: jsonData, as: UTF8.self)
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

struct GetParsedSchedule {
    
    var schedule: [Period] = []
    
    internal func parse(jsonName: String) -> [ParsePeriod] {
        let jsonData = readLocalFile(forName: jsonName)!
        
        let parsedJSON = try! JSONDecoder().decode(ParseSchedule.self, from: jsonData)
        return parsedJSON.schedule
    }
    
    init(jsonName: String, _ date: Date) {
        generateSchedule(jsonName: jsonName, date)
    }
    
    mutating func generateSchedule(jsonName: String, _ date: Date) {
        let parsedPeriods = parse(jsonName: jsonName)
        for period in parsedPeriods {
            self.schedule.append(period.parse(date))
        }
//        return schedule
    }
    
    mutating func getPeriod(_ date: Date) -> Period {
        var period: Period = self.schedule[0]
        var minTime: Int = date.minutes(from: period.startTime)
        
        for i in 1..<self.schedule.count {
            let tryPeriod = date.minutes(from: self.schedule[i].startTime)
            if (tryPeriod >= 0) && (tryPeriod < minTime) {
                minTime = tryPeriod
                period = self.schedule[i]
            }
        }
        
        return period
    }
    
    mutating func getBlock(_ date: Date) -> [String] {
let blockData =
[
"May 3, 2022": ["A1", "Science Testing"],
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
"June 1, 2022": ["A1", "No Testing"],
"June 2, 2022": ["B2", "Math Testing, Music, Art , Tech"],
"June 3, 2022": ["A2", "WL, ELA, CS, SS and Health Testing"],
"June 6, 2022": ["B1", "Science Testing In Class Finals or Unit Tests"],
"June 7, 2022": ["A1", "WL, ELA, Health In Class Finals or Unit Tests"],
"June 8, 2022": ["B2", "Math, Music, Art In Class Finals or Unit Tests"],
"June 10, 2022": ["A2", "CS, SS, Tech In Class Finals or Unit Tests"],
"June 13, 2022": ["B", "No Finals/Units Makeup Test Day"],
"June 14, 2022": ["A", "Last Class Day Makeup Test Day"]
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
