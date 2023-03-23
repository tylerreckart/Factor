//
//  LocationManager.swift
//  Factor
//
//  Created by Tyler Reckart on 3/23/23.
//
import Foundation
import CoreLocation
import Combine
import UIKit

public let defaultAuthorizationRequestType = CLAuthorizationStatus.authorizedWhenInUse
public let allowedAuthorizationTypes : Set<CLAuthorizationStatus> = Set([.authorizedWhenInUse])

public class LocationManager: NSObject, ObservableObject {
    
    public let lm = CLLocationManager()
    
    public let locationWillChange = PassthroughSubject<CLLocation, Never>()
    
    @Published public private(set) var location: CLLocation? {
        willSet {
            locationWillChange.send(newValue ?? CLLocation())
        }
    }
    
    @Published public var authorizationStatus: CLAuthorizationStatus?
    
    public var onAuthorizationStatusDenied : ()->Void = {presentLocationSettingsAlert()}
    
    public override init() {
        super.init()
        
        self.lm.delegate = self
        
        self.lm.desiredAccuracy = kCLLocationAccuracyBest
        self.lm.activityType = .fitness
        self.lm.distanceFilter = 10
        self.lm.pausesLocationUpdatesAutomatically = false
        self.lm.showsBackgroundLocationIndicator = true
    }
    
    /**
     Request location access from user.
     
     Per default, `authorizedWhenInUse` is requested.
     In case, the access has already been denied, execute the `onAuthorizationDenied` closure.
     The default behavior is to present an alert that suggests going to the settings page.
     */
    public func requestAuthorization(authorizationRequestType: CLAuthorizationStatus = defaultAuthorizationRequestType) -> Void {
        if self.authorizationStatus == CLAuthorizationStatus.denied {
            onAuthorizationStatusDenied()
        }
        else {
            switch authorizationRequestType {
            case .authorizedWhenInUse:
                self.lm.requestWhenInUseAuthorization()
            case .authorizedAlways:
                self.lm.requestAlwaysAuthorization()
            default:
                print("WARNING: Only `when in use` and `always` types can be requested.")
            }
        }
    }
    
    /// Start the Location Provider.
    public func start() throws -> Void {
        self.requestAuthorization()
        
        if let status = self.authorizationStatus {
            guard allowedAuthorizationTypes.contains(status) else {
                throw LocationManagerError.noAuthorization
            }
        }
        else {
            /// no authorization set by delegate yet
            #if DEBUG
            print(#function, "WARNING: No location authorization status set by delegate yet. Try to start updates anyhow.")
            #endif
            /// In principle, this should throw an error.
            /// However, this would prevent start() from running directly after the LocationManager is initialized.
            /// This is because the delegate method `didChangeAuthorization`,
            /// setting `authorizationStatus` runs only after a brief delay after initialization.
            //throw LocationManagerError.noAuthorization
        }
        self.lm.startUpdatingLocation()
    }
    
    /// Stop the Location Provider.
    public func stop() -> Void {
        self.lm.stopUpdatingLocation()
    }
    
}

/// Present an alert that suggests to go to the app settings screen.
@available(iOSApplicationExtension, unavailable)
public func presentLocationSettingsAlert(alertText : String? = nil) -> Void {
    let alertController = UIAlertController (title: "Enable Location Access", message: alertText ?? "The location access for this app is set to 'never'. Enable location access in the application settings. Go to Settings now?", preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
}


/// Error which is thrown for lacking localization authorization.
public enum LocationManagerError: Error {
    case noAuthorization
}

@available(iOSApplicationExtension, unavailable)
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        #if DEBUG
        print(#function, status.name)
        #endif
        //print()
     
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.lm.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.denied : do {
                print(#function, "Location access denied by user.")
                self.stop()
                self.requestAuthorization()
            }
            case CLError.locationUnknown : print(#function, "Location manager is unable to retrieve a location.")
            default: print(#function, "Location manager failed with unknown CoreLocation error.")
            }
        }
        else {
            print(#function, "Location manager failed with unknown error", error.localizedDescription)
        }
    }
}

extension CLAuthorizationStatus {
    /// String representation of the CLAuthorizationStatus
    var name: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}
