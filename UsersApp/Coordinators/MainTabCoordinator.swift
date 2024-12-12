import UIKit

class MainTabCoordinator {
    
    var tabBarController: UITabBarController!
    private var mapCoordinator: MapCoordinator!
    private var usersCoordinator: UsersCoordinator!
    private var childCoordinators: [Coordinator] = []
    
    func start() -> UITabBarController {
        tabBarController = UITabBarController()
        
        let mapNavController = UINavigationController()
        mapCoordinator = MapCoordinator(navigationController: mapNavController)
        mapCoordinator.start()
        mapNavController.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        childCoordinators.append(mapCoordinator) // Retain the coordinator
        
        let usersNavController = UINavigationController()
        usersCoordinator = UsersCoordinator(navigationController: usersNavController)
        usersCoordinator.start()
        usersNavController.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        childCoordinators.append(usersCoordinator) // Retain the coordinator
        
        tabBarController.viewControllers = [mapNavController, usersNavController]
        tabBarController.selectedIndex = 0
        setupTabBarAppearance()
        
        return tabBarController
    }
    
    private func setupTabBarAppearance() {
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
        tabBarController.tabBar.barTintColor = .systemYellow
        tabBarController.tabBar.backgroundColor = .systemYellow
    }
}
