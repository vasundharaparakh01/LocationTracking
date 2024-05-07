//
//  CommentViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/25/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import OpalImagePicker
import KMPlaceholderTextView
import TKImageShowing

class CommentViewController: BaseViewControler {
    
    
    @IBOutlet weak var imglogo              : UIBarButtonItem!
    @IBOutlet weak var txtvwaddcomment      : KMPlaceholderTextView!
    @IBOutlet weak var collectionviewheight : NSLayoutConstraint!
    @IBOutlet weak var btnaddimage          : UIButton!
    @IBOutlet weak var btnsubmit            : UIButton!
    @IBOutlet weak var imagecollectionvw    : UICollectionView!
    
    var history                 : History?
    var imagearray              : [UIImage] = []
    var tkImageVC                           : TKImageShowing?
    var uploadCount                         = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imglogo.image                       = UIImage(named:"smalllogo")!.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialsetup()
    }
    
    func initialsetup() {
        let textAttributes                  = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        collectionviewheight.constant       = imagearray.count != 0 ? 60 : 0
        self.imagecollectionvw.collectionViewLayout.invalidateLayout()
        (imagecollectionvw.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 60, height: 60)
    }
    
    //MARK: Btn Action
    
    @IBAction func addimagebtntapped(_ sender: Any) {
        if self.imagearray.count == 5  {
            return self.showAlert(with: "MAX_IMAGE_PICKER".localized)
        }
        let imagePicker         = UIImagePickerController()
        imagePicker.delegate    = self
        let alertController     = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Select Photo Library
        let photoLibrarySource  = UIAlertAction(title: "PHOTO_LIB".localized, style: UIAlertAction.Style.default) { (alertController) in
            self.multipickerImage()
        }
        //Select Camera
        let cameraSorce         = UIAlertAction(title: "CAMERA".localized, style: UIAlertAction.Style.default) { (alertController) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
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
    
    @IBAction func submitbtntapped(_ sender: Any) {
        guard let txt = txtvwaddcomment.text, !txt.isEmpty else {
            return self.showAlertmsg(with: "COMMENT_TXT".localized)
        }
        var imagegestring = ""
        if  imagearray.count != 0 {
            imagegestring = convertImageToBase64(image: imagearray[uploadCount], with: "data:image/png;base64,")
        }
        commentAPI(with: imagegestring, comtxt: txt)
    }
    
    func commentAPI(with image: String, comtxt: String) {
        let service = HistoryService()
        service.submitComment( with: image, trackid: history?.trackid ?? "", commenttxt: comtxt, target: self, complition:{ (message) in
            DispatchQueue.main.async {
                self.uploadCount = self.uploadCount + 1
                if self.uploadCount < self.imagearray.count {
                    let imagegestring = self.convertImageToBase64(image: self.imagearray[self.uploadCount],with: "data:image/png;base64,")
                    self.commentAPI(with: imagegestring,comtxt:self.txtvwaddcomment.text)
                }
                if ((self.uploadCount == self.imagearray.count) || (self.imagearray.count == 0)) && message != "" {
                    UIAlertController.show(with: "APP_NAME".localized, message: "Comment added successfully.", preferredStyle: .alert, target: self, actions: [.Ok]) { (action) in
                        switch action {
                        case .Ok:
                            self.history?.comment = comtxt
                            self.navigationController?.popViewController(animated: true)
                        default:
                            print("No Action")
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func backbuttonpressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Open Multipicker ImageView
    func multipickerImage() {
        let imagePicker                         = OpalImagePickerController()
        imagePicker.imagePickerDelegate         = self
        imagePicker.maximumSelectionsAllowed    = 5 - imagearray.count
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension CommentViewController: OpalImagePickerControllerDelegate {
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
//        imagearray              = []
        for obj in images {
            guard let cropedimg = (obj.cropImageToSquare()?.resize(toSize: CGSize(width: 60, height: 60))) else {
                return
            }
            imagearray.append(cropedimg)
        }
        tkImageVC               = TKImageShowing()
        tkImageVC?.images.removeAll()
        tkImageVC?.images       = imagearray.toTKImageSource()
        presentedViewController?.dismiss(animated: true, completion: nil)
        imagecollectionvw.reloadData()
    }
}

extension CommentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagearray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                    = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.selectedimage.image    = imagearray[indexPath.row]
        cell.btnselectedimage.tag   = indexPath.row
        cell.delegate               = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell                        = collectionView.cellForItem(at: indexPath) as! ImageCell
        self.tkImageVC?.animatedView    = cell.selectedimage
        self.tkImageVC?.currentIndex    = indexPath.row
        self.present(self.tkImageVC!, animated: true, completion: nil)
    }
}

extension CommentViewController: ImageCellDelegate {
    
    func deleteimage(button : UIButton) {
        imagearray.remove(at: button.tag)
        tkImageVC                       = TKImageShowing()
        tkImageVC?.images               = imagearray.toTKImageSource()
        imagecollectionvw.reloadData()
        collectionviewheight.constant   = imagearray.count != 0 ? 60 : 0
    }
    
}

extension CommentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            picker.dismiss(animated: true) {
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            self.multipickerImage()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
