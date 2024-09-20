import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .systemGray
        
        tabBar.barTintColor = .systemYellow
        tabBar.backgroundColor = .systemYellow
        
        let mapViewController = createMapViewController()
        let usersNavController = createUsersNavController()
        
        self.viewControllers = [mapViewController, usersNavController]
    }
    
    private func createUsersNavController() -> UINavigationController {
        let usersViewController = UsersViewController()
        usersViewController.title = "Users"
        
        let navController = UINavigationController(rootViewController: usersViewController)
        navController.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            tag: 1
        )
        return navController
    }
    
    private func createMapViewController() -> UIViewController {
        let mapViewController = MapViewController()
        mapViewController.title = "Users Map"
        let navController = UINavigationController(rootViewController: mapViewController)
        mapViewController.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            tag: 0
        )
        return navController
    }
}
