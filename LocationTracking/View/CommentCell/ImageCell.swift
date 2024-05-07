//
//  ImageCell.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/25/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit

protocol ImageCellDelegate {
    func deleteimage(button : UIButton)
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedimage    : UIImageView!
    @IBOutlet weak var btnselectedimage : UIButton!
    
    var delegate:ImageCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteimagebtntapped(_ sender: UIButton) {
        delegate?.deleteimage(button: sender)
    }
    
}
