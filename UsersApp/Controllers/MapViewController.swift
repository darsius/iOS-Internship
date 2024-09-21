import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView!
    private var users: [User] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        fetchUsers()
    }
    
    private func fetchUsers() {
        UsersManager.shared.getUsers { [weak self] users in
            self?.users = users
            print(users.count)
        }
    }
    
}


