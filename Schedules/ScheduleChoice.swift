//
//  ScheduleChoice.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/19/22.
//

import Foundation

struct ScheduleChoice {
    static var scheduleChoice = "regular_schedule"
    static var scheduleName = "Regular Schedule"
    
    static func getName(name: String) -> String {
        if name == "regular_schedule" {
            return "Regular Schedule"
        } else if name == "conference_schedule" {
            return "Conference Schedule"
        } else if name == "homeroom_schedule" {
            return "Homeroom Schedule"
        }
        return ""
    }
}
