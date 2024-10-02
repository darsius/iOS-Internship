import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        fetchUsers()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        view.backgroundColor = .systemYellow
    }
    
    private func fetchUsers() {
        UsersManager.shared.getUsers(on: self) { [weak self] users in
            self?.users = users
            self?.addAnnotations(users: users)
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
        arrowView.image = UIImage(systemName: "location.north.fill")
        arrowView.frame = CGRect(x: 12, y: 40, width: 15, height: 15)
        arrowView.transform = CGAffineTransform(rotationAngle: .pi)
        return arrowView
    }
    
    private func createCustomAnnotationView(for userImageUrl: String?) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let arrowView = createArrowView()
        let imageView = createUserImageView(with: userImageUrl)
        
        containerView.addSubview(arrowView)
        containerView.addSubview(imageView)
        
        return containerView
    }
    
    private func createUserImageView(with userImageUrl: String?) -> UIView {
        
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
                
        return imageView
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let userAnnotation = annotation as? UserAnnotation else {
            return nil
        }
        
        let identifier = "userPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: userAnnotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = userAnnotation
        }
        
        if let annotationView {
            configureAnnotationView(annotationView, with: userAnnotation)
        }
        
        return annotationView
    }
    
    private func configureAnnotationView(_ annotationView: MKAnnotationView, with annotation: UserAnnotation) {
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if let imageUrl = annotation.imageUrl {
            let customView = createCustomAnnotationView(for: imageUrl)
            annotationView.addSubview(customView)
            annotationView.frame = customView.frame
        }
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
