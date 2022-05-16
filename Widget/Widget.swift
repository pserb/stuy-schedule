//
//  widget.swift
//  widget
//
//  Created by Paul Serbanescu on 4/14/22.
//

import WidgetKit
import SwiftUI
import Intents

var regularSchedule = RegularSchedule()

// function returns whether current time is school hours
// -1: before school
// 0: during school
// 1: after school
func schoolHours(_ date: Date) -> Int {
    let startTime = Calendar.current.date(bySettingHour: 6, minute: 59, second: 59, of: date)!
    let endTime = Calendar.current.date(bySettingHour: 15, minute: 35, second: 00, of: date)!
    
    if date <= startTime {
        return -1
    } else if date > startTime && date < endTime {
        return 0
    } else {
        return 1
    }
}

// view for before school hours
@ViewBuilder func beforeSchool(_ date: Date, viewSize: String) -> some View {
    let todayData = regularSchedule.getBlock(date)
    let aOrAn = regularSchedule.aOrAn(todayData[0])
    
    if todayData[0] == "N/A" {
        if viewSize == "small" {
            Text("No School Today")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("No School Today")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    } else {
        if viewSize == "small" {
            Text("Today is \(aOrAn) \(todayData[0]) day")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("Today is \(aOrAn) \(todayData[0]) day with \(todayData[1])")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}

// view for school hours
@ViewBuilder func duringSchool(_ date: Date, viewSize: String) -> some View {
    let todayData = regularSchedule.getBlock(date)
    
    // if there is no school today
    if todayData[0] == "N/A" {
        if viewSize == "small" {
            Text("No School Today")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("No School Today")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    } else {
        // there is school
        let period = regularSchedule.getPeriod(date)
        let title = period.name
        let timeToMinutes = date.minutes(from: period.endTime) * -1
        let timeFromMinutes = date.minutes(from: period.startTime)
        
        // if is passing period
        if (period.duration <= 5) || (period.duration == 60) {
            duringSchoolHelper(date, title: title, timeToMinutes: timeToMinutes, timeFromMinutes: timeFromMinutes, block: todayData[0], minuteColor: .blue, viewSize: viewSize)
        } else {
            // is regular period
            duringSchoolHelper(date, title: title, timeToMinutes: timeToMinutes, timeFromMinutes: timeFromMinutes, block: todayData[0], minuteColor: .red, viewSize: viewSize)
        }
    }
}

// helper for duringSchool view, displays entire view
@ViewBuilder func duringSchoolHelper(_ date: Date, title: String, timeToMinutes: Int, timeFromMinutes: Int, block: String, minuteColor: Color, viewSize: String) -> some View {
    if viewSize == "small" {
        VStack {
            Text("\(title)")
                .padding(10.0)
                .font(.system(size: 18))
            Spacer()
            Text("\(timeToMinutes)")
                .foregroundColor(minuteColor)
                .font(.system(size: 50))
                .fontWeight(.bold)
                
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Text("\(block)")
                .fontWeight(.bold)
                .font(.system(size: 16))
            Spacer()
            Spacer()
        }
    } else if viewSize == "medium" {
        VStack {
            Text("\(title)")
                .padding(14.0)
                .padding(.top, 40.0)
                .font(.system(size: 22))
            Spacer()
            HStack {
                Text("\(timeFromMinutes)")
                    .foregroundColor(.green)
                    .font(.system(size: 50))
                    .fontWeight(.bold)

                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6.0)
                    .padding(.trailing, 40.0)
                
                Text("\(timeToMinutes)")
                    .foregroundColor(minuteColor)
                    .font(.system(size: 50))
                    .fontWeight(.bold)

                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6.0)
                    .padding(.leading, 40.0)
            }
            Text("\(block)")
                .fontWeight(.bold)
                .padding(.bottom, 5.0)
                .font(.system(size: 20))
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }

    }
}


// view for after school hours
@ViewBuilder func afterSchool(_ date: Date, viewSize: String) -> some View {
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    let tomorrowData = regularSchedule.getBlock(tomorrow)
    let aOrAn = regularSchedule.aOrAn(tomorrowData[0])
    
    if tomorrowData[0] == "N/A" {
        if viewSize == "small" {
            Text("No School Tomorrow")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("No School Tomorrow")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    } else {
        if viewSize == "small" {
            Text("Tomorrow is \(aOrAn) \(tomorrowData[0]) day")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("Tomorrow is \(aOrAn) \(tomorrowData[0]) day with \(tomorrowData[1])")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        let currentDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
        
        // 18 hrs, ideally 24
        for minuteOffset in stride(from: 0, to: 60 * 24, by: 1) {
            let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct widgetSmallView : View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date
        
        // -1: before
        // 0: during
        // 1: after
        let schoolTime = schoolHours(date)
        
        // if it is before school, display today data
        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "small")
        }
        
        // if it is during school, display school data
        if (schoolTime == 0) {
            duringSchool(date, viewSize: "small")
        }
        
        // if it is after school, display tomorrow data
        if (schoolTime == 1) {
            afterSchool(date, viewSize: "small")
        }
    }
}

struct widgetMediumView : View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date
        
        // -1: before
        // 0: during
        // 1: after
        let schoolTime = schoolHours(date)
        
        // if it is before school, display today data
        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "medium")
        }
        
        // if it is during school, display school data
        if (schoolTime == 0) {
            duringSchool(date, viewSize: "medium")
        }
        
        // if it is after school, display tomorrow data
        if (schoolTime == 1) {
            afterSchool(date, viewSize: "medium")
        }
    }
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family


    // only small and medium are supported (seen in widget struct)
    @ViewBuilder
    var body: some View {
        
        switch family {
        case .systemSmall:
            widgetSmallView(entry: entry)
        case .systemMedium:
            widgetMediumView(entry: entry)
        case .systemLarge:
            Text("Lorge")
        default:
            Text("📮")
        }
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Schedule Widget")
        .description("Displays schedule")
        // !! //
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                
        }
    }
}
