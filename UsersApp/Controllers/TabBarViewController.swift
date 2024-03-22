import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
    
    func createUsersNavController() -> UINavigationController {
        let usersViewController = UsersViewController()
        usersViewController.title = "Users"
        usersViewController.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.3"), tag: 1)
        UITabBar.appearance().barTintColor = usersViewController.view.backgroundColor
        
        return UINavigationController(rootViewController: usersViewController)
    }
    
    func createMapNavController() -> UINavigationController {
        let mapViewController = MapViewController()
        mapViewController.title = "Users Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "mappin.circle"), tag: 0)
        
        return UINavigationController(rootViewController: mapViewController)
    }
    
    func createTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        UITabBar.appearance().tintColor = .systemGray
        tabBarController.viewControllers = [createMapNavController(), createUsersNavController()]
        return tabBarController
    }
}
