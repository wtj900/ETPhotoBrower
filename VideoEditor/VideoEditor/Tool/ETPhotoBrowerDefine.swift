//
//  ETPhotoBrowerDefine.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/23.
//  Copyright © 2018 ET. All rights reserved.
//

import Foundation

let ETPhotoBrowserCameraText = "ETPhotoBrowserCameraText"
let ETPhotoBrowserCameraRecordText = "ETPhotoBrowserCameraRecordText"
let ETPhotoBrowserAblumText = "ETPhotoBrowserAblumText"
let ETPhotoBrowserCancelText = "ETPhotoBrowserCancelText"
let ETPhotoBrowserOriginalText = "ETPhotoBrowserOriginalText"
let ETPhotoBrowserDoneText = "ETPhotoBrowserDoneText"
let ETPhotoBrowserOKText = "ETPhotoBrowserOKText"
let ETPhotoBrowserBackText = "ETPhotoBrowserBackText"
let ETPhotoBrowserPhotoText = "ETPhotoBrowserPhotoText"
let ETPhotoBrowserPreviewText = "ETPhotoBrowserPreviewText"
let ETPhotoBrowserLoadingText = "ETPhotoBrowserLoadingText"
let ETPhotoBrowserHandleText = "ETPhotoBrowserHandleText"
let ETPhotoBrowserSaveImageErrorText = "ETPhotoBrowserSaveImageErrorText"
let ETPhotoBrowserMaxSelectCountText = "ETPhotoBrowserMaxSelectCountText"
let ETPhotoBrowserNoCameraAuthorityText = "ETPhotoBrowserNoCameraAuthorityText"
let ETPhotoBrowserNoAblumAuthorityText = "ETPhotoBrowserNoAblumAuthorityText"
let ETPhotoBrowserNoMicrophoneAuthorityText = "ETPhotoBrowserNoMicrophoneAuthorityText"
let ETPhotoBrowseriCloudPhotoText = "ETPhotoBrowseriCloudPhotoText"
let ETPhotoBrowserGifPreviewText = "ETPhotoBrowserGifPreviewText"
let ETPhotoBrowserVideoPreviewText = "ETPhotoBrowserVideoPreviewText"
let ETPhotoBrowserLivePhotoPreviewText = "ETPhotoBrowserLivePhotoPreviewText"
let ETPhotoBrowserNoPhotoText = "ETPhotoBrowserNoPhotoText"
let ETPhotoBrowserCannotSelectVideo = "ETPhotoBrowserCannotSelectVideo"
let ETPhotoBrowserCannotSelectGIF = "ETPhotoBrowserCannotSelectGIF"
let ETPhotoBrowserCannotSelectLivePhoto = "ETPhotoBrowserCannotSelectLivePhoto"
let ETPhotoBrowseriCloudVideoText = "ETPhotoBrowseriCloudVideoText"
let ETPhotoBrowserEditText = "ETPhotoBrowserEditText"
let ETPhotoBrowserSaveText = "ETPhotoBrowserSaveText"
let ETPhotoBrowserMaxVideoDurationText = "ETPhotoBrowserMaxVideoDurationText"
let ETPhotoBrowserLoadNetImageFailed = "ETPhotoBrowserLoadNetImageFailed"
let ETPhotoBrowserSaveVideoFailed = "ETPhotoBrowserSaveVideoFailed"
let ETPhotoBrowserCameraRoll = "ETPhotoBrowserCameraRoll"
let ETPhotoBrowserPanoramas = "ETPhotoBrowserPanoramas"
let ETPhotoBrowserVideos = "ETPhotoBrowserVideos"
let ETPhotoBrowserFavorites = "ETPhotoBrowserFavorites"
let ETPhotoBrowserTimelapses = "ETPhotoBrowserTimelapses"
let ETPhotoBrowserRecentlyAdded = "ETPhotoBrowserRecentlyAdded"
let ETPhotoBrowserBursts = "ETPhotoBrowserBursts"
let ETPhotoBrowserSlomoVideos = "ETPhotoBrowserSlomoVideos"
let ETPhotoBrowserSelfPortraits = "ETPhotoBrowserSelfPortraits"
let ETPhotoBrowserScreenshots = "ETPhotoBrowserScreenshots"
let ETPhotoBrowserDepthEffect = "ETPhotoBrowserDepthEffect"
let ETPhotoBrowserLivePhotos = "ETPhotoBrowserLivePhotos"
let ETPhotoBrowserAnimated = "ETPhotoBrowserAnimated"

//自定义图片名称存于plist中的key
let ETCustomImageNames = "ETCustomImageNames"
//设置框架语言的key
let ETLanguageTypeKey = "ETLanguageTypeKey"
//自定义多语言key value存于plist中的key
let ETCustomLanguageKeyValue = "ETCustomLanguageKeyValue"

let ClippingRatioValue1 = "value1"
let ClippingRatioValue2 = "value2"
let ClippingRatioTitleFormat = "titleFormat"

let ETPreviewPhotoObj = "ETPreviewPhotoObj"
let ETPreviewPhotoTyp = "ETPreviewPhotoTyp"

//ETShowBigImgViewController
let kItemMargin = 40

//ETBigImageCell 不建议设置太大，太大的话会导致图片加载过慢
let kMaxImageWidth = 500

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

// 系统语言
enum ETLanguageType: Int {
    case System                 // 跟随系统语言，默认
    case ChineseSimplified      // 中文简体
    case ChineseTraditional     // 中文繁体
    case English                // 英文
    case Japanese               // 日文
}

//录制视频及拍照分辨率
enum ETCaptureSessionPreset: String {
    case ETCaptureSessionPreset352x288
    case ETCaptureSessionPreset640x480
    case ETCaptureSessionPreset1280x720
    case ETCaptureSessionPreset1920x1080
    case ETCaptureSessionPreset3840x2160
}

// 导出视频类型
enum ETExportVideoType: Int {
    case Mov
    case Mp4
}

//导出视频水印位置
enum ETWatermarkLocation: Int {
    case TopLeft
    case TopRight
    case Center
    case BottomLeft
    case BottomRight
}

//混合预览图片时，图片类型
enum ETPreviewPhotoType: Int {
    case PHAsset
    case UIImage
    case URLImage
    case URLVideo
}

func ETRGB(R: CGFloat, G: CGFloat, B: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: (R)/255.0, green: (G)/255.0, blue: (B)/255.0, alpha: alpha)
}

func IPhone() -> Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
}

func IPhoneX() -> Bool {
    return 812 == UIScreen.main.bounds.height
}

func SafeAreaBottom() -> CGFloat {
    return IPhoneX() ? 34 : 0
}

//let kETPhotoBrowserBundle [NSBundle bundleForClass:[self class]]

func ETPhotoBrowserSrcName(name: String) -> String {
    return ("ETPhotoBrowser.bundle" as NSString).appendingPathComponent(name)
}

func ETPhotoBrowserFrameworkSrcName(name: String) -> String {
    return ("Frameworks/ETPhotoBrowser.framework/ETPhotoBrowser.bundle" as NSString).appendingPathComponent(name)
}

func APPName() -> String {
    
    var infoDict: [String : Any] = [:]
    if let dict = Bundle.main.localizedInfoDictionary {
        infoDict = dict
    }
    else if let dict = Bundle.main.infoDictionary {
        infoDict = dict
    }
    else {
        return ""
    }
    
    if let name = infoDict["CFBundleDisplayName"] as? String {
        return name
    }
    else if let name = infoDict["CFBundleName"] as? String {
        return name
    }
    else {
        return ""
    }
    
}


//
//static inline NSDictionary * GetDictForPreviewPhoto(id obj, ETPreviewPhotoType type) {
//    if (nil == obj) {
//        @throw [NSException exceptionWithName:@"error" reason:@"预览对象不能为空" userInfo:nil];
//    }
//    return @{ETPreviewPhotoObj: obj, ETPreviewPhotoTyp: @(type)};
//}

func SetViewWidth(view: UIView, width: CGFloat) {
    
    var frame = view.frame
    frame.size.width = width
    view.frame = frame
}

func GetViewWidth(view: UIView) -> CGFloat {
    
    return view.frame.size.width
}

func SetViewHeight(view: UIView, height: CGFloat) {
    
    var frame = view.frame
    frame.size.height = height
    view.frame = frame
}

func GetViewHeight(view: UIView) -> CGFloat {
    
    return view.frame.size.height
}

func GetLocalLanguageTextValue(key: String) -> String? {
    
    guard let languageDict = UserDefaults.standard.dictionary(forKey: ETCustomLanguageKeyValue) else { return nil }
    if languageDict.keys.contains(key) {
        return languageDict[key] as? String
    }
    
    return Bundle.et_localizedStringForKey(key: key)
    
}

//static inline NSString *  GetLocalLanguageTextValue (NSString *key) {
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:ETCustomLanguageKeyValue];
//    if ([dic.allKeys containsObject:key]) {
//        return dic[key];
//    }
//    return [NSBundle ETLocalizedStringForKey:key];
//}

func GetImageWithName(name: String) -> UIImage? {
    
    if let names = UserDefaults.standard.array(forKey: ETCustomImageNames) as? [String] {
        if names.contains(name) {
            return UIImage(named: name)
        }
    }
    
    return UIImage(named: ETPhotoBrowserSrcName(name: name)) ?? UIImage(named: ETPhotoBrowserFrameworkSrcName(name: name))
    
}

//static inline UIImage * GetImageWithName(NSString *name) {
//    NSArray *names = [[NSUserDefaults standardUserDefaults] valueForKey:ETCustomImageNames];
//    if ([names containsObject:name]) {
//        return [UIImage imageNamed:name];
//    }
//    return [UIImage imageNamed:kETPhotoBrowserSrcName(name)]?:[UIImage imageNamed:kETPhotoBrowserFrameworkSrcName(name)];
//}
//
//static inline CGFloat GetMatchValue(NSString *text, CGFloat fontSize, BOOL isHeightFixed, CGFloat fixedValue) {
//    CGSize size;
//    if (isHeightFixed) {
//        size = CGSizeMake(MAXFLOAT, fixedValue);
//    } else {
//        size = CGSizeMake(fixedValue, MAXFLOAT);
//    }
//
//    CGSize resultSize;
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
//        //返回计算出的size
//        resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
//    }
//    if (isHeightFixed) {
//        return resultSize.width;
//    } else {
//        return resultSize.height;
//    }
//}
//
//static inline void ShowAlert(NSString *message, UIViewController *sender) {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:GetLocalLanguageTextValue(ETPhotoBrowserOKText) style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:action];
//    [sender presentViewController:alert animated:YES completion:nil];
//}
//
//static inline CABasicAnimation * GetPositionAnimation(id fromValue, id toValue, CFTimeInterval duration, NSString *keyPath) {
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
//    animation.fromValue = fromValue;
//    animation.toValue   = toValue;
//    animation.duration = duration;
//    animation.repeatCount = 0;
//    animation.autoreverses = NO;
//    //以下两个设置，保证了动画结束后，layer不会回到初始位置
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    return animation;
//}
//
//static inline CAKeyframeAnimation * GetBtnStatusChangedAnimation() {
//    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//
//    animate.duration = 0.3;
//    animate.removedOnCompletion = YES;
//    animate.fillMode = kCAFillModeForwards;
//
//    animate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
//    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
//    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
//    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    return animate;
//}
//
//static inline NSInteger GetDuration (NSString *duration) {
//    NSArray *arr = [duration componentsSeparatedByString:@":"];
//
//    NSInteger d = 0;
//    for (int i = 0; i < arr.count; i++) {
//        d += [arr[i] integerValue] * pow(60, (arr.count-1-i));
//    }
//    return d;
//}

func GetCustomClipRatio() -> [String: Any] {
    
    return [ClippingRatioValue1 : 0,
            ClippingRatioValue2 : 0,
            ClippingRatioTitleFormat : "Custom"]
}

func GetClipRatio(value1: Int, value2: Int) -> [String: Any] {
    
    return [ClippingRatioValue1 : value1,
            ClippingRatioValue2 : value2,
            ClippingRatioTitleFormat : "%g : %g"]
}
