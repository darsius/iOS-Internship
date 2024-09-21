import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var users: [User] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = .systemYellow
        
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10000000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        fetchUsers()
    }
    
    private func fetchUsers() {
        UsersManager.shared.getUsers { [weak self] users in
            self?.displayPins(users: users)
            self?.users = users
            print(users.count)
        }
    }
    
    private func displayPins(users: [User]) {
        for user in users {
            let annotation = UserAnnotation(user: user)
            mapView.addAnnotation(annotation)
            
        }
    }
    
    private func makeDetailsViewController(for user: User) -> UserDetailsViewController {
        let detailsViewController = UserDetailsViewController()
        detailsViewController.user = user

        return detailsViewController
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? UserAnnotation else {
            return nil
        }
        let identifier = "userPin"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let detailView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
            detailView.backgroundColor = .brown
            view.detailCalloutAccessoryView = detailView
            
            if let imageUrl = annotation.userImageURL {
                let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                userImageView.layer.cornerRadius = 20
                userImageView.clipsToBounds = true
                userImageView.image = UIImage(systemName: "person.fill")
                view.leftCalloutAccessoryView = userImageView
            }
            
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? UserAnnotation else {
            return
        }
        let detailsViewController = makeDetailsViewController(for: annotation.user)
        navigationController?.pushViewController(detailsViewController, animated: true)
        print(annotation.user.name.first)
    }
}



