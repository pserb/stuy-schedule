//
//  widget.swift
//  widget
//
//  Created by Paul Serbanescu on 4/14/22.
//

import WidgetKit
import SwiftUI
import Intents

func aOrAn(_ block: String) -> String {
    for char in block {
        if (char == "A") {
            return "an"
        }
    }
    return "a"
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    return dateFormatter.string(from: date)
}

// function returns whether current time is school hours
// -1: before school
// 0: during school
// 1: after school
func schoolHours(_ date: Date, currentPeriod: Period?) -> Int {
    let startTime = Calendar.current.date(bySettingHour: 6, minute: 59, second: 59, of: date)!
    let endTime = Calendar.current.date(bySettingHour: 15, minute: 35, second: 00, of: date)!

    if currentPeriod != nil {
        if date.minutes(from: currentPeriod!.endTime) > 0 {
            return 1
        }
    }

    if date <= startTime {
        return -1
    } else if date > startTime && date < endTime {
        return 0
    } else if date > endTime {
        return 1
    } else {
        return 2
    }
}

// view for before school hours
@ViewBuilder func beforeSchool(_ date: Date, viewSize: String, todayBlock: String?, todayTesting: String?) -> some View {

    if todayBlock == nil {
        if viewSize == "small" {
            Text("No School Today")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
        } else if viewSize == "medium" {
            Text("No School Today")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "accessoryRectangular" {
            Text("No School Today")
                .font(.headline)
        } else if viewSize == "accessoryInline" {
            Text("No School Today")
                .font(.headline)
        }
    } else {
        let aOrAn = aOrAn(todayBlock!)
        if viewSize == "small" {
            Text("Today is \(aOrAn) \(todayBlock!) day")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("Today is \(aOrAn) \(todayBlock!) day with \(todayTesting!)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15.0)
        } else if viewSize == "accessoryRectangular" {
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.headline)
                Text("\(todayBlock!) with \(todayTesting!)")
                    .font(.body)
            }
        } else if viewSize == "accessoryInline" {
            if #available(iOSApplicationExtension 16.0, *) {
                ViewThatFits {
                    Text("\(todayBlock!) \(ScheduleChoice.scheduleName)")
                        .font(.headline)
                }
            }
        }
    }
}

// view for school hours
@ViewBuilder func duringSchool(_ date: Date, viewSize: String, todayBlock: String?, currentPeriod: Period?) -> some View {

    // if there is no school today
    if todayBlock == nil {
        if viewSize == "small" {
            Text("No School Today")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
        } else if viewSize == "medium" {
            Text("No School Today")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "accessoryRectangular" {
            Text("No School Today")
                .font(.headline)
        } else if viewSize == "accessoryInline" {
            Text("No School Today")
                .font(.headline)
        }
    } else {
        // there is school
        let period = currentPeriod!
        let title = period.name
        let timeToMinutes = date.minutes(from: period.endTime) * -1
        let timeFromMinutes = date.minutes(from: period.startTime)

        // if is passing period
        if (period.duration <= 5) || (period.duration == 60) {
            duringSchoolHelper(date, title: title, timeToMinutes: timeToMinutes, timeFromMinutes: timeFromMinutes, block: todayBlock!, minuteColor: .blue, viewSize: viewSize, currentPeriod: period)
        } else {
            // is regular period
            duringSchoolHelper(date, title: title, timeToMinutes: timeToMinutes, timeFromMinutes: timeFromMinutes, block: todayBlock!, minuteColor: .red, viewSize: viewSize, currentPeriod: period)
        }
    }
}

// helper for duringSchool view, displays entire view
@ViewBuilder func duringSchoolHelper(_ date: Date, title: String, timeToMinutes: Int, timeFromMinutes: Int, block: String, minuteColor: Color, viewSize: String, currentPeriod: Period) -> some View {
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
    } else if viewSize == "accessoryRectangular" {
        VStack(alignment: .leading) {
            Text("\(title)")
                .font(.headline)
            Text("\(currentPeriod.startTime, style: .time) - \(currentPeriod.endTime, style: .time)")
                .font(.body)
            Text("\(block)")
                .foregroundColor(.secondary)
        }
    } else if viewSize == "accessoryInline" {
        if #available(iOSApplicationExtension 16.0, *) {
            ViewThatFits {
                Text("\(title) \(Image(systemName: "hourglass")) \(timeToMinutes) min")
                Text("B4\(title.replacingOccurrences(of: "Before", with: "")) \(Image(systemName: "hourglass")) \(timeToMinutes) min")
            }
        }
    }
}


// view for after school hours
@ViewBuilder func afterSchool(_ date: Date, viewSize: String, tomorrowBlock: String?, tomorrowTesting: String?) -> some View {

    if tomorrowBlock == nil {
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
        } else if viewSize == "accessoryRectangular" {
            Text("No School Tomorrow")
                .font(.headline)
        } else if viewSize == "accessoryInline" {
            Text("No School Tomorrow")
                .font(.headline)
        }
    } else {
        let aOrAn = aOrAn(tomorrowBlock!)
        if viewSize == "small" {
            Text("Tomorrow is \(aOrAn) \(tomorrowBlock!) day")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        } else if viewSize == "medium" {
            Text("Tomorrow is \(aOrAn) \(tomorrowBlock!) day with \(tomorrowTesting!)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15.0)
        } else if viewSize == "accessoryRectangular" {
            VStack(alignment: .leading) {
                Text("Tomorrow")
                    .font(.headline)
                Text("\(tomorrowBlock!) with \(tomorrowTesting!)")
                    .font(.body)
            }
        } else if viewSize == "accessoryInline" {
            if #available(iOSApplicationExtension 16.0, *) {
                ViewThatFits {
                    Text("Tomorrow is \(tomorrowBlock!)")
                        .font(.headline)
                }
            }
        }
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
//        print("PLACEHOLDER CALLED")
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        print("GET SNAPSHOT CALLED")
        let entry = SimpleEntry(date: Date(), configuration: configuration, todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        print("GET TIMELINE CALLED! \(context)")
        var entries: [SimpleEntry] = []

        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        _ = calendar.component(.second, from: date)
        
        let currentDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
        
        UserPrefs.parseWidgetData(date: date)
        var APIData = GetAPIData(date: date)

        // make sure API is updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            APIData = GetAPIData(date: date)
        }
        
        var entry = SimpleEntry(date: currentDate, configuration: configuration, todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil)
        
        var beforeSchoolEntry = false
        var noSchoolEntry = false
        var afterSchoolEntry = false
        
        let seconds = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            for minuteOffset in stride(from: 0, to: 60 * 24, by: 1) {
                let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                autoreleasepool {
                    let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                    let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: entryDate)!
                    
                    if APIData.getTodayBlock(date: entryDate) != nil  {
                        let dayState = schoolHours(entryDate, currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                        
                        if dayState == -1 {
                            if beforeSchoolEntry == false {
                                entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: APIData.getToday(date: entryDate), todayBlock: APIData.getTodayBlock(date: entryDate), todayTesting: APIData.getTodayTesting(date: entryDate), tomorrowBlock: APIData.getTodayBlock(date: tomorrowDate), tomorrowTesting: APIData.getTodayTesting(date: tomorrowDate), currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                                beforeSchoolEntry = true
                                entries.append(entry)
                            }
                        } else if dayState == 0 {
                            entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: APIData.getToday(date: entryDate), todayBlock: APIData.getTodayBlock(date: entryDate), todayTesting: APIData.getTodayTesting(date: entryDate), tomorrowBlock: APIData.getTodayBlock(date: tomorrowDate), tomorrowTesting: APIData.getTodayTesting(date: tomorrowDate), currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                            
                            entries.append(entry)
                        } else if dayState == 1 {
                            // after school
                            
                            // if school tmr
                            if APIData.getTodayBlock(date: tomorrowDate) != nil {
                                if afterSchoolEntry == false {
                                    entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: APIData.getToday(date: entryDate), todayBlock: APIData.getTodayBlock(date: entryDate), todayTesting: APIData.getTodayTesting(date: entryDate), tomorrowBlock: APIData.getTodayBlock(date: tomorrowDate), tomorrowTesting: APIData.getTodayTesting(date: tomorrowDate), currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                                    afterSchoolEntry = true
                                    entries.append(entry)
                                }
                            } else {
                                if noSchoolEntry == false {
                                    // make one
                                    entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil)
                                    noSchoolEntry = true
                                    entries.append(entry)
                                }
                            }
                        }
                    } else {
                        let dayState = schoolHours(entryDate, currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                        // block is nil, no school
                        
                        // check if there is school tomorrow
                        if APIData.getTodayBlock(date: tomorrowDate) != nil {
                            if afterSchoolEntry == false && dayState == 1 {
                                entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: APIData.getToday(date: entryDate), todayBlock: APIData.getTodayBlock(date: entryDate), todayTesting: APIData.getTodayTesting(date: entryDate), tomorrowBlock: APIData.getTodayBlock(date: tomorrowDate), tomorrowTesting: APIData.getTodayTesting(date: tomorrowDate), currentPeriod: APIData.getCurrentPeriod(date: entryDate))
                                afterSchoolEntry = true
                                entries.append(entry)
                            }
                        }
                        
                        // if we don't have a no school entry
                        if noSchoolEntry == false {
                            // make one
                            entry = SimpleEntry(date: entryDate, configuration: configuration, todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil)
                            noSchoolEntry = true
                            entries.append(entry)
                        }
                    }
                }
                if entryDate > Calendar.current.date(byAdding: .hour, value: 1, to: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)!)! {
                    break
                }
                
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let todaySchedule: ParseDay?
    let todayBlock: String?
    let todayTesting: String?
    
    let tomorrowBlock: String?
    let tomorrowTesting: String?
    
    let currentPeriod: Period?
}

struct widgetSmallView : View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date

        // -1: before
        // 0: during
        // 1: after
        let schoolTime = schoolHours(date, currentPeriod: entry.currentPeriod)

        // if it is before school, display today data
        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "small", todayBlock: entry.todayBlock, todayTesting: entry.todayTesting)
        }

        // if it is during school, display school data
        if (schoolTime == 0) {
            duringSchool(date, viewSize: "small", todayBlock: entry.todayBlock, currentPeriod: entry.currentPeriod)
        }

        // if it is after school, display tomorrow data
        if (schoolTime == 1) {
            afterSchool(date, viewSize: "small", tomorrowBlock: entry.tomorrowBlock, tomorrowTesting: entry.tomorrowTesting)
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
        let schoolTime = schoolHours(date, currentPeriod: entry.currentPeriod)

        // if it is before school, display today data
        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "medium", todayBlock: entry.todayBlock, todayTesting: entry.todayTesting)
        }

        // if it is during school, display school data
        if (schoolTime == 0) {
            duringSchool(date, viewSize: "medium", todayBlock: entry.todayBlock, currentPeriod: entry.currentPeriod)
        }

        // if it is after school, display tomorrow data
        if (schoolTime == 1) {
            afterSchool(date, viewSize: "medium", tomorrowBlock: entry.tomorrowBlock, tomorrowTesting: entry.tomorrowTesting)
        }
    }
}

struct accessoryRectangularView: View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date

        let schoolTime = schoolHours(date, currentPeriod: entry.currentPeriod)

        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "accessoryRectangular", todayBlock: entry.todayBlock, todayTesting: entry.todayTesting)
        }

        if (schoolTime == 0) {
            duringSchool(date, viewSize: "accessoryRectangular", todayBlock: entry.todayBlock, currentPeriod: entry.currentPeriod)
        }

        if (schoolTime == 1) {
            afterSchool(date, viewSize: "accessoryRectangular", tomorrowBlock: entry.tomorrowBlock, tomorrowTesting: entry.tomorrowTesting)
        }
    }
}

struct accessoryInlineView: View {
    var entry: Provider.Entry

    var body: some View {
        let date = entry.date

        let schoolTime = schoolHours(date, currentPeriod: entry.currentPeriod)

        if (schoolTime == -1) {
            beforeSchool(date, viewSize: "accessoryInline", todayBlock: entry.todayBlock, todayTesting: entry.todayTesting)
        }

        if (schoolTime == 0) {
            duringSchool(date, viewSize: "accessoryInline", todayBlock: entry.todayBlock, currentPeriod: entry.currentPeriod)
        }

        if (schoolTime == 1) {
            afterSchool(date, viewSize: "accessoryInline", tomorrowBlock: entry.tomorrowBlock, tomorrowTesting: entry.tomorrowTesting)
        }
    }
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .systemSmall:
                widgetSmallView(entry: entry)
            case .systemMedium:
                widgetMediumView(entry: entry)
            case .accessoryRectangular:
                accessoryRectangularView(entry: entry)
            case .accessoryInline:
                accessoryInlineView(entry: entry)
            default:
                Text("DefaultView")
            }
        } else {
            switch family {
                case .systemSmall:
                    widgetSmallView(entry: entry)
                case .systemMedium:
                    widgetMediumView(entry: entry)
                default:
                    Text("DefaultView")
            }
        }
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"
    
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                widgetEntryView(entry: entry)
            }
            .configurationDisplayName("Schedule Widget")
            .description("Displays schedule")
            // !! //
            .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline])
        } else {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                widgetEntryView(entry: entry)
            }
            .configurationDisplayName("Schedule Widget")
            .description("Displays schedule")
            // !! //
            .supportedFamilies([.systemSmall, .systemMedium])
        }
    }
}

struct widget_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            if #available(iOSApplicationExtension 16.0, *) {
                widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil))
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            } else {
                widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), todaySchedule: nil, todayBlock: nil, todayTesting: nil, tomorrowBlock: nil, tomorrowTesting: nil, currentPeriod: nil))
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
            }

        }
    }
}
