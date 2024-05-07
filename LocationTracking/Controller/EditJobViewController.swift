//
//  EditJobViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/3/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit

class EditJobViewController: BaseViewControler {
    
    @IBOutlet weak var txtjobid             : UITextField!
    @IBOutlet weak var containerview        : UIView!
    
    var jobid               : String        = ""
    var id                  : String        = ""
    var history             : History?
    
    typealias typeCompletionHandler         = (String?) -> ()
    var complition : typeCompletionHandler  = { _  in }
    
    func dismissVCCompletion(_ completionHandler: @escaping typeCompletionHandler) {
        self.complition = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor   = .clear
        self.view.backgroundColor   = UIColor(red: 55.0/255.0, green: 72.0/255.0, blue: 82.0/255.0, alpha: 0.8)
        txtjobid.text               = String((history?.jobId?.dropFirst(2))!)
    }
    
    //MARK:Btn Action
    
    @IBAction func savebtnaction(_ sender: UIButton) {
        guard let txtjob = txtjobid.text, !txtjob.isEmpty else {
            return self.showAlert(with: "JOB_ID".localized)
        }
        if txtjob.trimmingCharacters(in: .whitespaces).isEmpty {
            return self.showAlert(with: "INVALID_JOB_ID".localized)
        }
        let jobid   = txtjob.trimmingCharacters(in: .whitespaces)
        let service = HistoryService()
        service.editJobID(with: (history?.trackid)!, jobid: "JO"+jobid, target: self, complition:{ (message) in
            DispatchQueue.main.async {
                UIAlertController.show(with: "APP_NAME".localized, message: message, preferredStyle: .alert, target: self, actions: [.Ok]) { (action) in
                    switch action {
                    case .Ok:
                        self.complition("JO"+jobid)
                        self.history?.jobId = "JO"+jobid
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                        },completion:{ _ in
                            self.view.removeFromSuperview()
                            self.removeFromParent()
                        })
                    default:
                        print("No Action")
                    }
                }
            }
        })
    }
    
    @IBAction func cancelbtnaction(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}

extension EditJobViewController : UITextFieldDelegate {
    
    private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
}
