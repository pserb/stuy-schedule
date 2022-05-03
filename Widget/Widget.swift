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

        // Generate a timeline consisting of five entries a minute apart, starting from the current date.
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        let currentDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
        
        // 18 hrs
        for minuteOffset in stride(from: 0, to: 60 * 18, by: 1) {
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
        
        let cal = Calendar.current
        let todayData = regularSchedule.getBlock(date)
        let aOrAn = regularSchedule.aOrAn(todayData[0])
        
        // if it is after school, display tomorrow data
        if ((cal.component(.hour, from: date) == 15) && (cal.component(.minute, from: date) >= 35)) ||
            ((cal.component(.hour, from: date) >= 16) && (cal.component(.hour, from: date) <= 24)) {
            
            let tmr = cal.date(byAdding: .day, value: 1, to: date)!
            let tmrData = regularSchedule.getBlock(tmr)
            let aOrAn = regularSchedule.aOrAn(tmrData[0])
            
            if tmrData[0] == "N/A" {
                Text("No School Tomorrow")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            } else {
                Text("Tomorrow is \(aOrAn) \(tmrData[0]) day")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
        }
        // if it is before school, display today data
        else if ((cal.component(.hour, from: date) < 7) && (cal.component(.hour, from: date) >= 0)) {
            
            VStack {
                if todayData[0] == "N/A" {
                    Text("No School Today")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Today is \(aOrAn) \(todayData[0]) day")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
        }
        
        else {
            let period = regularSchedule.getPeriod(date)
            let title = period.name
            let timeToMinutes = date.minutes(from: period.endTime) * -1
            
            if (period.duration <= 5) || (period.duration == 60) {
                VStack {
                    Text("\(title)")
                        .padding(10.0)
                        .font(.system(size: 18))
                    Spacer()
                    Text("\(timeToMinutes)")
                        .foregroundColor(.blue)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Text("\(todayData[0])")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                    Spacer()
                    Spacer()
                }
            } else {
                VStack {
                    Text("\(title)")
                        .padding(10.0)
                        .font(.system(size: 18))
                    Spacer()
                    Text("\(timeToMinutes)")
                        .foregroundColor(.red)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Text("\(todayData[0])")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

struct widgetMediumView : View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date

        let cal = Calendar.current
        
//        let date = cal.date(byAdding: .hour, value: 10, to: Date.now)!
        
        let todayData = regularSchedule.getBlock(date)
        let aOrAn = regularSchedule.aOrAn(todayData[0])
        
        // if it is after school, display tomorrow data
        if ((cal.component(.hour, from: date) == 15) && (cal.component(.minute, from: date) >= 35)) ||
            ((cal.component(.hour, from: date) >= 16) && (cal.component(.hour, from: date) <= 24)) {
            
            let tmr = cal.date(byAdding: .day, value: 1, to: date)!
            let tmrData = regularSchedule.getBlock(tmr)
            let aOrAn = regularSchedule.aOrAn(tmrData[0])
            
            if tmrData[0] == "N/A" {
                Text("No School Tomorrow")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            } else {
                Text("Tomorrow is \(aOrAn) \(tmrData[0]) day with\n \(tmrData[1])")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
        }
        // if it is before school, display today data
        else if ((cal.component(.hour, from: date) < 7) && (cal.component(.hour, from: date) >= 0)) {
            
            VStack {
                if todayData[0] == "N/A" {
                    Text("No School Today")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Today is \(aOrAn) \(todayData[0]) day with \(todayData[1])")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
        }
        
        // otherwise do schedule stuff
        else {
            let period = regularSchedule.getPeriod(date)
            let title = period.name
            let timeToMinutes = date.minutes(from: period.endTime) * -1
            let timeFromMinutes = date.minutes(from: period.startTime)
            
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
                    
                    if (period.duration <= 5) || (period.duration == 60) {
                        Text("\(timeToMinutes)")
                            .foregroundColor(.blue)
                            .font(.system(size: 50))
                            .fontWeight(.bold)

                            .multilineTextAlignment(.center)
                            .padding(.bottom, 6.0)
                            .padding(.leading, 40.0)
                    } else {
                        Text("\(timeToMinutes)")
                            .foregroundColor(.red)
                            .font(.system(size: 50))
                            .fontWeight(.bold)

                            .multilineTextAlignment(.center)
                            .padding(.bottom, 6.0)
                            .padding(.leading, 40.0)
                    }
                }
                Text("\(todayData[0])")
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        // !! //
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                
        }
    }
}
