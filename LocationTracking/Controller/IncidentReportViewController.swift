//
//  IncidentReportViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/10/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit
import TKImageShowing
import OpalImagePicker
import KMPlaceholderTextView
import ActionSheetPicker_3_0


class IncidentReportViewController: BaseViewControler {
    
    @IBOutlet weak var imglogo                      : UIBarButtonItem!
    @IBOutlet weak var jobidtableview               : UITableView!
    @IBOutlet weak var collimgvw                    : UICollectionView!
    @IBOutlet weak var imgcollectionvwwheight       : NSLayoutConstraint!
    @IBOutlet weak var btnincident                  : UIButton!
    @IBOutlet weak var btnselectall                 : UIButton!
    @IBOutlet weak var incidentdescp                : KMPlaceholderTextView!
    
    var alltrakid   : [TrackID]                     = []
    var incident    : [Incident]                    = []
    var imagearray  : [UIImage]                     = []
    var tkImageVC                                   = TKImageShowing()
    var selectall   : Bool                          = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alltrakid                              = CoreDataStackManager.sharedManager.getCurrentTrackData()
        imglogo.image                               = UIImage(named: "smalllogo")?.withRenderingMode(.alwaysOriginal)
        btnincident.imageEdgeInsets                 = UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 0)
        incidenttypeAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgcollectionvwwheight.constant             = imagearray.count != 0 ? 60 : 0
        self.collimgvw.collectionViewLayout.invalidateLayout()
        (collimgvw.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 60, height: 60)
    }
    
    //MARK: Btn Action:
    
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectallbtntapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        _ = alltrakid.map { $0.incidentStatus = sender.isSelected }
        jobidtableview.reloadData()
    }
    
    @IBAction func selectincidenttype(_ sender: UIButton) {
        var incidenttype = [String]()
        for (_,obj)in (incident.enumerated()) {
            incidenttype.append(obj.incidenttype ?? "")
        }
        let picker = ActionSheetStringPicker(title: "SELECT".localized, rows: incidenttype, initialSelection: 0, doneBlock:{ picker, indexes, values in
            self.btnincident.setTitle(values as? String, for: .normal)
            self.btnincident.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.setDoneButton(UIBarButtonItem.init(title: "DONE".localized, style: .done, target: self, action: nil))
        picker?.setCancelButton(UIBarButtonItem.init(title: "CANCEL".localized, style: .plain, target: self, action: nil))
        picker?.show()
    }
    
    @IBAction func selectimageincidenttype(_ sender: UIButton) {
        if self.imagearray.count == 5  {
            return self.showAlert(with: "MAX_IMAGE_PICKER".localized)
        }
        let alertController             = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Select Photo Library
        let photoLibrarySource          = UIAlertAction(title: "PHOTO_LIB".localized, style: UIAlertAction.Style.default) { (alertController) in
            self.multipickerimage()
        }
        //Select Camera
        let cameraSorce                 = UIAlertAction(title: "CAMERA".localized, style: UIAlertAction.Style.default) { (alertController) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker         = UIImagePickerController()
                imagePicker.delegate    = self
                imagePicker.sourceType  = .camera
                self.present(imagePicker, animated: true, completion: {
                })
            } else {
                self.showAlert(with: "N0_CAMERA_ALERT".localized)
            }
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel"), style: UIAlertAction.Style.cancel, handler: { (alertController) in
        }))
        alertController.addAction(photoLibrarySource)
        alertController.addAction(cameraSorce)
        alertController.modalPresentationStyle = .popover
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitincidenttype(_ sender: UIButton) {
        
        var imagegestringarray : [String]   = []
        let jobs = alltrakid.filter({$0.incidentStatus == true })
        
        if jobs.count == 0 {
            return showAlert(with: "SELECT_JOB_ID".localized)
        }
        
        guard let incidenttype = btnincident.titleLabel?.text, incidenttype != "INCIDENT_TYPE_TXT".localized else {
            return showAlert(with: "INCIDENT_TYPE".localized)
        }
        
        guard let incident = incidentdescp.text, !incident.isEmpty else {
            return showAlert(with: "INCIDENT_DESCRIPTION".localized)
        }
        
        for image in imagearray {
            let imagegestring  = convertImageToBase64(image: image, with: "data:image/png;base64,")
            if !imagegestring.isEmpty {
                imagegestringarray.append(imagegestring)
            }
        }
        
        var stopJobs            : [Dictionary<String, String>]  = []
        for job in jobs {
            var dict            = Dictionary<String, String>()
            dict["id"]          = job.trackingid
            stopJobs.append(dict)
        }
        
        let service = TrackinService()
        service.sendincidentreport(with: imagegestringarray, incidentdesc: incidentdescp.text ?? "", incidenttyppe: (btnincident.titleLabel?.text ?? ""), trackingid: stopJobs, target: self) { (message) in
            UIAlertController.show(with: "APP_NAME".localized, message: message, preferredStyle: .alert, target: self, actions: [.Ok], handler: { (action) in
                switch action{
                case .Ok:
                    self.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            })
        }
    }
    
    func incidenttypeAPI() {
        let service = TrackinService()
        service.getincidentreport(target: self, complition: { (response) in
            DispatchQueue.main.async {
                if let data = response {
                    self.incident = data
                }
            }
        })
    }
    
    func multipickerimage() {
        let imagePicker                         = OpalImagePickerController()
        imagePicker.imagePickerDelegate         = self
        imagePicker.maximumSelectionsAllowed    = 5 - imagearray.count
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension IncidentReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alltrakid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL_IDENTIFIERS.STOTRAKINGCELL) as! StopTrakingCell
        cell.selectionStyle = .none
        cell.stoptrakingsetupUI(array: alltrakid, indexpath: indexPath, select: btnselectall.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StopTrakingCell, let status = alltrakid[indexPath.row].incidentStatus {
            alltrakid[indexPath.row].incidentStatus = !status
                cell.jobcheckbox.image  = UIImage(named: !status ? "check" : "uncheck")
                let jobs                = alltrakid.filter({$0.incidentStatus == true })
                btnselectall.isSelected = (jobs.count == alltrakid.count)
        }
    }
    
}

extension IncidentReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return imagearray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                        = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.selectedimage.image        = imagearray[indexPath.row]
        cell.btnselectedimage.tag       = indexPath.row
        cell.delegate                   = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell                        = collectionView.cellForItem(at: indexPath) as? ImageCell
        self.tkImageVC.animatedView     = cell?.selectedimage
        self.tkImageVC.currentIndex     = indexPath.row
        self.present(self.tkImageVC, animated: true, completion: nil)
    }
}

extension IncidentReportViewController: ImageCellDelegate {
    
    func deleteimage(button: UIButton) {
        imagearray.remove(at: button.tag)
        tkImageVC           = TKImageShowing()
        tkImageVC.images    = imagearray.toTKImageSource()
        self.imgcollectionvwwheight.constant = self.imagearray.count != 0 ? 60 : 0
        self.collimgvw.reloadData()
    }

}

extension IncidentReportViewController: OpalImagePickerControllerDelegate {
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
       // imagearray = []
        for obj in images {
            guard let cropedimg = (obj.cropImageToSquare()?.resize(toSize: CGSize(width: 60, height: 60))) else {
                return
            }
            imagearray.append(cropedimg)
        }
        tkImageVC = TKImageShowing()
//        tkImageVC.images = images.toTKImageSource()
        tkImageVC.images = imagearray.toTKImageSource()
        presentedViewController?.dismiss(animated: true, completion: nil)
        self.collimgvw.reloadData()
    }
    
}

extension IncidentReportViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension IncidentReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
            picker.dismiss(animated: true)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let err = error {
            let ac = UIAlertController(title: "Save error", message: err.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
            present(ac, animated: true)
        } else {
            self.multipickerimage()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


