//
//  InfoView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/18.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        HStack {
            Image(systemName: "pencil.circle")
                .resizable()
                .frame(width: 64.0, height: 64.0)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("16Days")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Sience 2023.06.01")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                print("Action")
            } label: {
                Label("", systemImage: "chevron.right")
            }

        }
        .frame(maxWidth: .infinity, maxHeight: 100.0)
        .padding()
        .background(Color.green)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .previewLayout(.sizeThatFits)
    }
}
