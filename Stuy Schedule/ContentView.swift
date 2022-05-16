//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI

// function returns whether current time is school hours
// -1: before school
// 0: during school
// 1: after school
func schoolHours(_ date: Date) -> Int {
    let startTime = Calendar.current.date(bySettingHour: 7, minute: 59, second: 59, of: date)!
    let endTime = Calendar.current.date(bySettingHour: 15, minute: 35, second: 00, of: date)!
    
    if date <= startTime {
        return -1
    } else if date > startTime && date < endTime {
        return 0
    } else {
        return 1
    }
}

struct ContentView: View {
    
    @State var date = Date()
    @State var regularSchedule = RegularSchedule()
    @State var schoolTime = schoolHours(Date())
    
//    @State public var WidgetColorChoice = .system
    
    var body: some View {
        
        VStack {
            Text("Don't forget to add the widget!")
                .padding()
            Text("\(Date.now.formatted(date: .long, time: .omitted))")
                .padding()
            
            if schoolTime == -1 || schoolTime == 0 {
                let todayData = regularSchedule.getBlock(date)
                let aOrAn = regularSchedule.aOrAn(todayData[0])
                
                if todayData[0] == "N/A" {
                    Text("No School Today")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Today is \(aOrAn) \(todayData[0]) day with \(todayData[1])")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            } else if schoolTime == 1 {
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                let tomorrowData = regularSchedule.getBlock(tomorrow)
                let aOrAnTomorrow = regularSchedule.aOrAn(tomorrowData[0])
                
                if tomorrowData[0] == "N/A" {
                    Text("No School Tomorrow")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Tomorrow is \(aOrAnTomorrow) \(tomorrowData[0]) day with \(tomorrowData[1])")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
            
//            Pickerq
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
