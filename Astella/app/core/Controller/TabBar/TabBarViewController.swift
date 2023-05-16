//
//  TabBarViewController.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/2/23.
//

import UIKit


final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }

    
    private func setUpTabs() {
        let eventVc = EventListViewController()
        if let sheet = eventVc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        let profileVc = ProfileViewController(viewModel : ProfileViewModel(user: User.usr))
        let mapVc = LocationTrackingViewController()
        let eventCreateVc = EventCreateViewController()

        eventVc.navigationItem.largeTitleDisplayMode = .automatic
        profileVc.navigationItem.largeTitleDisplayMode = .automatic
        mapVc.navigationItem.largeTitleDisplayMode = .automatic
        eventCreateVc.navigationItem.largeTitleDisplayMode = .never

        let nav1 = UINavigationController(rootViewController: eventVc)
        let nav2 = UINavigationController(rootViewController: profileVc)
        let nav3 = UINavigationController(rootViewController: mapVc)
        let nav4 = UINavigationController(rootViewController: eventCreateVc)

        nav1.tabBarItem = UITabBarItem(title: "Events",
                                       image: UIImage(systemName: "tent.fill"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile",
                                       image: UIImage(systemName: "person"),
                                       tag: 2)
        
        nav3.tabBarItem = UITabBarItem(title: "Map",
                                       image: UIImage(systemName: "globe"),
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Create",
                                       image: UIImage(systemName: "plus.rectangle.fill.on.rectangle.fill"),
                                       tag: 4)
      

        for nav in [nav1, nav2, nav4, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }

        setViewControllers(
            [nav1, nav2, nav4, nav3],
            animated: true
        )
    }
}
