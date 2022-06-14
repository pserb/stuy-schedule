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
    
    @ViewBuilder func APIComponent() -> some View {
        Spacer().frame(width: 0, height: 0, alignment: .center)
            .onReceive(timer) { _ in
                updateAPI()
            }
    }
    
    func updateAPI() {
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
    
    @ViewBuilder func announcementComponent() -> some View {
        if #available(iOS 15.0, *) {
            // condition: show announcements only when there is one to show
            if (nextAnnouncement != nil) {
                VStack {
                    Text("Announcement")
                        .font(.system(size: 24))
                        .bold()
                        .padding(.vertical, 2)
                    Text(nextAnnouncement!)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 6)
                }
                .frame(width: UIScreen.screenWidth - 70, alignment: .center)
                .padding(.all, 15)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
            }
        } else {
            if (nextAnnouncement != nil) {
                VStack {
                    // condition: show announcements only when there is one to show
                    Text("Announcement")
                        .font(.system(size: 24))
                        .bold()
                        .padding(.vertical, 2)
                    Text(nextAnnouncement!)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 6)
                }
                .frame(width: UIScreen.screenWidth - 70, alignment: .center)
                .padding(.all, 15)
            }
        }
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
            Text("\(ScheduleChoice.getName(name: ScheduleChoice.scheduleChoice))")
                .bold()
                .onReceive(timer) { _ in
                    updateScheduleType()
                }
        } else {
            Text("No School")
                .bold()
        }
    }
    
    func updateScheduleType() {
        // get today's schedule
        let today = APIData.getToday(date: Date())
        if today != nil {
            ScheduleChoice.scheduleChoice = today!.bell
        }
    }
    
    @ViewBuilder func scheduleComponent() -> some View {
        if #available(iOS 15.0, *) {
            VStack {
                currentPeriodSubcomponent()
                    .padding(.bottom, 0.1)
                blockComponent()
                scheduleTimesSubcomponent()
            }
            .frame(width: UIScreen.screenWidth - 70, alignment: .center)
            .padding(.all, 15)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
        } else {
            VStack {
                currentPeriodSubcomponent()
                    .padding(.bottom, 0.1)
                blockComponent()
                scheduleTimesSubcomponent()
            }
            .frame(width: UIScreen.screenWidth - 70, alignment: .center)
            .padding(.all, 15)
            .padding(.vertical, 10)
        }
    }
    
    @ViewBuilder func currentPeriodSubcomponent() -> some View {
        VStack {
            Text("Current Period")
            Text("\(period.name)")
                .font(.system(size: 30))
                .bold()
        }
    }
    
    func updateCurrentPeriod() {
        // if we have this week's api info
        if (APIweekSchedule != nil) {
            // get current period (by nature of the API if we dont get a period it is a weekday with no school)
            let currentPeriod: Period? = APIData.getCurrentPeriod(date: Date())
            
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
    
    @ViewBuilder func scheduleTimesSubcomponent() -> some View {
        HStack {
            Spacer()
            ZStack {
                progressBarInto()
                // minutes into the period
                VStack {
                    Text("Minutes Into")
                    Text("\(timeFromMinutes)")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            ZStack {
                progressBarFrom()
                // minutes till the end of the period
                VStack {
                    Text("Minutes to End")
                    Text("\(timeToMinutes)")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(timeColor())
                }
            }
            
            Spacer()
            
        }
        .onReceive(timer) { _ in
            updateScheduleTimes()
            updateProgressBars()
        }
    }
    
    func updateScheduleTimes() {
        self.timeFromMinutes = Date().minutes(from: period.startTime)
        self.timeToMinutes = Date().minutes(from: period.endTime) * -1 + 1
    }
    
    func timeColor() -> Color {
        let splitName = period.name.split(separator: " ")

        if !(splitName.isEmpty) {
            if (splitName[0] == "Before") {
                return Color.blue
            } else {
                return Color.red
            }
        } else {
            return Color.red
        }
    }
    
    @ViewBuilder func progressBarInto() -> some View {
        let w: CGFloat = 10
        let h: CGFloat = 75
        ZStack(alignment: .leading) {
            Rectangle().frame(width: w, height: h)
                .opacity(0.1)
                .foregroundColor(Color(UIColor.systemGray))

            Rectangle().frame(width: w, height: h * CGFloat(valueTo))
                .foregroundColor(Color(UIColor.systemGreen))
                .frame(width: w, height: h, alignment: .bottom)
                .animation(.linear)
        }
        .cornerRadius(3.5)
        .padding(.trailing, 140)
    }
    
    @ViewBuilder func progressBarFrom() -> some View {
        let w: CGFloat = 10
        let h: CGFloat = 75
        ZStack(alignment: .leading) {
            Rectangle().frame(width: w, height: h)
                .opacity(0.1)
                .foregroundColor(Color(UIColor.systemGray))

            Rectangle().frame(width: w, height: h * CGFloat(valueFrom))
                .foregroundColor(timeColor())
                .frame(width: w, height: h, alignment: .bottom)
                .animation(.linear)
        }
        .cornerRadius(3.5)
        .padding(.leading, 140)
    }
    
    @State var valueTo: Float = 0
    @State var valueFrom: Float = 0
    
    func updateProgressBars() {
        valueTo = Float(timeFromMinutes) / Float(period.duration)
        valueFrom = Float(timeToMinutes) / Float(period.duration)
    }
    
    @State var todayBlock: String = ""
    
    @ViewBuilder func blockComponent() -> some View {
        Text("\(todayBlock)")
            .font(.system(size: 24))
            .bold()
            .padding(.bottom, 5)
            .onReceive(timer) { _ in
                if APIweekSchedule != nil {
                    let block = APIData.getTodayBlock(date: Date())
                    if block != nil {
                        self.todayBlock = APIData.getTodayBlock(date: Date())!
                    } else {
                        self.todayBlock = ""
                    }
                }
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
    
    var body: some View {
        
        // VStack will encompass everything on the home screen and have 5 components
        VStack {

            Spacer()
                .frame(height: 20)
            // comp 0: API updates
            APIComponent()

            // comp 1: announcements
            announcementComponent()
            Spacer()
                .frame(height: 20)

            // comp 2: current schedule type
            scheduleTypeComponent()

            // comp 3: bell schedule
            if (isSchool) {
                scheduleComponent()
            }
            Spacer()
            
            // comp 4: credit
            creditComponent()
        }
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
