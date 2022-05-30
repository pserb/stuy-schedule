//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI
import WidgetKit

//// function returns whether current time is school hours
//// -1: before school
//// 0: during school
//// 1: after school
//func schoolHours(_ date: Date) -> Int {
//    let startTime = Calendar.current.date(bySettingHour: 7, minute: 59, second: 59, of: date)!
//    let endTime = Calendar.current.date(bySettingHour: 15, minute: 35, second: 00, of: date)!
//
//    if date <= startTime {
//        return -1
//    } else if date > startTime && date < endTime {
//        return 0
//    } else {
//        return 1
//    }
//}

struct HomeView: View {
    
    @State var currentTime = Date().formatted(date: .omitted, time: .standard)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var timeFromMinutes: Int = 0
    @State var period: Period = Period(startTime: Date(), duration: 0, name: "")
    @State var timeToMinutes: Int = 0

    @State var scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())

    
    var body: some View {

        ScrollView {
            
            Text("Schedule choice:")
                .padding(.top)
            Text("\(ScheduleChoice.description)")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom)
            
            VStack {
                Button(action: {
                        ScheduleChoice.scheduleChoice = "regular_schedule"
                        scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                    }, label: {
                        Image(systemName: "rectangle.2.swap")
                        Text("Swap to Regular Schedule")
                            .padding(.trailing, 20)
                    })
                .padding()
                .padding(.horizontal, 12)
                .background(.regularMaterial)

                Button(action: {
                        ScheduleChoice.scheduleChoice = "conference_schedule"
                        scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                    }, label: {
                        Image(systemName: "rectangle.2.swap")
                            .padding(.leading, 13)
                        Text("Swap to Conference Schedule")
                    })
                .padding()
                .background(.regularMaterial)
            }
            
            Text("Don't forget to add the widget!")
                .padding(.top, 20)
            
            Spacer()
            
            Text("Current Period:")
                .padding(.top, 50)
                .multilineTextAlignment(.center)
            
            Text("\(period.name)")
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
                    
                    Text("\(timeFromMinutes)")
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
                    
                    Text("\(timeToMinutes)")
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
            
            Text("\(currentTime)")
                .bold()
                .font(.system(size: 20))
                .onReceive(timer) { _ in
                    self.currentTime = Date().formatted(date: .omitted, time: .standard)
                }
            

        
            Text("Created by Paul Serbanescu")
                .padding(.top, 100)
        }
        .padding(20.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
