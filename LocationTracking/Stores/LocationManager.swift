//
//  LocationManager.swift
//  AdTrak
//
//  Created by Naina Ghormare on 2/20/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Polyline
//import AVFoundation
class LocationManager: NSObject {
    
    static let shared                               = LocationManager()
    var allcoordinates          : [CLLocation]      = []
    var currentUserLocation     : CLLocation?
    var timer                   : Timer?
    var timerForStops           : Timer?
    var lastStop                : CLLocation?
    lazy var locationManager    : CLLocationManager = {
        return CLLocationManager()
    }()
    
    var isTrackingStarted: Bool {
        let ongoingTrack        = CoreDataStackManager.sharedManager.getCurrentTrackData()
        return ongoingTrack.count > 0
    }
    
    var totalDistance: Double {
        var distance            = 0.0
        var startLoc            : CLLocation?
        for loc in allcoordinates {
            distance            += (startLoc?.distance(from: loc) ?? 0.0)/1000
            startLoc            = loc
        }
        return distance
    }
    
    //Do all setup of mapview according to your requirement and make delegate to self here.
    func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates    = true
        self.locationManager.distanceFilter                     = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy                    = kCLLocationAccuracyHundredMeters
        self.locationManager.activityType                       = .automotiveNavigation
        self.locationManager.delegate                           = self
        
        // save previous coordinates
        self.allcoordinates             = getCordinatesFromLocalDB()
        self.timer                      = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { (timer) in
            if self.isTrackingStarted {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NSNotification.Name.Updatecoordinates"), object: nil)
            }
        })
        var stops                       : Int?
        var pastDistance                = self.totalDistance
        self.timerForStops              = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true, block: { (timer) in
            let ongoingTrack            = CoreDataStackManager.sharedManager.getCurrentTrackData()
            if self.isTrackingStarted {
                let diffDistance        = self.totalDistance - pastDistance
                let lastStopDiff        = self.lastStop?.distance(from: LocationManager.shared.allcoordinates.last ?? CLLocation(latitude: 0.0, longitude: 0.0))
                if diffDistance <= 0.050 {
                    if (lastStopDiff ?? 0/1000) > 0.010 || (self.allcoordinates.last == nil && ongoingTrack[0].noOfStops == "0") {
                        if ongoingTrack[0].noOfStops == "0" {
                            stops       = 1
                        } else {
                            stops       = (stops ?? 0)+1
                        }
                        self.lastStop   = self.allcoordinates.last ?? CLLocation(latitude: 0.0, longitude: 0.0)
                    }
                }
                pastDistance            = self.totalDistance
                if stops != nil {
                    for jobs in ongoingTrack {
                        jobs.noOfStops  = "\(String(describing: stops!))"
                        jobs.save()
                    }
                }
            }
        })
    }
    
    //While starting the tracking make setup here for updating location.
    func startManager() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startMonitoringSignificantLocationChanges()
                self.locationManager.startUpdatingLocation()
            }
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    //In stopManager stop the services you dont require after stoping the tracking.
    func stopManager() {
        //        self.locationManager.stopUpdatingLocation()
        //        self.locationManager.stopMonitoringSignificantLocationChanges()
        self.locationManager.showsBackgroundLocationIndicator   = false
    }
    
    //MARK: Location Permission in foreground
    func checklocationenable() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
                print("when in used",CLLocationManager.authorizationStatus())
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationPermission") , object: nil)
                return false
            case .authorizedAlways:
                print("always in used",CLLocationManager.authorizationStatus())
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocationPermission") , object: nil)
                return true
            }
        } else {
            return false
        }
        
    }
    
    //If you are saving the coordintes in coreData then retrieve cordinates from stored string of polyline.
    func getCordinatesFromLocalDB() -> [CLLocation] {
        var returnArray                 = [CLLocation]()
        let ongoingTrack                = CoreDataStackManager.sharedManager.getCurrentTrackData()
        if self.isTrackingStarted {
            let decodedCoordinates      : Array<CLLocationCoordinate2D> = decodePolyline(ongoingTrack[0].polyline ?? "", precision: 1e5) ?? [CLLocationCoordinate2D]()
            for cordinates in decodedCoordinates {
                let getLat              : CLLocationDegrees = cordinates.latitude
                let getLon              : CLLocationDegrees = cordinates.longitude
                let getLatLon           : CLLocation        = CLLocation(latitude: getLat, longitude: getLon)
                returnArray.append(getLatLon)
            }
        }
        return returnArray
    }
    
    //Save all your tracking data (ids, coordintes, path) in coredata
    func saveLocation(location: CLLocation) {
        let ongoingTrack                = CoreDataStackManager.sharedManager.getCurrentTrackData()
        let distance                    = (self.allcoordinates.last)?.distance(from: location) ?? 0.0
        let km                          = distance/1000
        if km <= 1.0 {
            self.allcoordinates.append(location)
            for jobs in ongoingTrack {
                let polyline            = Polyline(locations: self.allcoordinates)
                let encodedPolyline     = polyline.encodedPolyline
                jobs.polyline           = encodedPolyline
                jobs.distance           = self.totalDistance
                jobs.long               = self.allcoordinates.last?.coordinate.longitude
                jobs.lat                = self.allcoordinates.last?.coordinate.latitude
                jobs.save()
            }
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: CLLocationManagerDelegate methods
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("User denied for Location Service")
        case .authorizedAlways:
            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            print("Successfully Authorized for Location Service")
        case .authorizedWhenInUse:
            print("Limited Location Service Authorized")
        default:
            print("Something went wrong with Location Service")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            print("L: 196 Something went wrong with Location Service\(error.localizedDescription)")
            manager.stopMonitoringSignificantLocationChanges()
            return
        }
        print("L: 200 Something went wrong with Location Service\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //Save the location from here.
            self.currentUserLocation = location
            if self.isTrackingStarted && location.horizontalAccuracy > 0.0 && location.horizontalAccuracy < 20.0 {
                self.saveLocation(location: location)
            }
           // AudioServicesPlaySystemSound(1054); // For testing of background location updates...
            print("location has been updated...")
            if self.isTrackingStarted {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NSNotification.Name.Updatecoordinates"), object: nil)
            }
            //Fire notification to controller where you want to show GMSCameraPosition and draw live path.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NSNotification.Name.UpdateLocation"), object: nil)
        }
    }
}

