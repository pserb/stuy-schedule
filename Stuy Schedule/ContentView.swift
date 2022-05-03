//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var regularSchedule = RegularSchedule()
    let date = Date()
    let cal = Calendar.current
    
    var body: some View {
        
        VStack {
            Text("Don't forget to add the widget!")
                .padding()
            Text("\(Date.now.formatted(date: .long, time: .omitted))")
                .padding()
        
            if ((cal.component(.hour, from: date) == 15) && (cal.component(.minute, from: date) >= 35)) ||
                ((cal.component(.hour, from: date) >= 16) && (cal.component(.hour, from: date) <= 24)) {
                
                let tmr = cal.date(byAdding: .day, value: 1, to: date)!
                let tmrData = regularSchedule.getBlock(tmr)
                let aOrAn = regularSchedule.aOrAn(tmrData[0])
                
                if tmrData[0] == "N/A" {
                    Text("No School Today")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Tomorrow is \(aOrAn) \(tmrData[0]) day with \(tmrData[1])")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
            else if ((cal.component(.hour, from: date) < 7) && (cal.component(.hour, from: date) >= 0)) {
                
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
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
