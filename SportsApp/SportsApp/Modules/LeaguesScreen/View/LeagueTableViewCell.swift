import UIKit

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
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
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .black
        favoriteButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
    }

    @objc private func heartTapped() {
        favoriteAction?()
    }

    func configure(with league: LeagueModel,placeHolder:String) {
        leagueNameLabel.text = league.safeLeagueName
        countryNameLabel.text = league.safeCountryName
        leagueImageView.sd_setImage(with: URL(string: league.safeLeagueLogo), placeholderImage: UIImage(named: placeHolder))
    }
}
