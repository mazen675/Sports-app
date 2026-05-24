import UIKit

class SportCollectionViewCell: UICollectionViewCell {

    // Make sure these are connected to your XIB!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Modern UI Styling
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        // Optional: If you didn't add the dark view in the XIB, you can darken the image slightly here
        // so the white text is always readable.
        sportImageView.backgroundColor = .black
        sportImageView.alpha = 0.8
    }

    // The Presenter will call this function to pass the data
    func setupCell(title: String, imageName: String) {
        sportNameLabel.text = title
        
        // Ensure you have images named "football_bg", "basketball_bg", etc., in your Assets.xcassets
        if let image = UIImage(named: imageName) {
            sportImageView.image = image
            sportImageView.alpha = 1.0 // Reset alpha if image exists
        } else {
            // Fallback if the image isn't in Assets yet
            sportImageView.image = UIImage(systemName: "photo.fill")
            sportImageView.tintColor = .lightGray
        }
    }
}
