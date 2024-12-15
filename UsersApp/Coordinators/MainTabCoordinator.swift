import UIKit

class MainTabCoordinator {
    
    var tabBarController: UITabBarController!
    private var mapCoordinator: MapCoordinator!
    private var usersCoordinator: UsersCoordinator!
    private var childCoordinators: [Coordinator] = []
    
    func start() -> UITabBarController {
        tabBarController = MainTabViewController()
        
        let mapNavController = UINavigationController()
        mapCoordinator = MapCoordinator(navigationController: mapNavController)
        mapCoordinator.start()
        mapNavController.tabBarItem = UITabBarItem(
            title: "Map",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        childCoordinators.append(mapCoordinator)
        
        let usersNavController = UINavigationController()
        usersCoordinator = UsersCoordinator(navigationController: usersNavController)
        usersCoordinator.start()
        usersNavController.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        childCoordinators.append(usersCoordinator)
        
        tabBarController.setViewControllers([mapNavController, usersNavController], animated: false)
        
        return tabBarController
    }
}
