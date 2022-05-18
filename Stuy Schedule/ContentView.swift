//
//  ContentView.swift
//  Shared
//
//  Created by Paul Serbanescu on 4/14/22.
//

import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

// function returns whether current time is school hours
// -1: before school
// 0: during school
// 1: after school
func schoolHours(_ date: Date) -> Int {
    let startTime = Calendar.current.date(bySettingHour: 7, minute: 59, second: 59, of: date)!
    let endTime = Calendar.current.date(bySettingHour: 15, minute: 35, second: 00, of: date)!
    
    if date <= startTime {
        return -1
    } else if date > startTime && date < endTime {
        return 0
    } else {
        return 1
    }
}

// fucntion generates alternate app icon buttons
@ViewBuilder func generateIconButton(color: String, horizontalPadding: CGFloat) -> some View {
    Button(action: {
            UIApplication.shared.setAlternateIconName(color) { (error) in
                //
            }
        }, label: {
        Text("Swap to \(color)")
                .padding(.horizontal, horizontalPadding)
        Image("\(color.lowercased())")
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .multilineTextAlignment(.trailing)
    })
    .padding()
    .frame(width: UIScreen.screenWidth - 40.0)
    .background(.regularMaterial)
}

struct ContentView: View {
    
    @State var date = Date()
    @State var regularSchedule = RegularSchedule()
    @State var schoolTime = schoolHours(Date())
    
    var body: some View {
        
        ScrollView {
        
            VStack {
                Text("Don't forget to add the widget!")
                    .padding()
                
                if schoolTime == -1 || schoolTime == 0 {
                    let todayData = regularSchedule.getBlock(date)
                    let aOrAn = regularSchedule.aOrAn(todayData[0])
                    
                    if todayData[0] == "N/A" {
                        Text("No School Today")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Today is \(aOrAn) \(todayData[0]) day with \(todayData[1])")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                } else if schoolTime == 1 {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    let tomorrowData = regularSchedule.getBlock(tomorrow)
                    let aOrAnTomorrow = regularSchedule.aOrAn(tomorrowData[0])
                    
                    if tomorrowData[0] == "N/A" {
                        Text("No School Tomorrow")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Tomorrow is \(aOrAnTomorrow) \(tomorrowData[0]) day with \(tomorrowData[1])")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        
            Text("Alternate App Icons: ")
                .fontWeight(.bold)
                .font(.system(size: 25.0))
                .padding(.top, 10.0)
                .padding(.bottom, 5.0)
                .multilineTextAlignment(.center)
            
            // icon picker

            // blue is a special case
            Button(action: {
                    UIApplication.shared.setAlternateIconName("BlueAlt") { (error) in
                        //
                    }
                }, label: {
                Text("Swap to blue")
                        .padding(.horizontal, 57.0)
                Image("blue")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                        .multilineTextAlignment(.trailing)
                })
            .padding()
            .frame(width: UIScreen.screenWidth - 40.0)
            .background(.regularMaterial)
            
            generateIconButton(color: "Dark", horizontalPadding: 56.0)
            generateIconButton(color: "Red", horizontalPadding: 59.0)
            generateIconButton(color: "Green", horizontalPadding: 50.0)
        }
        .padding(20.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
