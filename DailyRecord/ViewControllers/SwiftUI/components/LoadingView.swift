//
//  LoadingView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//

import SwiftUI

struct LoadingView: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "gear")
                        .font(.system(size: 64.0))
                        .rotationEffect(.degrees(isRotating))
                    Spacer()
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1)
                    .speed(0.1).repeatForever(autoreverses: true)) {
                isRotating = 360.0
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
