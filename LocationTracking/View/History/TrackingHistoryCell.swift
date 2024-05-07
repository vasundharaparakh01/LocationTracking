//
//  TrackingHistoryCell.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/24/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import GoogleMaps

protocol TrackingHistoryCellDelegate {
    func commentbuttontapped(index: Int)
    func editbuttontapped(index: Int, cell: TrackingHistoryCell)
    func mapbuttonaction(cell: TrackingHistoryCell, index: Int)
}

class TrackingHistoryCell: UITableViewCell {
    
    @IBOutlet weak var viewcellcontainer: UIView!
    @IBOutlet weak var usermap          : CustomMapView?
    @IBOutlet weak var lbljobid         : UILabel!
    @IBOutlet weak var lblstartdate     : UILabel!
    @IBOutlet weak var btncommit        : UIButton!
    @IBOutlet weak var btnedit          : UIButton!
    @IBOutlet weak var btnmap           : UIButton!
    @IBOutlet weak var lbltotalkm       : UILabel!
    @IBOutlet weak var lblnumofstops    : UILabel!
    @IBOutlet weak var lblduration      : UILabel!
    @IBOutlet weak var lblstartloctime  : UILabel!
    @IBOutlet weak var lblendloctime    : UILabel!
    @IBOutlet weak var lblstartloc      : UILabel!
    @IBOutlet weak var lblendloc        : UILabel!
    @IBOutlet weak var lblTitleOfCard   : UILabel!
    @IBOutlet weak var lblTrackId       : UILabel!
    var delegate:TrackingHistoryCellDelegate?
    var typeOfTracking:UserType = .primary
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(history:History)  {
        lbljobid.text           = "Job Id: " + "\(history.jobId ?? "")"
        if typeOfTracking == .primary {
            btncommit.isHidden  = history.comment != "" ? true : false
        }
        lblstartdate.text       = history.startDate
        lbltotalkm.text         = history.totalkm ?? "0 km"
        lblnumofstops.text      = history.noofstops ?? "0"
        lblduration.text        = history.duration ?? "0 h 0 m"
        lblstartloctime.text    = history.starttime
        lblendloctime.text      = history.endtime
        lblstartloc.text        = history.startlocation
        lblendloc.text          = history.endlocation
        usermap?.strokeColor    = Color.linecolor
        usermap?.strokeWidth    = 5.0
        usermap?.drawpath(array: history.coordinatearray,startMarker: "start_location",endMarker: "end_location", isKilled: false)
        if typeOfTracking == .associate {
            lblTitleOfCard.text = (history.firstname ?? "") + " " + (history.lastname ?? "")
            lblTrackId.text     = "TrackId - " + (history.tIdAssociate ?? "")
            lblstartloctime.text    = history.starttime24HourFormat
            lblendloctime.text      = history.endtime24HourFormat
        }
    }
    
    //MARK: Btn Action
    
    @IBAction func btnmaptapped(_ sender: UIButton) {
        delegate?.mapbuttonaction(cell: self, index: sender.tag)
    }
    
    @IBAction func editbuttontapped(_ sender: UIButton) {
        delegate?.editbuttontapped(index: sender.tag, cell: self)
    }
    
    @IBAction func commentbtntapped(_ sender: UIButton) {
        delegate?.commentbuttontapped(index:sender.tag)
    }
    
}
