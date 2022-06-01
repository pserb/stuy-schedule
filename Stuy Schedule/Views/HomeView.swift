//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI
import WidgetKit

var scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())

@ViewBuilder func scheduleButton(schedule: String) -> some View {
    if #available(iOS 15.0, *) {
        Button(action: {
            ScheduleChoice.scheduleChoice = schedule
            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
        }, label: {
            Image(systemName: "rectangle.2.swap")
            Text("Swap to \(ScheduleChoice.getName(name: schedule))")
//                .padding(.trailing, 20)
        })
        .padding(.all, 10)
        .padding(.horizontal, 10)
        .background(.regularMaterial)
    } else {
        Button(action: {
            ScheduleChoice.scheduleChoice = schedule
            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
        }, label: {
            Image(systemName: "rectangle.2.swap")
            Text("Swap to \(ScheduleChoice.getName(name: schedule))")
        })
    }
}

let formatter = DateFormatter()

struct HomeView: View {
    
    @State var currentTime = formatter.string(from: Date())
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var timeFromMinutes: Int = 0
    @State var period: Period = Period(startTime: Date(), duration: 0, name: "")
    @State var timeToMinutes: Int = 0

    
    var body: some View {

        ScrollView {
            
            Text("Schedule choice:")
                .padding(.top)
            Text("\(ScheduleChoice.getName(name: ScheduleChoice.scheduleChoice))")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom)
            
            VStack {
                scheduleButton(schedule: "regular_schedule")
                scheduleButton(schedule: "conference_schedule")
                scheduleButton(schedule: "homeroom_schedule")
            }
            
            Text("Don't forget to add the widget!")
                .padding(.top, 20)
            
            Spacer()
            
            Text("Current Period:")
                .padding(.top, 50)
                .multilineTextAlignment(.center)
            // SDFHSFOSJFPSOFJSPOFJSFDPOSDFJOPSFJSDPFOSPDOFJSDFPOSJDFPSODFJSPDFOJ
            Text("Period 3")
                .font(.system(size: 35))
                .bold()
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
                .onReceive(timer) { _ in
                    scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                    self.period = scheduleChoice.getPeriod(Date())
                }
            
            HStack {
                Spacer()
                VStack {
                    Text("Minutes Into:")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,20.0)
                    // SDFHSFOSJFPSOFJSPOFJSFDPOSDFJOPSFJSDPFOSPDOFJSDFPOSJDFPSODFJSPDFOJ
                    Text("10")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,20.0)
                        .onReceive(timer) { _ in
                            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                            let period = scheduleChoice.getPeriod(Date())
                            self.timeFromMinutes = Date().minutes(from: period.startTime)
                        }
                }
                
                
                Spacer()
                
                VStack {
                    Text("Minutes to End:")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,20.0)
                    // SDFHSFOSJFPSOFJSPOFJSFDPOSDFJOPSFJSDPFOSPDOFJSDFPOSJDFPSODFJSPDFOJ
                    Text("34")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,20.0)
                        .onReceive(timer) { _ in
                            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                            let period = scheduleChoice.getPeriod(Date())
                            self.timeToMinutes = Date().minutes(from: period.endTime) * -1
                        }
                }
                Spacer()
            }
            .padding(.bottom, 10)
            // SDFHSFOSJFPSOFJSPOFJSFDPOSDFJOPSFJSDPFOSPDOFJSDFPOSJDFPSODFJSPDFOJ
            Text("9:41:00 AM")
                .bold()
                .font(.system(size: 20))
                .onReceive(timer) { _ in
                    formatter.timeStyle = .medium
                    self.currentTime = formatter.string(from: Date())
                }
            

        
            Text("Created by Paul Serbanescu")
                .padding(.top, 80)
        }
        .padding(20.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
