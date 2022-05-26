//
//  ParseSchedule.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/18/22.
//

import Foundation

struct ParseSchedule: Decodable {
    let scheduleType: String
    let schedule: [ParsePeriod]
}
