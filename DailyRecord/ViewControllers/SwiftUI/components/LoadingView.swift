//
//  LoadingView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    Spacer()
                    Rectangle()
                        .frame(width: 64.0, height: 64.0)
                    Spacer()
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
