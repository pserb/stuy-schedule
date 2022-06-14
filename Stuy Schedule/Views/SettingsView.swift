//
//  SettingsView.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/25/22.
//

import Foundation
import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

// function generates schedule swapping buttons
@ViewBuilder func scheduleButton(schedule: String) -> some View {
    if #available(iOS 15.0, *) {
        Button(action: {
            ScheduleChoice.scheduleChoice = schedule
            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
        }, label: {
            Image(systemName: "rectangle.2.swap")
            Text("Swap to \(ScheduleChoice.getName(name: schedule))")
        })
        .padding(.all, 10)
        .padding(.horizontal, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
    } else {
        Button(action: {
            ScheduleChoice.scheduleChoice = schedule
            scheduleChoice = GetParsedSchedule(jsonName: ScheduleChoice.scheduleChoice, Date())
        }, label: {
            Image(systemName: "rectangle.2.swap")
            Text("Swap to \(ScheduleChoice.getName(name: schedule))")
        })
    }
}

// fucntion generates alternate app icon buttons
@ViewBuilder func generateIconButton(color: String) -> some View {
    if #available(iOS 15.0, *) {
        Button(action: {
            UIApplication.shared.setAlternateIconName(color) { (error) in
                //
            }
        }, label: {
            Spacer()
            Text("Swap to \(color)")
            Spacer()
            Image("\(color.lowercased())")
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .cornerRadius(20)
                .multilineTextAlignment(.trailing)
        })
        .padding()
        .frame(width: UIScreen.screenWidth - 40.0)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
    } else {
        // Fallback on earlier versions
        Button(action: {
            UIApplication.shared.setAlternateIconName(color) { (error) in
                //
            }
        }, label: {
            Spacer()
            Text("Swap to \(color)")
            Spacer()
            Image("\(color.lowercased())")
                .resizable()
                .frame(width: 100.0, height: 100.0)
        })
        .padding()
        .frame(width: UIScreen.screenWidth - 40.0)
    }
}

struct SettingsView: View {
    
    var body: some View {
        
        ScrollView {
        
            Text("Settings")
                .bold()
                .font(.system(size: 40))
                .padding(.top, 20)
            
            //schedule swapper
            VStack {
                Text("Change Schedule:")
                    .font(.system(size: 20))
                    .padding()
                scheduleButton(schedule: "regular_schedule")
                scheduleButton(schedule: "conference_schedule")
                scheduleButton(schedule: "homeroom_schedule")
            }
            .padding(.bottom, 10)
            
            //icon picker
            VStack {
                Text("Alternate App Icons:")
                    .font(.system(size: 20))
                    .padding(.top, 10)
            //blue is a special case
                if #available(iOS 15.0, *) {
                    Button(action: {
                        UIApplication.shared.setAlternateIconName("BlueAlt") { (error) in
                            //
                        }
                    }, label: {
                        Spacer()
                        Text("Swap to blue")
                        Spacer()
                        Image("blue")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                            .cornerRadius(20)
                    })
                    .padding()
                    .frame(width: UIScreen.screenWidth - 40.0)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
                } else {
                    // Fallback on earlier versions
                    Button(action: {
                        UIApplication.shared.setAlternateIconName("BlueAlt") { (error) in
                            //
                        }
                    }, label: {
                        Spacer()
                        Text("Swap to blue")
                        Spacer()
                        Image("blue")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                    })
                    .padding()
                    .frame(width: UIScreen.screenWidth - 40.0)
                }
            
                generateIconButton(color: "Dark")
                generateIconButton(color: "Red")
                generateIconButton(color: "Green")
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
