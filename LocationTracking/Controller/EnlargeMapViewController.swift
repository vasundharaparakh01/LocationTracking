//
//  EnlargeMapViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/3/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit

class EnlargeMapViewController: BaseViewControler {
    
    @IBOutlet weak var imglogo  : UIBarButtonItem!
    @IBOutlet weak var usermap  : CustomMapView?
    var mapTimer                : Timer?
    var strokeColor             = Color.pathcolorBlue
    
    //var history: History        = History()
    var coordinatesObj          : [CLLocationCoordinate2D] = []
    var trackerUserId           : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imglogo.image           = UIImage(named:"smalllogo")!.withRenderingMode(.alwaysOriginal)
        setUpMap()
        loadmap()
        setUpTimer()
    }
    
    func setUpTimer() {
        let trackService = TrackinService()
        self.mapTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            trackService.getTrackDetails(trackId: self.trackerUserId, isLoader:false, target: self) { dataObject in
                self.coordinatesObj  = CoordinatesHelper.getCoordinates(coordinates: dataObject.first?.encodedCords)
                self.loadmap()
            }
        })
    }
    
    func setUpMap() {
        usermap?.strokeColor    = Color.linecolor
        usermap?.strokeWidth    = 5.0
    }
    
    func loadmap() {
        usermap?.drawpath(array: coordinatesObj, startMarker: "start_location", endMarker: "end_location", isKilled: false, strokeColor: strokeColor)
    }
    
    //MARK: Btn Action
    
    @IBAction func popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
/* Legacy code...
 var distance : Double = 0
 for i in 0..<history.coordinatearray.count-1 {
 let from = CLLocation(latitude: history.coordinatearray[i].latitude, longitude: history.coordinatearray[i].longitude)
 let to = CLLocation(latitude: history.coordinatearray[i+1].latitude, longitude: history.coordinatearray[i+1].longitude)
 distance += from.distance(from: to)
 }
 print(distance/1000)*/
