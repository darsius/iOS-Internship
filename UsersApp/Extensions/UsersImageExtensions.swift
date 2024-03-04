import UIKit

extension UIImageView {
    func downloaded(from url: String, contentMode mode: ContentMode = .scaleToFill, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            print("Error: Invalid image URL")
            completion(.failure(ImageDownloadError.invalidUrl))
            return
        }
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(.failure(ImageDownloadError.invalidResponse))
                print("invalid http response when downloading the image")
                return
                }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion(.success(image))
            }
        }.resume()
    }
}

