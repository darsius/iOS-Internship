import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow

    private var authCoordinator: AuthCoordinator?
    private var mainTabCoordinator: MainTabCoordinator?

    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }

    func start() {
        presentLoadingViewController()
    }
    
    private func presentLoadingViewController() {
        let loadingVC = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if NetworkMonitor.shared.isConnected && !NetworkMonitor.shared.isExpensive {
                self.handlePostLoading()
            } else {
                loadingVC.onLoadComplete = { [weak self] in
                    guard let self = self else { return }
                    self.handlePostLoading()
                }
                self.window.rootViewController = loadingVC
                self.window.makeKeyAndVisible()
            }
        }
    }
    
    private func handlePostLoading() {
            LoginService.shared.checkLoginState { [weak self] isLoggedIn in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if isLoggedIn {
                        self.showMainFlow()
                    } else {
                        self.showAuthFlow()
                    }
                }
            }
        }

    func showAuthFlow() {
        authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator?.onLoginSuccess = { [weak self] in
            self?.showMainFlow()
        }
        authCoordinator?.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showMainFlow() {
        mainTabCoordinator = MainTabCoordinator()
        let tabBarController = mainTabCoordinator?.start()

        guard let tabBarController = tabBarController else {
            return
        }

        self.window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
