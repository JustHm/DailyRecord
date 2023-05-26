//
//  InfoView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Record")
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Divider().background(.white)
            
            Text("\"Write once a day\"")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.bottom, 16.0)
            Text("""
        asdflka;ja;lsjdfl
        asjdlfk;ajsld;fja
        asjdflk;kjask;djf
        asdlfkj;ajsdf;ja;slkjfd;ajskld
        asjldkf;adj
        asdl;kfajs;ldjfla;sjdl;fj
        
        asl;dkfjla;sjfl;sajd
        """)
            .font(.body)
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color("CustomBackground"))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
