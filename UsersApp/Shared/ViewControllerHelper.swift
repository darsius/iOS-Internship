import Foundation

class ViewControllerHelper {
    static func makeDetailsViewController(for user: User) -> UserDetailsViewController {
        let detailsViewController = UserDetailsViewController()
        detailsViewController.user = user
        return detailsViewController
    }
}
