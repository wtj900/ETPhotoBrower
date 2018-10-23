//
//  ETNavigationController.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 ET. All rights reserved.
//

import UIKit
import Photos

class ETNavigationController: UINavigationController {

//    @property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
    
    /**
     是否选择了原图
     */
//    @property (nonatomic, assign) BOOL isSelectOriginalPhoto;
    
    var selectedModels: [ETPhotoModel]?
    
    /**
     相册框架配置
     */
    var configuration: ETPhotoConfiguration = ETPhotoConfiguration()
    
    /**
     点击确定选择照片回调
     */
    var selectImage: (() -> Void)?
    
    /**
     编辑图片后回调
     */
    var selectClipImage: ((UIImage, PHAsset) -> Void)?
    
    /**
     取消block
     */
    var cancel: (() -> Void)?
    
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
