//
//  SettingsView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
            List {
                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .listRowBackground(Color.clear)
                
                SwiftUI.Section {
                    NavigationLink("App Info", destination: InfoView())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("CustomBackground"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
