import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManager() // Singleton instantie
    private var locationManager: CLLocationManager?
    @Published var currentLocation: CLLocation?

    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }

    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error retrieving location: \(error.localizedDescription)")
    }
}
