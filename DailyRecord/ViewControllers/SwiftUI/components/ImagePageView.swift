//
//  ImagePageView.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/26.
//
import Combine
import SwiftUI
import PhotosUI

struct ImagePageView: View {
    @ObservedObject var viewModel: ImageViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(alignment: .trailing) {
            if viewModel.imageUrl.isEmpty {
                HStack {
                    Spacer()
                    PhotosPicker(selection: $viewModel.selectedItems,
                                 matching: .images,
                                 photoLibrary: .shared())
                    {
                        Label("Add", systemImage: "photo")
                            .tint(.white)
                            .labelStyle(.iconOnly)
                    }.padding().tint(.blue)
                }
            }

            if !viewModel.imageUrl.isEmpty {
                TabView {
                    ForEach(viewModel.imageUrl, id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { image in
                            image//.scaledToFit().tag(url)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(url)
                        } placeholder: {
                            Image(systemName: "photo")
                                .tag(url)
                        }
                    }
                }
                .frame(width: screenWidth, height: screenWidth)
                .background(.black.opacity(0.2))
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .tint(.white)
    }
}

struct ImagePageView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePageView(viewModel: ImageViewModel())
            .background(Color("CustomBackground"))
    }
}
