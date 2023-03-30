//
//  UserPrefs.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 6/3/22.
//

import Foundation
import SwiftUI
import Network

// PROD //
let APIURL: String = "https://api-stuyschedule.vercel.app/api/weekly-schedule"
// PROD //

//        let APIURL: String = "https://pserb-web.vercel.app/api/test-schedule"

// method to find the next monday given a day
func findNextMonday(currentDate: Date) -> Date {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    
    var tryDate: Date = currentDate
    
    for _ in 0...7 {
        tryDate = Calendar.current.date(byAdding: .day, value: 1, to: tryDate)!
        
        let dateString: String = formatter.string(from: tryDate)
        let splitDateString = dateString.split(separator: ",")
        let dayOfWeek = splitDateString[0]
        
        if dayOfWeek == "Monday" {
            // convert monday into set time: 3AM on monday
            let returnDate: Date = Calendar.current.date(bySettingHour: 3, minute: 00, second: 00, of: tryDate)!
            return returnDate
        }
    }
    return currentDate
}

// stores API information and the last time it was called
// the API only has to be called once a week#imageLiteral(resourceName: "simulator_screenshot_79603434-5371-4679-88BB-492B5546F0FE.png")
struct UserPrefs {
    
    static var hadFirstAPICall: Bool = false
    
    static var scheduleURL: URL? = nil
    
    // this will be every monday at 3 AM
    static var targetAPIDate: Date = findNextMonday(currentDate: Date())
    
    static var widgetJsonData: ParseWeekSchedule?
    
    static var parseWidgetCalled: Bool = false
    
    // detail view?
    
    static func tryAPICall(override: Bool) {
        if override {
            print("api call overridden")
            targetAPIDate = findNextMonday(currentDate: Date())
            
            getData(from: APIURL)
        } else {
            // if it is monday, or if the user has not made an api call yet
            if (Date().minutes(from: targetAPIDate) >= 0) || !(hadFirstAPICall) {
                hadFirstAPICall = true
                
                // the api call is made, so update the target date
                targetAPIDate = findNextMonday(currentDate: Date())
                
                getData(from: APIURL)
            }
        }
    }
    
    static func getData(from url: String) {
        
        print("get data called")
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            // have data
            writeData(jsonData: data)
                        
        }).resume()
        
    }
    
    static func writeData(jsonData: Data) {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first {
                let pathWithFileName = documentDirectory.appendingPathComponent("weekly-schedule.json")
                print("schedule url written")
                scheduleURL = pathWithFileName
                do {
                    try
                        jsonData.write(to: pathWithFileName)
                    print("json written")
                } catch {
                    // handle error
            }
        }
    }
    
    static func parseData(fileName: String) -> ParseWeekSchedule? {
        if scheduleURL != nil {
            do {
//                print("parsing json")
                let jsonData = try String(contentsOf: scheduleURL!).data(using: .utf8)
                
                let parsedJSON = try! JSONDecoder().decode(ParseWeekSchedule.self, from: jsonData!)
                return parsedJSON
            }
            catch {
                return nil
            }
        }
//        print("schedule url is nil")
        return nil
    }
    
    static func parseWidgetData(date: Date) {
        print("parse widget data called")
        getData(from: APIURL)
    }
    
}

struct UserNetwork {
    static var monitor: NWPathMonitor = NWPathMonitor()
    static var queue: DispatchQueue = DispatchQueue(label: "Monitor")
}
