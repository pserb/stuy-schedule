//
//  DetailView.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 9/8/22.
//

import Foundation
import SwiftUI
import Network
import WidgetKit

struct DetailView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var timeFromMinutes: Int = 0
    @State var period: Period = Period(startTime: Date(), duration: 0, name: "")
    @State var timeToMinutes: Int = 0
    
    @State var today: ParseDay? = nil
    
    @State var APIData = GetAPIData(date: Date())
    @State var APIweekSchedule: [ParseDay]? = nil
    @State var isSchool: Bool = true
    
    @State var currentPeriodText: String = "Current period"
    @State var announcement: String? = nil
    @State public var nextAnnouncement: String? = nil
    
    @ViewBuilder func APIComponent() -> some View {
        Spacer().frame(width: 0, height: 0, alignment: .center)
            .onReceive(timer) { _ in
                updateAPI(override: false)
            }
    }
    
    func updateAPI(override: Bool) {
        UserNetwork.monitor = NWPathMonitor()
        UserNetwork.queue = DispatchQueue(label: "Monitor")
        UserNetwork.monitor.start(queue: UserNetwork.queue)

        UserNetwork.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                UserPrefs.tryAPICall(override: override)
            } else {
                // use local info
            }
        }

        APIData = GetAPIData(date: Date())
        APIweekSchedule = APIData.getWeekSchedule()

        announcement = APIData.getTodayAnnouncement(date: Date())
        nextAnnouncement = APIData.getNextAnnouncement(date: Date())
    }
    
    @ViewBuilder func scheduleTypeComponent() -> some View {
        VStack {
            Text("Today's Schedule")
                .onReceive(timer) { _ in
                    updateCurrentPeriod()
                }
            scheduleTypeComponentHelper()
                .font(.system(size: 24))
        }
    }
    
    @ViewBuilder func scheduleTypeComponentHelper() -> some View {
            if isSchool {
                Text("\(ScheduleChoice.scheduleName)")
                    .bold()
                    .onReceive(timer) { _ in
                        updateScheduleName()
                    }
            } else {
                Text("No School")
                    .bold()
            }

        }
    
    func updateScheduleName() {
        // get today's schedule
        today = APIData.getToday(date: Date())
        if today != nil {
            ScheduleChoice.scheduleName = today!.bell!.scheduleName
        }
    }
    
    func updateCurrentPeriod() {
        // if we have this week's api info
        if (APIweekSchedule != nil) {
            
            let date = Date()
            let calendar = Calendar.current

            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            let currentDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
            
            // get current period (by nature of the API if we dont get a period it is a weekday with no school)
            let currentPeriod: Period? = APIData.getCurrentPeriod(date: currentDate)
            
            if (currentPeriod != nil) {
                self.period = currentPeriod!
                self.isSchool = true
            } else {
                self.isSchool = false
            }
        } else {
            // we don't have API data, use local data
            // parse json according to schedule choice
            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
            self.period = scheduleChoice.getPeriod(Date())
        }
    }
    
    @ViewBuilder func fullSchedule() -> some View {
        let todayTimes: [[String]]? = fullScheduleHelper()
        if todayTimes != nil {
            
            let todayNames: [String] = todayTimes![0]
            let todayStartTimes: [String] = todayTimes![1]
            let todayEndTimes: [String] = todayTimes![2]
            
            if #available(iOS 15.0, *) {
                VStack {
                    ForEach(0..<todayStartTimes.count) { i in
                        VStack {
                            Spacer()
                                .frame(height: 6.0)
                            Text("\(todayNames[i])")
                                .bold()
                                .foregroundColor(highlightColor(currName: todayNames[i]))
                            Text("\(todayStartTimes[i]) - \(todayEndTimes[i])")
                                .foregroundColor(highlightColor(currName: todayNames[i]))
                            Spacer()
                                .frame(height: 6.0)
                        }
                    }
                }
                .frame(width: UIScreen.screenWidth - 70, alignment: .center)
                .padding(.all, 15)
                .padding(.vertical, 10)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func fullScheduleHelper() -> [[String]]? {
        if today != nil {
            if today!.bell != nil {
                
                let date = Date()
                let calendar = Calendar.current

                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)
                
                let currentDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
                
                let daySchedule: [ParsePeriod] = today!.bell!.schedule
                var parsedDay: [Period] = []
                
                for day in daySchedule {
                    parsedDay.append(day.parse(currentDate))
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                
                var dayStartTimes: [String] = []
                var dayEndTimes: [String] = []
                var dayNames: [String] = []
                
                for day in parsedDay {
                    
                    if (day.name.split(separator: " ")[0] != "Before") {
                        dayStartTimes.append(dateFormatter.string(from: day.startTime))
                        dayEndTimes.append(dateFormatter.string(from: day.endTime))
                        dayNames.append(day.name)
                    }
                    
                }
                
                return [dayNames, dayStartTimes, dayEndTimes]
            }
        }
        
        return nil
    }
    
    func highlightColor(currName: String) -> Color {
        if (period.name == currName) {
            return Color.red
        } else {
            return Color.primary
        }
    }
    
    @ViewBuilder func refreshButton() -> some View {
        if #available(iOS 15.0, *) {
            Button(action: {
                updateAPI(override: true)
//                WidgetCenter.shared.reloadAllTimelines()
            }, label: {
                Text("Refresh")
            })
            .padding(.all, 10)
            .padding(.horizontal, 25)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
        } else {
            Button(action: {
                updateAPI(override: true)
//                WidgetCenter.shared.reloadAllTimelines()
            }, label: {
                Text("Refresh")
            })
        }
    }
    
    @ViewBuilder func creditComponent() -> some View {
        if #available(iOS 15.0, *) {
            Text("Created by [Paul Serbanescu](https://github.com/pserb)")
                .padding(.bottom, 20)
        } else {
            Text("Created by Paul Serbanescu")
                .padding(.bottom, 20)
        }
    }

    @ViewBuilder func linkComponent() -> some View {
        if #available(iOS 15.0, *) {
            Button(action: {
                if let url = URL(string: "https://stuy.enschool.org/organization/bell_schedule.pdf") {
                   UIApplication.shared.open(url)
                }
            }, label: {
                Text("View all schedules")
            })
            .padding(.all, 10)
            .padding(.horizontal, 25)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
        }
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 20)
            
            APIComponent()
            
            scheduleTypeComponent()
            
            linkComponent()
            
            if (isSchool) {
                fullSchedule()
            }
            
            // refresh button
            Spacer()
            refreshButton()
            
        }
        .onDisappear(perform: {
            UserNetwork.monitor.cancel()
        })
        .padding(.vertical, 4.0)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
