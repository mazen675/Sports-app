//
//  OnBoardingPageViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 28/05/2026.
//

import UIKit

struct OnboardingItem {
    let headline: String
    let subTitle: String
    let image: UIImage?
    let buttonTitle:String
}

class OnBoardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    

    let pagesData: [OnboardingItem] = [
        OnboardingItem(headline: "onboarding_head_1".localized,
                       subTitle: "onboarding_sub_1".localized,
                       image: UIImage(named: "onboarding1"),
                       buttonTitle: "continue_btn".localized),
        
        OnboardingItem(headline: "onboarding_head_2".localized,
                       subTitle: "onboarding_sub_2".localized,
                       image: UIImage(named: "onboarding2"),
                       buttonTitle: "continue_btn".localized),
        
        OnboardingItem(headline: "onboarding_head_3".localized,
                       subTitle: "onboarding_sub_3".localized,
                       image: UIImage(named: "onboarding3"),
                       buttonTitle: "get_started_btn".localized)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstPage = createViewController(at: 0) {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }

    func createViewController(at index: Int) -> OnBoardingViewController? {
        if index < 0 || index >= pagesData.count { return nil }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pageVC = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
            
            pageVC.headlineText = pagesData[index].headline
            pageVC.subTitleText = pagesData[index].subTitle
            pageVC.pageImage = pagesData[index].image
            pageVC.pageIndex = index
            pageVC.buttonTitle = pagesData[index].buttonTitle
            return pageVC
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnBoardingViewController else { return nil }
        let currentIndex = currentVC.pageIndex
        
        if currentIndex == 0 { return nil }
        
        return createViewController(at: currentIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnBoardingViewController else { return nil }
        let currentIndex = currentVC.pageIndex
        
        if currentIndex == pagesData.count - 1 { return nil }
        
        return createViewController(at: currentIndex + 1)
    }

    func goForward(from index: Int) {
        if let nextPage = createViewController(at: index + 1) {
            setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
        }
    }
}
