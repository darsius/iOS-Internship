//
//  ImageExtensions.swift
//  UsersApp
//
//  Created by Dar Dar on 09.11.2023.
//

import UIKit


extension UIImageView {
    func downloaded(from url: String, contentMode mode: ContentMode = .scaleToFill) {
        
        guard let url = URL(string: url) else {
            print("error at the image string url")
            return
        }
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("imagel"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else{
                let defaultImage = UIImage(systemName: "person")
                DispatchQueue.main.async { [weak self] in
                    self?.image = defaultImage
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
