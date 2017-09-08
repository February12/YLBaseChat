//
//  YLAlbumCell.swift
//  YLImagePickerController
//
//  Created by yl on 2017/8/30.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLAlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumName: UILabel!
    
    @IBOutlet weak var albumCount: UILabel!
    
    override func awakeFromNib() {
        albumImageView.contentMode = UIViewContentMode.scaleAspectFill
        albumImageView.clipsToBounds = true
    }
    
}
