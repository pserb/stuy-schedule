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
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
