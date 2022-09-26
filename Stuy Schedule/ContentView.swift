//
//  ContentView.swift
//  Stuy Schedule App
//
//  Created by Paul Serbanescu on 5/25/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem() {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
            
            DetailView()
                .tabItem() {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Details")
                }
            
            
            SettingsView()
                .tabItem() {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
