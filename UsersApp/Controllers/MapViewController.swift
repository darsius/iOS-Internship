import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let coordinate = CLLocationCoordinate2D(latitude: 40.724, longitude: -74)
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        addCustomPin()
        
        NotificationCenter.default.addObserver(self, selector: #selector(usersFetched), name: Notification.Name("UsersFetchedNotification"), object: nil)
    }

    @objc func usersFetched() {
        let nr = UserData.shared.users.count
        print("u = \(nr)")
    }
    
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Title"
        pin.subtitle = "Subtitle"
        mapView.addAnnotation(pin)
    }
    
    
    private func createAnnotation(user: User) {
        let longitude = Double(user.location.coordinates.longitude)
        let latitude = Double(user.location.coordinates.latitude)
        let annotation = MKPointAnnotation()
        annotation.title = user.name.first
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 40.724, longitude: longitude ?? -74)
        mapView.addAnnotation(annotation)
    }

}






extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let image = UIImage(named: "minge")
        let scaledImage = UIImage(cgImage: image!.cgImage!, scale: 3, orientation: .up)
        annotationView!.image = scaledImage
        annotationView!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        return annotationView
        
    }
}
