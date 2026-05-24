import UIKit

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // 1. Add a closure to tell the ViewController when the button is tapped
    var favoriteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 6
        
        leagueImageView.layer.cornerRadius = leagueImageView.frame.height / 2
        leagueImageView.layer.masksToBounds = true
        
        // 2. Fix the Image (Override carat.png) and add the Tap Target!
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .lightGray
        favoriteButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
    }

    // 3. Trigger the action when pressed
    @objc private func heartTapped() {
        favoriteAction?()
    }

    func configure(with league: LeagueModel) {
        leagueNameLabel.text = league.safeLeagueName
        countryNameLabel.text = league.safeCountryName
        leagueImageView.load(from: league.safeLeagueLogo)
    }
}
