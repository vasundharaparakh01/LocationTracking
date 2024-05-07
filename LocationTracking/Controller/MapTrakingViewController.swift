//
//  MapTrakingViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/14/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Polyline
import AppTrackingTransparency

class MapTrakingViewController: BaseViewControler, GMSMapViewDelegate {
    
    @IBOutlet weak var LocationPermissionLbl: UILabel!
    @IBOutlet weak var jobidheaderview      : UIView!
    @IBOutlet weak var imglogo              : UIBarButtonItem!
    @IBOutlet weak var incidentreport       : UIBarButtonItem!
    @IBOutlet weak var mapview              : CustomMapView!
    @IBOutlet weak var btnstart             : UIButton!
    @IBOutlet weak var tbllocationview      : UITableView!
    @IBOutlet weak var collvwjobid          : UICollectionView!
    
    var endaddressstring    : String        = ""
    var startBtnSelected    : Bool          = false
    var fiveMinInterval     : CLLocation    = CLLocation(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.clear()
        mapview.isMyLocationEnabled         = true
        imglogo.isEnabled                   = false
        imglogo.image                       = UIImage(named: "smalllogo")!.withRenderingMode(.alwaysOriginal)
        self.updateLocation(nil)
//        alwaysAllowCheck(Notification(name: Notification.Name("LocationPermission")))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: NSNotification.Name(rawValue: "NSNotification.Name.UpdateLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatecoordinates), name: NSNotification.Name(rawValue: "NSNotification.Name.Updatecoordinates"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(alwaysAllowCheck(_:)), name: Notification.Name("LocationPermission"), object: nil)
        setimagebasedontracking()
        if !LocationManager.shared.isTrackingStarted {
            UserDefaults.standard.setValue("", forKey: "startloc")
        }
        tbllocationview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func alwaysAllowCheck(_ notification: Notification?) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("when in used1",CLLocationManager.authorizationStatus())
                LocationPermissionLbl.text = "Recommend to turn location permissions to Always allow"
            case .authorizedAlways, .authorizedWhenInUse:
                print("always in used1",CLLocationManager.authorizationStatus())
                LocationPermissionLbl.text = ""
            }
        }
    }
    
    @objc func updateLocation(_ notification: Notification?) {
        if let location = LocationManager.shared.currentUserLocation {
            let camera              = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
            self.mapview.camera     = camera
            if LocationManager.shared.isTrackingStarted {
                DispatchQueue.main.async {
                    if LocationManager.shared.allcoordinates.count > 1 {
                        self.mapview.drawlivepath(userlocation: LocationManager.shared.allcoordinates)
                    }
                }
            } else if btnstart.currentImage?.isEqual(UIImage(named: "Stop")) ?? false {
                UserDefaults.standard.setValue("", forKey: "startloc")
                trackingstopped(endlocaddress: "", all: true)
                tbllocationview.reloadData()
            }
        }
    }
    
    @objc func setimagebasedontracking() {
        let trackingstared          = LocationManager.shared.isTrackingStarted
        incidentreport.image        = LocationManager.shared.isTrackingStarted ? UIImage(named:"alert")?.withRenderingMode(.alwaysOriginal) : UIImage(named:"")
        trackingstared ? btnstart.setImage(UIImage(named: "Stop"), for: .normal) : btnstart.setImage(UIImage(named: "start"), for: .normal)
        jobidheaderview.isHidden    = !trackingstared
        collvwjobid.delegate        = self
        collvwjobid.dataSource      = self
        collvwjobid.reloadData()
    }
    
    //MARK: Update user coordinates every 30 sec to server
    @objc func updatecoordinates(_ notification: Notification?) {
        let ongoingTrack            = CoreDataStackManager.sharedManager.getCurrentTrackData()
        var trackingid              : [Dictionary<String, String>]  = []
        var trackingdict            = Dictionary<String, String>()
        var encodedPolyline         : String?
        for index in (ongoingTrack.enumerated()) {
            trackingdict["id"]      = ongoingTrack[index.offset].trackingid ?? ""
            trackingid.append(trackingdict)
        }
        let polyline                = Polyline(locations: LocationManager.shared.allcoordinates)
        encodedPolyline             = polyline.encodedPolyline
        if trackingid != [] {
            let service = TrackinService()
            service.stopTrackingFromWeb() { (response) in
                if response == "Inactive" {
                    for jobs in CoreDataStackManager.sharedManager.getCurrentTrackData() {
                        CoreDataStackManager.sharedManager.deleteCurrentTrack(trackingid: jobs.trackingid ?? "")
                    }
                    UserDefaults.standard.setValue("", forKey: "startloc")
                    self.trackingstopped(endlocaddress: "", all: true)
                    self.tbllocationview.reloadData()
                }
            }
            if LocationManager.shared.isTrackingStarted {
                service.startTrackingcoordinates(with: trackingid, allcordinates: encodedPolyline ?? "", complition: { (response,message) in
                    DispatchQueue.main.async {
                    }
                })
            }
        }
    }
    
    func starttracking(with address: String) {
        if LocationManager.shared.isTrackingStarted {
            openstoptrackingcontroller()
        } else {
            openstarttrackingcontroller(startlocadress: address)
        }
    }
    
    func openstarttrackingcontroller(startlocadress: String) {
        if !startBtnSelected {
            startBtnSelected            = true
            let storyboard              = UIStoryboard(name: Identifiers.Storyboard.dashboard, bundle: nil)
            let controller              = storyboard.instantiateViewController(withIdentifier: Identifiers.Controler.addjobID) as! AddJobIDViewController
            controller.useraddress      = startlocadress
            self.navigationController?.addChild(controller)
            controller.view?.frame      = (self.navigationController?.view?.frame ?? CGRect(x: 0.0, y: 0.0, width: 200.0, height: 500.0))
            self.navigationController?.view.addSubview((controller.view))
            
            controller.dismissVCCompletion { response, message in
                self.startBtnSelected   = false
                self.setimagebasedontracking()
                if message != "cancelled" {
                    if response == nil {
                        return self.showAlert(with: message ?? "")
                    } else {
                        self.tbllocationview.reloadData()
                    }
                    UIAlertController.show(with: "APP_NAME".localized, message: message, preferredStyle: .alert, target: self, actions: [.Ok], handler: { (action) in
                        switch action {
                        case .Ok:
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.dismiss(animated: false, completion: nil)
                            LocationManager.shared.lastStop = LocationManager.shared.allcoordinates.last ?? CLLocation(latitude: 0.0, longitude: 0.0)
                        default:
                            break
                        }
                    })
                }
            }
        }
    }
    
    func openstoptrackingcontroller() {
        if !startBtnSelected {
            startBtnSelected                = true
            let storyboard                  = UIStoryboard(name: Identifiers.Storyboard.dashboard, bundle: nil)
            let controller                  = storyboard.instantiateViewController(withIdentifier: Identifiers.Controler.stoptracking) as! StopTrackingViewController
            controller.userstartlocation    = LocationManager.shared.allcoordinates.count != 0 ? LocationManager.shared.allcoordinates : [LocationManager.shared.currentUserLocation ?? CLLocation(latitude: 0.0, longitude: 0.0)]
            controller.delegate             = self
            self.navigationController?.addChild(controller)
            controller.view?.frame          = (self.navigationController?.view?.frame ?? CGRect(x: 0.0, y: 0.0, width: 200.0, height: 500.0))
            self.navigationController?.view.addSubview((controller.view)!)
            controller.dismissVCCompletion { response,message in
                self.startBtnSelected       = false
                self.tbllocationview.reloadData()
                self.setimagebasedontracking()
            }
        }
    }
    
    //MARK: Btn Action
    @IBAction func menubuttontapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func opengooglemaps(_ sender: Any) {
        openGoogleMap()
    }
    
    @IBAction func openincidentreportscreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.Controler.incidentreport) as? IncidentReportViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func startlocatinguser(_ sender: UIButton) {
        requestPermission()
    }
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    DispatchQueue.main.async {
                        self.locationTrack()
                    }
                    // Now that we are authorized we can get the IDFA
//                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }else{
            DispatchQueue.main.async {
                self.locationTrack()
            }
        }
    }
    
    func locationTrack(){
        let reachability = Reachability()
        if !(reachability?.isReachable ?? false) {
            return self.showAlert(with: "NO_INTERNET".localized)
        }
        let serviceEnabled = LocationManager.shared.checklocationenable()
        if !serviceEnabled {
            
            UIAlertController.show(with: "APP_NAME".localized, message: "LOCATION_PERMISSION".localized, preferredStyle: .alert, target: self, actions: [.Cancel, .Setting], handler: { (action) in
                switch action {
                case .Setting:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                case .Cancel:
                    self.dismiss(animated: false, completion: nil)
                default:
                    break
                }
            })
        } else {
            LocationManager.shared.startManager()
            if !LocationManager.shared.isTrackingStarted {
                UserDefaults.standard.setValue("", forKey: "startloc")
                self.endaddressstring = ""
                self.tbllocationview.reloadData()
            }
            guard let currentLocation = LocationManager.shared.currentUserLocation else {
                return self.showAlert(with: "Unable to fetch location.")
            }
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(currentLocation, completionHandler:
                {(placemarks, error) in
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks
                    if pm?.count ?? 0 > 0 {
                        var startaddressstring : String = ""
                        let pm = placemarks?[0]
                        if pm?.name != nil {
                            startaddressstring = startaddressstring + (pm?.name ?? "")  + ", "
                        }
                        if pm?.subLocality != nil {
                            startaddressstring = startaddressstring + (pm?.subLocality ?? "") + ", "
                        }
                        if pm?.locality != nil {
                            startaddressstring = startaddressstring + (pm?.locality ?? "") + ", "
                        }
                        if pm?.country != nil {
                            startaddressstring = startaddressstring + (pm?.country ?? "") + ", "
                        }
                        if pm?.postalCode != nil {
                            startaddressstring = startaddressstring + (pm?.postalCode ?? "") + " "
                        }
                        UserDefaults.standard.set(startaddressstring, forKey: "startloc")
                        self.starttracking(with: startaddressstring)
                    }
            })
        }
    }
}

extension MapTrakingViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL_IDENTIFIERS.MAPLOCATIONCELL) as! locationcell
        if indexPath.row == 0 {
            cell.lbllocation.text   = "START_LOCATION".localized + " \(UserDefaults.standard.object(forKey: "startloc") ?? "")"
            cell.imglocation.image  = UIImage(named: "start_location")
        } else{
            cell.lbllocation.text   = "STOP_LOCATION".localized + " \(endaddressstring)"
            cell.imglocation.image  = UIImage(named: "end_location")
        }
        return cell
    }
}

extension MapTrakingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataStackManager.sharedManager.getCurrentTrackData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: TABLE_VIEW_CELL_IDENTIFIERS.JOBIDCOLLECTIONVIEWCELL, for: indexPath) as! JobIDCell
        let ongoingTrack        = CoreDataStackManager.sharedManager.getCurrentTrackData()
        cell.lbljobid.text      = ongoingTrack[indexPath.row].jobId
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label               = UILabel(frame: CGRect.zero)
        let ongoingTrack        = CoreDataStackManager.sharedManager.getCurrentTrackData()
        label.text              = ongoingTrack[indexPath.row].jobId
        label.sizeToFit()
        return CGSize(width: label.frame.width+30.0, height: label.frame.height)
    }
    
}

extension MapTrakingViewController: StopTrackingViewControllerDelegate {
    
    func trackingstopped(endlocaddress: String, all: Bool) {
        self.startBtnSelected   = false
        if all {
            UserDefaults.standard.set(false, forKey: "trackingstarted")
            LocationManager.shared.stopManager()
            mapview.clear()
            LocationManager.shared.allcoordinates = []
            endaddressstring    = endlocaddress
            let indexPath       = IndexPath(item: 1, section: 0)
            self.tbllocationview.reloadRows(at: [indexPath], with: .top)
            setimagebasedontracking()
        } else {
            self.collvwjobid.reloadData()
        }
    }
    
}




