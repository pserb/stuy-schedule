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
                .multilineTextAlignment(.trailing)
        })
        .padding()
        .frame(width: UIScreen.screenWidth - 40.0)
        .background(.regularMaterial)
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
                    })
                    .padding()
                    .frame(width: UIScreen.screenWidth - 40.0)
                    .background(.regularMaterial)
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
