import UIKit

class SportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    private let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }

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
