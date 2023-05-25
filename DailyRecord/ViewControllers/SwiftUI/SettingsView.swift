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
            SwiftUI.Section {
                Text("Daily Record")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("\"Write once a day\"")
                    .foregroundColor(.white)
            }
            .listRowSeparatorTint(.white)
            .listRowBackground(Color.clear)
            
            
            SwiftUI.Section {
                Button("App Info") {
                    print("dd")
                }
                
                Button {
                    print("change color")
                } label: {
                    Text("Change background color")
                }

            }
            .listRowBackground(Color.white)
            
            SwiftUI.Section {
                Button("Delete Account") {
                    print("dd")
                }
            }
            .foregroundColor(.red)
            .listRowBackground(Color.white)
        }
        .scrollContentBackground(.hidden)
        .padding()
        .background(Color("CustomBackground"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
