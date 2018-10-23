//
//  ETPhotoModel.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 ET. All rights reserved.
//

import UIKit
import Photos

enum ETAssetMediaType: Int {
    case Unknown
    case Image
    case Gif
    case LivePhoto
    case Video
    case Audio
    case NetImage
    case NetVideo
}

class ETAlbumModel: NSObject {
    
    var title: String?
    var count: Int = 0
    var isCameraRoll: Bool = false
    var result: PHFetchResult<PHAsset>?
    //相册第一张图asset对象
    var headImageAsset: PHAsset?
    var models: [ETPhotoModel]?
    var selectedModels: [ETPhotoModel]?
    var selectedCount: Int = 0
    
}

class ETPhotoModel: NSObject {
    
    //asset对象
    var asset: PHAsset?
    //asset类型
    var type: ETAssetMediaType = .Unknown
    //视频时长
    var duration: String?
    //是否被选择
    var isSelected: Bool = false
    //网络/本地 图片url
    var url: URL?
    //图片
    var image: UIImage?
    
    class func model(WithAsset asset: PHAsset, type: ETAssetMediaType, duration: String?) -> ETPhotoModel {
        
        let model = ETPhotoModel()
        model.asset = asset
        model.type = type
        model.duration = duration
        model.isSelected = false
        return model
        
    }

}
