import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    let user: User
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let imageUrl: String?

    init(user: User) {
        self.user = user
        self.coordinate = CLLocationCoordinate2D(
            latitude: (Double (user.location.coordinates.latitude)!),
            longitude: Double (user.location.coordinates.longitude)!)
        self.title = "\(user.name.first) \(user.name.last)"
        self.imageUrl = user.picture.medium
    }
    
}
