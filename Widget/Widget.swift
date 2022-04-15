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

//extension Date {
//    /// Returns the amount of hours from another date
//    func hours(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
//    }
//    /// Returns the amount of minutes from another date
//    func minutes(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
//    }
//    /// Returns the amount of seconds from another date
//    func seconds(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
//    }
//}

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
        let currentDate = Date()
        var calendar = Calendar.current

        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        let second = calendar.component(.second, from: currentDate)
        
//        let timeTo = regularSchedule.getSchedule()[0]! - Calendar.current.date(bySettingHour: 7, minute: 50, second: 0, of: currentDate)!
        
        for minuteOffset in stride(from: 0, to: 5, by: 1) {
            let entryDate = Calendar.current.date(bySettingHour: hour, minute: minute + minuteOffset, second: 0, of: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        // update timeline every second
        var timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            (timer) in
            
            WidgetCenter.shared.reloadAllTimelines()
//            completion(timeline)
        }
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date
        
//        let timeToHours = date.hours(from: regularSchedule.getSchedule()[0]!)
//        var period: Int = 0
//        let regSchedule = regularSchedule.getSchedule()
//
//        var minTime: Int = date.minutes(from: regSchedule[0]!) * -1
        
//        ForEach(regSchedule) { timeTo in
//            if (
//        }
        
        if (Calendar.current.component(.hour, from: date) > 14) || (Calendar.current.component(.hour, from: date) < 7) {
            VStack {
                Text("Relax.")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
            }
        } else {
            let period = regularSchedule.getPeriod(date)
            
            let title = regularSchedule.getNames()[period]
            let timeToMinutes = date.minutes(from: regularSchedule.getSchedule()[period]!) * -1
            
            VStack {
                Text("\(title)")
                    .padding()
                Text("\(timeToMinutes) min")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Spacer()
            }
            
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
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
