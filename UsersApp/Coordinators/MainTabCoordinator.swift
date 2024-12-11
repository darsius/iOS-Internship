import UIKit

class MainTabCoordinator {
    
    private var tabBarController: UITabBarController!
    private var mapCoordinator: MapCoordinator!
    private var usersCoordinator: UsersCoordinator!
    
    
    func start() -> UITabBarController {
        tabBarController = UITabBarController()
        
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
        tabBarController.tabBar.barTintColor = .systemYellow
        tabBarController.tabBar.backgroundColor = .systemYellow
        
        let mapNavController = UINavigationController()
        mapCoordinator = MapCoordinator(navigationController: mapNavController)
        mapCoordinator.start()
        
        mapNavController.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        
        let usersNavController = UINavigationController()
        usersCoordinator = UsersCoordinator(navigationController: usersNavController)
        usersCoordinator.start()
        
        usersNavController.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        tabBarController.viewControllers = [mapNavController, usersNavController]
        tabBarController.selectedIndex = 0
        
        return tabBarController
    }
}
