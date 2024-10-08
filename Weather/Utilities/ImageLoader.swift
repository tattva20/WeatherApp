//
//  ImageLoader.swift
//  Weather
//
//  Created by Octavio Rojas on 10/7/24.
//

import SwiftUI
import Combine

// Class to asynchronously load images from URLs with caching
class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var url: URL?
    // Static cache shared among all instances
    private static let cache = NSCache<NSURL, UIImage>()
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
        loadImage()
    }

    deinit {
        // Cancel the network request if the instance is deallocated
        cancellable?.cancel()
    }

    // Function to load the image from the URL
    func loadImage() {
         guard let url = url else {
             return
         }

         // Check if the image is already cached
         if let cachedImage = ImageLoader.cache.object(forKey: url as NSURL) {
             self.image = cachedImage
             return
         }

         // Fetch the image data asynchronously
         cancellable = URLSession.shared.dataTaskPublisher(for: url)
             .tryMap { result -> UIImage? in
                 // Convert data to UIImage
                 guard let image = UIImage(data: result.data) else {
                     throw URLError(.badServerResponse)
                 }
                 return image
             }
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { [weak self] completion in
                 if case .failure = completion {
                     // Handle errors by setting image to nil
                     self?.image = nil
                 }
             }, receiveValue: { [weak self] image in
                 guard let self = self, let image = image else { return }
                 // Cache the image for future use
                 ImageLoader.cache.setObject(image, forKey: url as NSURL)
                 self.image = image
             })
     }
}
