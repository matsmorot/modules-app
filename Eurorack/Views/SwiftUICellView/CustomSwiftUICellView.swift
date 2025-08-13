//
//  CustomSwiftUICellView.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import SwiftUI

struct CustomSwiftUICellView: View {
    var moduleID: Int
    @StateObject var cellViewModel: ModuleViewModel
    
    init(moduleID: Int) {
        self.moduleID = moduleID
        _cellViewModel = StateObject(wrappedValue: ModuleViewModel(id: moduleID))
    }
    
    var body: some View {
        if let module = cellViewModel.module {
            VStack {
                TitleView(name: module.name, manufacturer: module.manufacturer)
                HStack(alignment: .bottom) {
                    ModuleImageView(urlString: module.thumbnailUrl)
                        .frame(width: 150, height: 220, alignment: .bottom)
                    Spacer()
                    InfoView(width: module.width, price: module.price, categories: module.categories)
                }
                .padding(.all, 16)
                Spacer()
            }
        } else {
            PlaceHolderView()
        }
    }
}

struct TitleView: View {
    var name: String
    var manufacturer: String
    
    var body: some View {
        Text(name)
            .font(.moduleTitle)
            .padding(.top, 16)
        Text(manufacturer)
            .font(.moduleSubtitle)
    }
}

struct InfoView: View {
    var width: String
    var price: String?
    var categories: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(width)
                .font(.moduleDescription)
            Text("MSRP: \(price ?? "unknown")")
                .font(.moduleQuiteSmall)
                .padding(.bottom)
            CategoryText(categories: categories)
        }
    }
}

struct PlaceHolderView: View {
    var body: some View {
        Text("Placeholder")
    }
}

struct ErrorView: View {
    var body: some View {
        Text("ERROR")
            .padding(.all, 10)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(Color.red, ignoresSafeAreaEdges: .top)
            .clipShape(.rect(cornerRadius: 10))
    }
}
