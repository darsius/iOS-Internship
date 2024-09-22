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
            self?.addAnnotations(users: users)
            self?.users = users
        }
    }
    
    private func addAnnotations(users: [User]) {
        let usersAnnotations = users.map { user in
            return UserAnnotation(user: user)
        }
        mapView.addAnnotations(usersAnnotations)
    }
    
    private func createArrowView() -> UIView {
        let arrowView = UIImageView()
        arrowView.frame = CGRect(x: 12, y: 40, width: 15, height: 15)
        arrowView.transform = CGAffineTransform(rotationAngle: .pi)
        arrowView.image = UIImage(systemName: "location.north.fill")
        return arrowView
    }
    
    private func createCustomAnnotationView(with userImageUrl: String?) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = true
        
        let defaultImage = UIImage(systemName: "person.fill")
        
        if let imageUrl = userImageUrl {
            imageView.downloaded(from: imageUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        imageView.image = image
                    case .failure(let error):
                        print(error)
                        imageView.image = defaultImage
                    }
                }
            }
        } else {
            imageView.image = defaultImage
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
        let detailsViewController = ViewControllerHelper
            .makeDetailsViewController(for: annotation.user)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}



