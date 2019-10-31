import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate {

    let mapView = MKMapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.91, longitude: 10.75), latitudinalMeters: 0, longitudinalMeters: 5000), animated: false)
        
    }
}
