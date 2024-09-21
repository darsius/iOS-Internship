import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    let user: User
    var coordinate: CLLocationCoordinate2D
    let userImageURL: String?
    let title: String?

    init(user: User) {
        self.user = user
        self.coordinate = CLLocationCoordinate2D(
            latitude: (Double (user.location.coordinates.latitude)!),
            longitude: Double (user.location.coordinates.longitude)!)
        self.userImageURL = user.picture.medium
        self.title = "\(user.name.first) \(user.name.last)"
    }
    
}
