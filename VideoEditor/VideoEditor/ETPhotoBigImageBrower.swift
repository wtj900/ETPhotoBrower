//
//  ETPhotoBigImageBrower.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/23.
//  Copyright © 2018 ET. All rights reserved.
//

import UIKit
import Photos

class ETPhotoBigImageBrower: UIViewController {

    var photoModels: [ETPhotoModel]?
    var selectIndex: Int = 0
    var canInteractivePop: Bool = false
    
    //点击选择后的图片预览数组，预览相册图片时为 UIImage，预览网络图片时候为UIImage/NSUrl
    var selectPhotos: [AnyObject]?
    /**预览 网络/本地 图片时候是否 隐藏底部工具栏和导航右上角按钮*/
    var hideToolBar: Bool = false
    
    var back: ((_ selectedModels: [ETPhotoModel], _ isOriginal: Bool) -> Void)?
    //预览相册图片回调
    var previewSelectedImage: (([UIImage], [PHAsset]) -> Void)?
    //预览网络图片回调
    var previewNetImage: (([String]) -> Void)?
    //预览 相册/网络 图片时候，点击返回回调
    var cancelPreview: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
