//
//  ScheduleChoice.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/19/22.
//

import Foundation

struct ScheduleChoice {
    static var scheduleChoice = "regular_schedule"
    
    public static var description: String {
        if scheduleChoice == "regular_schedule" {
            return "Regular Schedule"
        } else if scheduleChoice == "conference_schedule" {
            return "Conference Schedule"
        }
        return ""
    }
}
