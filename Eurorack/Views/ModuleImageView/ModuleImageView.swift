//
//  ModuleImageView.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import SwiftUI

struct ModuleImageView: View {
    @StateObject var viewModel: ModuleImageViewModel
    
    var urlString: String
    
    init(urlString: String) {
        _viewModel = StateObject(wrappedValue: ModuleImageViewModel(urlString: urlString))
        self.urlString = urlString
    }
    
    var body: some View {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = viewModel.getImageFromCache(cacheKey: cacheKey) {
            Image(uiImage: cachedImage)
                .resizable()
                .scaledToFit()
        } else {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                //TODO: Show placeholder image instead of text
                Text("No image here")
                    .font(.moduleQuiteSmall)
            }
        }
    }
}
