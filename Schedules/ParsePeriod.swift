//
//  ParsePeriod.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/18/22.
//

import Foundation

struct ParsePeriod: Decodable {
    let name: String
    let startTime: String
    let duration: Int
    
    func parse(_ date: Date) -> Period {
        let splitTime = self.startTime.split(separator: ":")
        let hour: Int = Int(splitTime[0])!
        let minute: Int = Int(splitTime[1])!
        return Period(startTime: Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)!, duration: self.duration, name: self.name)
    }
}
