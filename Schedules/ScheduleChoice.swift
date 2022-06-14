//
//  ScheduleChoice.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/19/22.
//

import Foundation

struct ScheduleChoice {
    static var scheduleChoice = "regular_schedule"
    
    static func getName(name: String) -> String {
        if name == "regular_schedule" {
            return "Regular Schedule"
        } else if name == "conference_schedule" {
            return "Conference Schedule"
        } else if name == "homeroom_schedule" {
            return "Homeroom Schedule"
        } else if name == "special20_homeroom_schedule" {
            return "20 - Minute Homeroom Schedule"
        }
        return ""
    }
}
