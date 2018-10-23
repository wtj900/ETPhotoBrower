//
//  ETPhotoManager.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 ET. All rights reserved.
//

import UIKit
import Photos

class ETPhotoManager: NSObject {

    static var sortAscending = false
    
    // MARK: - 保存数据到相册
    // MARK: -
    // MARK: 保存图片到系统相册
    class func saveImageToAblum(withImage image: UIImage, completion: ((Bool, PHAsset?) -> Void)?) {
        
        if !havePhotoLibraryAuthority() {
            guard let completionBlock = completion else { return }
            completionBlock(false, nil)
            return
        }
        
        var placeholderAsset: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({
            let newAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset
        }) { (success, error) in
            
            if !success {
                guard let completionBlock = completion else { return }
                completionBlock(false, nil)
                return
            }
            
            guard let desCollection = self.getDestinationCollection() else {
                guard let completionBlock = completion else { return }
                completionBlock(false, nil)
                return
            }
            
            guard let asset = self.getAssetFromLocalIdentifier(identifier: placeholderAsset?.localIdentifier) else { return }

            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest(for: desCollection)?.addAssets([asset] as NSArray)
            }, completionHandler: { (success, error) in
                guard let completionBlock = completion else { return }
                completionBlock(success, asset)
            })
            
        }
        
    }

    // MARK: 保存视频到系统相册
    class func saveVideoToAblum(withUrl url: URL, completion: ((Bool, PHAsset?) -> Void)?) {
        
        if !havePhotoLibraryAuthority() {
            guard let completionBlock = completion else { return }
            completionBlock(false, nil)
            return
        }
        
        var placeholderAsset: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({
            let newAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            placeholderAsset = newAssetRequest?.placeholderForCreatedAsset
        }) { (success, error) in
            
            if !success {
                guard let completionBlock = completion else { return }
                completionBlock(false, nil)
                return
            }
            
            guard let desCollection = self.getDestinationCollection() else {
                guard let completionBlock = completion else { return }
                completionBlock(false, nil)
                return
            }
            
            guard let asset = self.getAssetFromLocalIdentifier(identifier: placeholderAsset?.localIdentifier) else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest(for: desCollection)?.addAssets([asset] as NSArray)
            }, completionHandler: { (success, error) in
                guard let completionBlock = completion else { return }
                completionBlock(success, asset)
            })
            
        }
        
    }
    
    class func getAssetFromLocalIdentifier(identifier: String?) -> PHAsset? {
        
        guard let identifierString = identifier, identifierString.isEmpty else {
            print("Cannot get asset from localID because it is nil")
            return nil
        }
        
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [identifierString], options: nil)
        if result.count > 0 {
            return result[0]
        }
        else {
            return nil
        }
        
    }
    
    //获取自定义相册
    class func getDestinationCollection() -> PHAssetCollection? {
        
        var assetCollection: PHAssetCollection?
        
        let collectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        collectionResult.enumerateObjects { (collection, _, _) in
            if collection.localizedTitle == APPName() {
                assetCollection = collection
            }
        }
        
        if assetCollection != nil {
            return assetCollection
        }
        
        var collectionId: String = ""
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: APPName())
                collectionId = request.placeholderForCreatedAssetCollection.localIdentifier
            }
            
            return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionId], options: nil).lastObject
            
        } catch {
            return nil;
        }
        
    }
    
    // MARK: - 相册获取照片、视频等数据相关
    // MARK: -
    // MARK: 根据需求选择数据
    class func getAllAssetInPhotoAlbum(WithAscending ascending: Bool, limit: Int, allowSelectVideo: Bool, allowSelectImage: Bool, allowSelectGif: Bool, allowSelectLivePhoto: Bool) -> [ETPhotoModel] {
        
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
        let result = PHAsset.fetchAssets(with: option)
        
        return getPhotoInResult(result: result, limit: limit, allowSelectVideo: allowSelectVideo, allowSelectImage: allowSelectImage, allowSelectGif: allowSelectGif, allowSelectLivePhoto: allowSelectLivePhoto)
        
    }
    
    class func getPhotoInResult(result: PHFetchResult<PHAsset>, allowSelectVideo: Bool, allowSelectImage: Bool, allowSelectGif: Bool, allowSelectLivePhoto: Bool) -> [ETPhotoModel] {
        return getPhotoInResult(result: result, limit: Int.max, allowSelectVideo: allowSelectVideo, allowSelectImage: allowSelectImage, allowSelectGif: allowSelectGif, allowSelectLivePhoto: allowSelectLivePhoto)
    }
    
    class func getPhotoInResult(result: PHFetchResult<PHAsset>, limit: Int, allowSelectVideo: Bool, allowSelectImage: Bool, allowSelectGif: Bool, allowSelectLivePhoto: Bool) -> [ETPhotoModel] {
        
        var photoData: [ETPhotoModel] = []
        var count: Int = 1
        
        result.enumerateObjects { (obj, idx, stop) in
            
            let mediaType = self.transformAssetType(asset: obj)
            
            if ETAssetMediaType.Image == mediaType && !allowSelectImage {
                return
            }
            if ETAssetMediaType.Gif == mediaType && !allowSelectImage {
                return
            }
            if ETAssetMediaType.LivePhoto == mediaType && !allowSelectImage {
                return
            }
            if ETAssetMediaType.Video == mediaType && !allowSelectVideo {
                return
            }
            
            if count == limit {
                stop.pointee = true
            }
            
            let duration = getDuration(asset: obj)
            photoData.append(ETPhotoModel.model(WithAsset: obj, type: mediaType, duration: duration))
            count += 1
            
        }
        
        return photoData
        
    }
    
    class func getPhotoAblumList(allowSelectVideo: Bool, allowSelectImage: Bool, completion: (([ETAlbumModel]) -> Void)?) {
        
        if (!allowSelectImage && !allowSelectVideo) {
            guard let completionBlock = completion else { return }
            completionBlock([])
            return;
        }
        
        let option = PHFetchOptions()
        if !allowSelectVideo {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        }
        if !allowSelectImage {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
        }
        if !self.sortAscending {
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: self.sortAscending)]
        }
        
        //获取所有智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let streamAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
//        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
        let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
        let allAlbums = [smartAlbums, streamAlbums, syncedAlbums, sharedAlbums];
        
        /**
         PHAssetCollectionSubtypeAlbumRegular         = 2,///
         PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,////
         PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,////面孔
         PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,////
         PHAssetCollectionSubtypeAlbumImported        = 6,////
         
         // PHAssetCollectionTypeAlbum shared subtypes
         PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,///
         PHAssetCollectionSubtypeAlbumCloudShared     = 101,///
         
         // PHAssetCollectionTypeSmartAlbum subtypes        //// collection.localizedTitle
         PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,///
         PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,///全景照片
         PHAssetCollectionSubtypeSmartAlbumVideos     = 202,///视频
         PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,///个人收藏
         PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,///延时摄影
         PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,/// 已隐藏
         PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,///最近添加
         PHAssetCollectionSubtypeSmartAlbumBursts     = 207,///连拍快照
         PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,///慢动作
         PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,///所有照片
         PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,///自拍
         PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,///屏幕快照
         PHAssetCollectionSubtypeSmartAlbumDepthEffect PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = 212,///人像
         PHAssetCollectionSubtypeSmartAlbumLivePhotos PHOTOS_AVAILABLE_IOS_TVOS(10_3, 10_2) = 213,//livephotos
         PHAssetCollectionSubtypeSmartAlbumAnimated = 214,///动图
         = 1000000201///最近删除知道值为（1000000201）但没找到对应的TypedefName
         // Used for fetching, if you don't care about the exact subtype
         PHAssetCollectionSubtypeAny = NSIntegerMax /////所有类型
         */
        
        var albumList: [ETAlbumModel] = []
        for album in allAlbums {
            album.enumerateObjects { (collection, idx, stop) in
                
//                //过滤PHCollectionList对象
//                if (![collection isKindOfClass:PHAssetCollection.class]) return;
                //过滤最近删除和已隐藏
                if (collection.assetCollectionSubtype.rawValue > 215 ||
                    collection.assetCollectionSubtype == .smartAlbumAllHidden) {
                    return
                }
                //获取相册内asset result
                let result = PHAsset.fetchAssets(in: collection, options: option)
                if result.count <= 0 {
                    return
                }
                
                let title = getCollectionTitle(collection: collection)
                let albumModel = getAlbumModel(withTitle: title, result: result, allowSelectVideo: allowSelectVideo, allowSelectImage: allowSelectImage)
                if (collection.assetCollectionSubtype == .smartAlbumUserLibrary) {
                    //所有照片
                    albumModel.isCameraRoll = true
                    albumList.insert(albumModel, at: 0)
                } else {
                    albumList.append(albumModel)
                }
            }
        }
        
        guard let completionBlock = completion else { return }
        completionBlock(albumList)
        
    }
    
    class func getCollectionTitle(collection: PHAssetCollection) -> String? {
    
        if (collection.assetCollectionType == .album) {
            //用户相册
            return collection.localizedTitle
        }
        
        //系统相册
        let languageType = ETLanguageType(rawValue: UserDefaults.standard.integer(forKey: ETLanguageTypeKey))
        guard let type = languageType else { return nil }
        
        var title: String?
        
        if (type == ETLanguageType.System) {
            title = collection.localizedTitle
        } else {
            switch (collection.assetCollectionSubtype) {
            case .smartAlbumUserLibrary:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserCameraRoll)
            case .smartAlbumPanoramas:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserPanoramas)
            case .smartAlbumVideos:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserVideos)
            case .smartAlbumFavorites:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserFavorites)
            case .smartAlbumTimelapses:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserTimelapses)
            case .smartAlbumRecentlyAdded:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserRecentlyAdded)
            case .smartAlbumBursts:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserBursts)
            case .smartAlbumSlomoVideos:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserSlomoVideos)
            case .smartAlbumSelfPortraits:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserSelfPortraits)
            case .smartAlbumScreenshots:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserScreenshots)
            case .smartAlbumDepthEffect:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserDepthEffect)
            case .smartAlbumLivePhotos:
                title = GetLocalLanguageTextValue(key: ETPhotoBrowserLivePhotos)
            default:
                break;
            }
            
            if #available(iOS 11, *) {
                if collection.assetCollectionSubtype.rawValue == 215 {
                    title = GetLocalLanguageTextValue(key: ETPhotoBrowserAnimated)
                }
            }
            
        }
        
        if let currentTitle = title {
            return currentTitle
        }
        else {
            return collection.localizedTitle
        }
    
    }
    
    //获取相册列表model
    class func getAlbumModel(withTitle title: String?, result: PHFetchResult<PHAsset>, allowSelectVideo: Bool, allowSelectImage: Bool) -> ETAlbumModel {
        
        let model = ETAlbumModel()
        model.title = title;
        model.count = result.count;
        model.result = result
        if (self.sortAscending) {
            model.headImageAsset = result.lastObject;
        } else {
            model.headImageAsset = result.firstObject;
        }
        //为了获取所有asset gif设置为yes
        model.models = getPhotoInResult(result: result, allowSelectVideo: allowSelectVideo, allowSelectImage: allowSelectImage, allowSelectGif: allowSelectImage, allowSelectLivePhoto: allowSelectImage)
        
        return model;
    }
    
    class func requestImage(withAsset asset: PHAsset, size: CGSize, completion: ((UIImage?, [AnyHashable : Any]?) -> Void)?) -> PHImageRequestID {
        return requestImage(withAsset: asset, size: size, resizeMode: .fast, completion: completion)
    }
    
    class func requestImage(withAsset asset: PHAsset, size: CGSize, resizeMode: PHImageRequestOptionsResizeMode, completion: ((UIImage?, [AnyHashable : Any]?) -> Void)?) -> PHImageRequestID {
        
        let option = PHImageRequestOptions()

        /**
         resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
         这个属性只有在 synchronous 为 true 时有效。
         */

        option.resizeMode = resizeMode  //控制照片尺寸
        //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
        option.isNetworkAccessAllowed = true
        
        /*
         info字典提供请求状态信息:
         PHImageResultIsInCloudKey：图像是否必须从iCloud请求
         PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
         PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
         PHImageErrorKey：如果没有图像，字典内的错误信息
         */
        
        return PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (image, info) in
            
            var downloadFinined: Bool = true
            if let infoDict = info {
                //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
                // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
                if let cancelled = infoDict[PHImageCancelledKey] as? Bool, let error = infoDict[PHImageErrorKey] as? Bool {
                    downloadFinined = !(cancelled || error)
                }
            }
            
            if let completionBlock = completion, downloadFinined {
                completionBlock(image, info)
            }
            
        }
        
    }
    
    class func markSelectModel(inModels models: [ETPhotoModel], selectModels: [ETPhotoModel]) {
        
        var selectIdentifiers: [String] = []
        for model in selectModels {
            if let asset = model.asset {
                selectIdentifiers.append(asset.localIdentifier)
            }
        }
        
        for model in models {
            if let asset = model.asset {
                model.isSelected = selectIdentifiers.contains(asset.localIdentifier)
            }
        }
        
    }

    
    //系统mediatype 转换为 自定义type
    class func transformAssetType(asset: PHAsset) -> ETAssetMediaType {
        
        switch asset.mediaType {
        case .audio:
            return .Audio
        case .video:
            return .Video
        case .image:
            
            if let fileName = asset.value(forKey: "filename") as? String, fileName.hasPrefix("GIF") {
                return .Gif
            }
            
            if asset.mediaSubtypes == .photoLive ||
                Int(asset.mediaSubtypes.rawValue) == 10 {
                return .LivePhoto
            }
            
            return .Image
            
        default:
            return .Unknown
        }
    }
    
    class func getDuration(asset: PHAsset) -> String? {
        
        if asset.mediaType != .video {
            return nil
        }
        
        let duration = Int(round(asset.duration))
        if (duration < 60) {
            return String(format: "00:%02ld", duration)
        } else if (duration < 3600) {
            let m = duration / 60
            let s = duration % 60
            return String(format: "%02ld:%02ld", m, s)
        } else {
            let h = duration / 3600
            let m = (duration % 3600) / 60
            let s = duration % 60
            return String(format: "%02ld:%02ld:%02ld", h, m, s)
        }
        
    }
    
    
    
    
    
    // MARK: - 权限相关
    // MARK: -
    // MARK: 是否有相册访问权限
    class func havePhotoLibraryAuthority() -> Bool {
        
        let status = PHPhotoLibrary.authorizationStatus()
        return PHAuthorizationStatus.authorized == status
    }
    
    // MARK: 是否有相机访问权限
    class func haveCameraAuthority() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return !(status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied)
    }
    
    // MARK: 是否有麦克风访问权限
    class func haveMicrophoneAuthority() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return !(status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied)
    }

}
