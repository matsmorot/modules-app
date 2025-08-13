//
//  ModuleView.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-07.
//

import SwiftUI

struct ModuleView: View {
    @ObservedObject var viewModel: ModuleViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let module = viewModel.module {
                    
                    TitleView(name: module.name, manufacturer: module.manufacturer)
                    Spacer()
                    ViewThatFits {
                        ModuleImageView(urlString: module.imgUrl ?? module.thumbnailUrl)
                            .frame(maxHeight: 500)
                    }
                    Spacer(minLength: 25)
                    CategoryText(categories: module.categories)
                    Spacer(minLength: 25)
                    Text(module.description)
                        .font(.moduleDescription)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.sand)
    }
}
