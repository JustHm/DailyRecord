//
//  LoadingView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
        }
        .background(.green)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
