//
//  ETPhotoBrowserCell.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 ET. All rights reserved.
//

import UIKit

class ETPhotoBrowserCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var cornerRadio: Float = 0.0
    var albumModel: ETAlbumModel? {
        didSet {
            updateContent()
        }
    }
    
    func updateContent() {
        
        guard let album = albumModel else { return }
        
        if (self.cornerRadio > 0) {
            self.headImageView.layer.masksToBounds = true;
            self.headImageView.layer.cornerRadius = CGFloat(self.cornerRadio);
        }
        
        self.titleLabel.text = album.title;
        self.countLabel.text = "(\(album.count))"
        
        guard let asset = album.headImageAsset else { return }
        let size = CGSize(width: GetViewHeight(view: self) * 2.5, height: GetViewHeight(view: self) * 2.5)
        let _ = ETPhotoManager.requestImage(withAsset: asset, size: size) { (image, info) in
            self.headImageView.image = image ?? GetImageWithName(name: "zl_defaultphoto")
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
