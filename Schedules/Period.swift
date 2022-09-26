//
//  Period.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 4/19/22.
//

import Foundation

struct Period: Hashable {
    // Start Time
    var startTime: Date
    // Duration (in minutes)
    var duration: Int
    // Name
    var name: String
    
    // End Time
    internal var endTime: Date
    
    init(startTime: Date, duration: Int, name: String) {
        self.startTime = startTime
        self.duration = duration
        self.name = name
        
        self.endTime = Calendar.current.date(byAdding: .minute, value: duration, to: startTime)!
    }
}
