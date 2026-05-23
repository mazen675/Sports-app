import UIKit

extension UIImageView {
    func load(from urlString: String, placeholder: UIImage? = UIImage(systemName: "photo.circle.fill")) {
        self.image = placeholder
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil, let downloadedImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
