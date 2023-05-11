//
//  UIImageView+Cache.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Loads an image from a URL, using a placeholder image while the image is loading.
    /// If the image is in the cache, it uses the cached image. If not, it fetches the image,
    /// stores it in the cache, and then updates the image.
    ///
    /// - Parameters:
    ///   - url: The `URL` of the image to load.
    ///   - placeholder: The `UIImage` to display while the image is loading.
    ///   - cache: The `URLCache` to use for caching the image. If no cache is provided, the shared URLCache is used.
    ///
    /// - Returns: Void.
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
