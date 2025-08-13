//
//  ModuleImageViewModel.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import SwiftUI

@MainActor
class ModuleImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        Task {
            await fetchImage(imageUrl: urlString)
        }
    }
    
    func fetchImage(imageUrl: String) async {
        self.image = await FetchClient.shared.fetchImage(from: imageUrl)
    }
    
    func getImageFromCache(cacheKey: NSString) -> UIImage? {
        print("DEBUG: Getting image from cache")
        return FetchClient.shared.imageCache.object(forKey: cacheKey)
    }
    
    func saveImageToCache(image: UIImage?, cacheKey: NSString) {
        print("DEBUG: Saving image to cache")
        guard let image else {
            print("DEBUG: Could not save image to cache")
            return
        }
        
        FetchClient.shared.imageCache.setObject(image, forKey: cacheKey)
    }
}
