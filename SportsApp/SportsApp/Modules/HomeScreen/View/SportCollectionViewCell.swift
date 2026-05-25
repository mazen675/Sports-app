import UIKit

class SportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        sportImageView.backgroundColor = .black
        sportImageView.alpha = 0.8
    }

    // The Presenter will call this function to pass the data
    func setupCell(title: String, imageName: String) {
        sportNameLabel.text = title
        
        if let image = UIImage(named: imageName) {
            sportImageView.image = image
            sportImageView.alpha = 1.0
        } else {
            sportImageView.image = UIImage(systemName: "photo.fill")
            sportImageView.tintColor = .lightGray
        }
    }
}
