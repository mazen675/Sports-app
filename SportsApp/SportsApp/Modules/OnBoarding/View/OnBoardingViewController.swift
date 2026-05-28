//
//  OnBoardingViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 28/05/2026.
//

import UIKit

class OnBoardingViewController: UIViewController {

    
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBOutlet weak var onBoardingImageView: UIImageView!
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var onBoardingPageControl: UIPageControl!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var pageImage: UIImage?
        var headlineText: String?
        var subTitleText: String?
        var pageIndex: Int = 0
        var buttonTitle : String = "Continue"
    override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor(named: "AppBackground")
        
            onBoardingImageView.image = pageImage
            headlineLabel.text = headlineText
            subLabel.text = subTitleText
            continueButton.setTitle(buttonTitle, for: .normal)
            
            skipButton.isHidden = ( pageIndex == 2 )
            onBoardingPageControl.currentPage = pageIndex
            onBoardingPageControl.preferredIndicatorImage = UIImage(systemName: "circle.fill")
            onBoardingPageControl.setIndicatorImage(UIImage(named: "pill"), forPage: pageIndex)
        }
    
    @IBAction func didSkip(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainAppVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainAppVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    @IBAction func didContinue(_ sender: Any) {
            if pageIndex == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainAppVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = mainAppVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    }
            } else {
                if let managerVC = self.parent as? OnBoardingPageViewController {
                    managerVC.goForward(from: pageIndex)
                }
            }
        }
    
    func updateDots(newPageIndex: Int) {
        onBoardingPageControl.setIndicatorImage(UIImage(systemName: "circle.fill"), forPage: onBoardingPageControl.currentPage)
        
        onBoardingPageControl.currentPage = newPageIndex
        
        onBoardingPageControl.setIndicatorImage(UIImage(systemName: "capsule.fill"), forPage: newPageIndex)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
