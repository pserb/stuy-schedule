//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI
import WidgetKit
import Network

var scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
let formatter = DateFormatter()

func isWeekend(date: Date) -> Bool {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    
    let splitDate = formatter.string(from: date).split(separator: ",")
    let dayName = splitDate[0]
    
    if dayName == "Saturday" || dayName == "Sunday" {
        return true
    }
    return false
}

struct HomeView: View {
    
    @State var currentTime = formatter.string(from: Date())
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var timeFromMinutes: Int = 0
    @State var period: Period = Period(startTime: Date(), duration: 0, name: "")
    @State var timeToMinutes: Int = 0
    
    @State var APIData = GetAPIData(date: Date())
    @State var APIweekSchedule: [ParseDay]? = nil
    @State var isSchool: Bool = true
    
    @State var currentPeriodText: String = "Current period"
    @State var announcement: String? = nil
    @State var nextAnnouncement: String? = nil
    
    var body: some View {
        
        ScrollView {
            
            if isSchool {
                if nextAnnouncement != nil {
                    Text("Announcement")
                        .bold()
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                    Text(nextAnnouncement!)
                        .multilineTextAlignment(.center)
                }
            }
            
            Text("Today's Schedule")
                .onReceive(timer) { _ in
                    
                    UserNetwork.monitor = NWPathMonitor()
                    UserNetwork.queue = DispatchQueue(label: "Monitor")
                    UserNetwork.monitor.start(queue: UserNetwork.queue)
                    
                    UserNetwork.monitor.pathUpdateHandler = { path in
                        if path.status == .satisfied {
                            UserPrefs.tryAPICall()
                        } else {
                            // use local info
                        }
                    }
                    
                    APIData = GetAPIData(date: Date())
                    APIweekSchedule = APIData.getWeekSchedule()
                    
                    announcement = APIData.getTodayAnnouncement(date: Date())
                    nextAnnouncement = APIData.getNextAnnouncement(date: Date())
                }
                .padding(.top)
            if isSchool {
                Text("\(ScheduleChoice.getName(name: ScheduleChoice.scheduleChoice))")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.bottom)
                    .onReceive(timer) { _ in
                        // get today's schedule
                        let today = APIData.getToday(date: Date())
                        if today != nil {
                            ScheduleChoice.scheduleChoice = today!.bell
                        }
                    }
            } else {
                Text("No School")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.bottom)
            }
            
//            Text("Don't forget to add the widget!")
//                .padding(.top, 20)
            
            Spacer()
            
            Text("\(currentPeriodText)")
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            
            if !isSchool {
                // if it is the weekend
                if isWeekend(date: Date()) {
                    Text("Have a great weekend!")
                        .font(.system(size: 30))
                        .bold()
                        .padding()
                        .multilineTextAlignment(.center)
                }
                if announcement != nil {
                    Text("Announcement\n\n\(announcement!)")
                        .font(.system(size: 25))
                        .bold()
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }
            
            if isSchool {
                Text("\(period.name)")
                    .font(.system(size: 35))
                    .bold()
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                    .onReceive(timer) { _ in
                        if APIweekSchedule != nil {
                            let currentPeriod: Period? = APIData.getCurrentPeriod(date: Date())
                            if currentPeriod != nil {
                                self.period = currentPeriod!
                                self.isSchool = true
                            } else {
                                currentPeriodText = ""
                                self.isSchool = false
                            }
                        } else {
                            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                            self.period = scheduleChoice.getPeriod(Date())
                        }
                    }
                
                //            if isSchool {
                HStack {
                    Spacer()
                    VStack {
                        Text("Minutes Into")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,20.0)
                        Text("\(timeFromMinutes)")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,20.0)
                            .onReceive(timer) { _ in
                                if APIweekSchedule != nil {
                                    self.timeFromMinutes = Date().minutes(from: period.startTime)
                                } else {
                                    scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                                    let period = scheduleChoice.getPeriod(Date())
                                    self.timeFromMinutes = Date().minutes(from: period.startTime)
                                }
                            }
                    }
                    
                    
                    Spacer()
                    
                    VStack {
                        Text("Minutes to End")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,20.0)
                        Text("\(timeToMinutes)")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,20.0)
                            .onReceive(timer) { _ in
                                if APIweekSchedule != nil {
                                    self.timeToMinutes = Date().minutes(from: period.endTime) * -1 + 1
                                } else {
                                    scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
                                    let period = scheduleChoice.getPeriod(Date())
                                    self.timeToMinutes = Date().minutes(from: period.endTime) * -1 + 1
                                }
                            }
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                
                Text("\(currentTime)")
                    .bold()
                    .font(.system(size: 20))
                    .onReceive(timer) { _ in
                        formatter.timeStyle = .medium
                        self.currentTime = formatter.string(from: Date())
                    }
            }
        }
        .padding(20.0)
        
        .onDisappear(perform: {
            UserNetwork.monitor.cancel()
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
