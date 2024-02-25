import UIKit

extension UIImageView {
    func downloaded(from url: String, contentMode mode: ContentMode = .scaleToFill, completion: ((Bool) -> Void)? = nil) {
        
        guard let url = URL(string: url) else {
            print("Error: Invalid image URL")
            completion?(false)
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
                let defaultImage = UIImage(systemName: "person.fill")
                DispatchQueue.main.async { [weak self] in
                    self?.image = defaultImage
                    completion?(false)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion?(true)
            }
        }.resume()
    }
}
