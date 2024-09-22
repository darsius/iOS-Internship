import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = .systemYellow
        
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
    
    private func createArrowView() -> UIView {
        let arrowView = UIImageView()
        arrowView.frame = CGRect(x: 12, y: 40, width: 15, height: 15)
        arrowView.transform = CGAffineTransform(rotationAngle: .pi)
        arrowView.image = UIImage(systemName: "location.north.fill")
        return arrowView
    }
    
    private func createCustomAnnotationView(with imageUrl: String?) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = true
        
        
        if let imageUrl = imageUrl {
            imageView.downloaded(from: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                    let defaultImage = UIImage(systemName: "person.fill")
                    DispatchQueue.main.async {
                        imageView.image = defaultImage
                    }
                }
            }
        }
        let arrowView = createArrowView()
        
        containerView.addSubview(imageView)
        containerView.addSubview(arrowView)
        
        return containerView
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? UserAnnotation else {
            return nil
        }
        
        let identifier = "userPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let imageUrl = annotation.imageUrl {
            let customView = createCustomAnnotationView(with: imageUrl)
            annotationView?.addSubview(customView)
            annotationView?.frame = customView.frame
            
            return annotationView
        }
        
        return annotationView
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



