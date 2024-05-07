//
//  FilterViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/26/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class FilterViewController: BaseViewControler {
    
    @IBOutlet weak var jobID        : UITextField!
    @IBOutlet weak var startdate    : UITextField!
    @IBOutlet weak var enddate      : UITextField!
    @IBOutlet weak var btnstrdate   : UIButton!
    @IBOutlet weak var btnenddate   : UIButton!
    @IBOutlet weak var popupview    : UIView!
    
    typealias typeCompletionHandler = ([History],Int,String,String,String) -> ()
    var complition                  : typeCompletionHandler = { _,_,_,_,_   in }
    
    func dismissVCCompletion(_ completionHandler: @escaping typeCompletionHandler) {
        self.complition             = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor   = .clear
        self.view.backgroundColor   = Color.backgrndColor
        let label                   = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        label.text                  = " JO "
        label.textColor             = .lightGray
        label.font                  = UIFont(name: "Helvetica", size: 20.0)
        jobID.leftView              = label
        jobID.leftViewMode          = UITextField.ViewMode.always
        jobID.addSubview(label)
    }
    
    //MARK: Btn Action
    
    @IBAction func cancelBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        },completion:{ _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        guard let job = jobID.text, let startdate = startdate.text, let enddate = enddate.text, (!job.isEmpty || !startdate.isEmpty || !enddate.isEmpty) else {
            return showAlert(with: "FILTER_MSG".localized)
        }
        filterTrackingHistoryAPI()
    }
    
    @IBAction func btnstarttapped(_ sender: UIButton) {
        openPicker(sender: sender, title: "START_DATE".localized)
    }
    
    @IBAction func btnendtapped(_ sender: UIButton) {
        openPicker(sender: sender, title: "END_DATE".localized)
    }
    
    //MARK: ActionSheet Picker
    func openPicker(sender:UIButton,title:String) {
        let datePicker              = ActionSheetDatePicker(title: title, datePickerMode: UIDatePicker.Mode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            let date                = value as! Date
            let datestring          = TimeUtils.stringFromdate(date, with: "yyyy-MM-dd")
            if sender.tag == 1{
                self.startdate.text = datestring
            }else{
                self.enddate.text   = datestring
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        datePicker?.maximumDate     = Date()
        datePicker?.show()
    }
    
    //MARK: TrackingHistory API
    
    func filterTrackingHistoryAPI() {
        let service = HistoryService()
        service.getHistoryData(with: 1, limit: 5, startdate: startdate.text ?? "", enddate: enddate.text ?? "", jobid: "JO"+(jobID.text ?? ""), target: self, complition: { (response, count) in
            DispatchQueue.main.async {
                if let array = response {
                    self.complition( array, count, self.startdate.text ?? "", self.enddate.text ?? "", self.jobID.text ?? "")
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                    },completion:{ _ in
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                    })
                }
            }
        })
    }
    
}


