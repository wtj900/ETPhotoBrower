//
//  ETPhotoThumbnailBrower.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/23.
//  Copyright © 2018 ET. All rights reserved.
//

import UIKit

class ETPhotoThumbnailBrower: UIViewController {

    var albumModel: ETAlbumModel? {
        didSet {
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.automaticallyAdjustsScrollViewInsets = true;
//        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.view.backgroundColor = UIColor.white
        if let album = albumModel {
            self.title = album.title
        }
        
//        [self initNavBtn];
//        [self setupCollectionView];
//        [self setupBottomView];
//
//        ZLPhotoConfiguration *configuration = [(ZLImageNavigationController *)self.navigationController configuration];
//
//        if (configuration.allowSlideSelect) {
//            //添加滑动选择手势
//            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//            [self.view addGestureRecognizer:pan];
//        }
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    // MARK: - UI
    func initNavigationBarActionButton() {
        
        guard let navigationController = self.navigationController as? ETNavigationController else { return }
        
        navigationController.viewControllers.first?.navigationItem.backBarButtonItem = UIBarButtonItem(title: GetLocalLanguageTextValue(key: ETPhotoBrowserBackText), style: .plain, target: nil, action: nil)
        
        let configuration = navigationController.configuration
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle(GetLocalLanguageTextValue(key: ETPhotoBrowserCancelText), for: .normal)
        button.setTitleColor(configuration.navTitleColor, for: .normal)
        button.addTarget(self, action: #selector(navigationItemCancelAction(button:)), for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    func setupSubViews() {
        
        view.addSubview(collectionView)
        collectionView.register(ETPhotoCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ETPhotoCollectionCell.self))
        collectionView.register(ETPhotoTakeCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ETPhotoTakeCollectionCell.self))
        
        if let navigationController = self.navigationController as? ETNavigationController {
            
            let configuration = navigationController.configuration
            if configuration.allowForceTouch && forceTouchAvailable() {
                self.registerForPreviewing(with: self, sourceView: collectionView)
            }
            
            
            
            
        }
//        //注册3d touch
//        ZLPhotoConfiguration *configuration = [(ZLImageNavigationController *)self.navigationController configuration];
//        if (configuration.allowForceTouch && [self forceTouchAvailable]) {
//            [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
//        }
    }
    
//    func setupBottomView() {
//        ZLPhotoConfiguration *configuration = [(ZLImageNavigationController *)self.navigationController configuration];
//
//        if (configuration.editAfterSelectThumbnailImage && configuration.maxSelectCount == 1 && (configuration.allowEditImage || configuration.allowEditVideo)) {
//            //点击后直接编辑则不需要下方工具条
//            return;
//        }
//
//        self.bottomView = [[UIView alloc] init];
//        self.bottomView.backgroundColor = configuration.bottomViewBgColor;
//        [self.view addSubview:self.bottomView];
//
//        self.bline = [[UIView alloc] init];
//        self.bline.backgroundColor = kRGB(232, 232, 232);
//        [self.bottomView addSubview:self.bline];
//
//        if (configuration.allowEditImage || configuration.allowEditVideo) {
//            self.btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.btnEdit.titleLabel.font = [UIFont systemFontOfSize:15];
//            [self.btnEdit setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserEditText) forState:UIControlStateNormal];
//            [self.btnEdit addTarget:self action:@selector(btnEdit_Click:) forControlEvents:UIControlEventTouchUpInside];
//            [self.bottomView addSubview:self.btnEdit];
//        }
//
//        self.btnPreView = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnPreView.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self.btnPreView setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserPreviewText) forState:UIControlStateNormal];
//        [self.btnPreView addTarget:self action:@selector(btnPreview_Click:) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:self.btnPreView];
//
//        if (configuration.allowSelectOriginal) {
//            self.btnOriginalPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.btnOriginalPhoto.titleLabel.font = [UIFont systemFontOfSize:15];
//            [self.btnOriginalPhoto setImage:GetImageWithName(@"zl_btn_original_circle") forState:UIControlStateNormal];
//            [self.btnOriginalPhoto setImage:GetImageWithName(@"zl_btn_selected") forState:UIControlStateSelected];
//            [self.btnOriginalPhoto setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserOriginalText) forState:UIControlStateNormal];
//            [self.btnOriginalPhoto addTarget:self action:@selector(btnOriginalPhoto_Click:) forControlEvents:UIControlEventTouchUpInside];
//            [self.bottomView addSubview:self.btnOriginalPhoto];
//
//            self.labPhotosBytes = [[UILabel alloc] init];
//            self.labPhotosBytes.font = [UIFont systemFontOfSize:15];
//            self.labPhotosBytes.textColor = configuration.bottomBtnsNormalTitleColor;
//            [self.bottomView addSubview:self.labPhotosBytes];
//        }
//
//        self.btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnDone.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self.btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//        [self.btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
//        self.btnDone.layer.masksToBounds = YES;
//        self.btnDone.layer.cornerRadius = 3.0f;
//        [self.btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:self.btnDone];
//    }
    
    // MARK: - Action
    @objc func navigationItemCancelAction(button: UIButton) {
        
        guard let navigationController = self.navigationController as? ETNavigationController else { return }
        if let cancelBlock = navigationController.cancel {
            cancelBlock()
        }
        navigationController.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Condition
    func forceTouchAvailable() -> Bool {
        
        if #available(iOS 9.0, *) {
            return self.traitCollection.forceTouchCapability == UIForceTouchCapability.available
        }
        else {
            return false
        }
    }
    
    // MARK: - Tool
    func getMatchViewControllerWithModel(model: ETPhotoModel) -> UIViewController? {
        
        guard let album = albumModel, let result = album.result else { return nil }
        guard let navigationController = self.navigationController as? ETNavigationController else { return nil }
        let configuration = navigationController.configuration

        if let models = navigationController.selectedModels, models.count > 0 {
            
            let photoModel = models[0]
            if !configuration.allowMixSelect &&
                ((model.type.rawValue < ETAssetMediaType.Video.rawValue && photoModel.type == ETAssetMediaType.Video) ||
                 (model.type == ETAssetMediaType.Video && photoModel.type.rawValue < ETAssetMediaType.Video.rawValue)) {
//                ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserCannotSelectVideo));
                return nil
            }
        }
        
        let allowSelectImage = !(model.type == .Video) ? true : configuration.allowMixSelect
        let allowSelectVideo = model.type == .Video ? true : configuration.allowMixSelect
        
        let photoModels = ETPhotoManager.getPhotoInResult(result: result, allowSelectVideo: allowSelectVideo, allowSelectImage: allowSelectImage, allowSelectGif: configuration.allowSelectGif, allowSelectLivePhoto: configuration.allowSelectLivePhoto)
        
        var selectIdentifiers: [String] = []
        for photoModel in photoModels {
            if let asset = photoModel.asset {
                selectIdentifiers.append(asset.localIdentifier)
            }
        }
        
        var index: Int = 0
        var isFind: Bool = false

        for photoModel in photoModels {
            if let photoModelAsset = photoModel.asset, let modelAsset = model.asset {
                if photoModelAsset.localIdentifier == modelAsset.localIdentifier {
                    isFind = true
                }
                if selectIdentifiers.contains(photoModelAsset.localIdentifier) {
                    photoModel.isSelected = true
                }
                if !isFind {
                    index += 1
                }
            }
        }
        
        return getBigImageViewController(WithPhotoModels: photoModels, index: index)
    }
    
    func getBigImageViewController(WithPhotoModels photoModels: [ETPhotoModel], index: Int) -> UIViewController {
        
        let bigImageBrower = ETPhotoBigImageBrower()
        bigImageBrower.photoModels = photoModels
        bigImageBrower.selectIndex = index
        bigImageBrower.canInteractivePop = true
        bigImageBrower.back = {
            [weak self] (selectedModels, isOriginal) in
            
        }
        
//        zl_weakify(self);
//        [vc setBtnBackBlock:^(NSArray<ZLPhotoModel *> *selectedModels, BOOL isOriginal) {
//        zl_strongify(weakSelf);
//        [ZLPhotoManager markSelectModelInArr:strongSelf.arrDataSources selArr:selectedModels];
//        [strongSelf.collectionView reloadData];
//        }];
        return bigImageBrower;
    }
    
    // MARK: - Property
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let width = min(SCREEN_WIDTH, SCREEN_HEIGHT)
        
        var columnCount = 4
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            columnCount = 6
        }
        
        let itemSizeWidth = (width - 1.5 * CGFloat(columnCount)) / CGFloat(columnCount)
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        layout.minimumInteritemSpacing = 1.5
        layout.minimumLineSpacing = 1.5
        layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
        
        return collectionView
    }()

}

extension ETPhotoThumbnailBrower: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    

}

extension ETPhotoThumbnailBrower: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

}

extension ETPhotoThumbnailBrower: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = collectionView.indexPathForItem(at: location)
        guard let indexPathValue = indexPath else { return nil }
        
        let cell = collectionView.cellForItem(at: indexPathValue)
        guard let _ = cell as? ETPhotoTakeCollectionCell else { return nil }
        guard let photoCell = cell as? ETPhotoCollectionCell else { return nil }
        
        //设置突出区域
        previewingContext.sourceRect = photoCell.frame
        
        let forceTouchPreviewController = ETForceTouchPreviewController()
        
//        ZLPhotoConfiguration *configuration = [(ZLImageNavigationController *)self.navigationController configuration];
//
//        NSInteger index = indexPath.row;
//        if (self.allowTakePhoto && !configuration.sortAscending) {
//            index = indexPath.row - 1;
//        }
//        ZLPhotoModel *model = self.arrDataSources[index];
//        vc.model = model;
//        vc.allowSelectGif = configuration.allowSelectGif;
//        vc.allowSelectLivePhoto = configuration.allowSelectLivePhoto;
//
//        vc.preferredContentSize = [self getSize:model];
        
        return forceTouchPreviewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        guard let forceTouchPreviewController = viewControllerToCommit as? ETForceTouchPreviewController else { return }
        guard let photoModel = forceTouchPreviewController.photoModel else { return }
        
        if let viewController = getMatchViewControllerWithModel(model: photoModel) {
            self.show(viewController, sender: self)
        }

    }
    
//    - (CGSize)getSize:(ZLPhotoModel *)model
//    {
//    CGFloat w = MIN(model.asset.pixelWidth, kViewWidth);
//    CGFloat h = w * model.asset.pixelHeight / model.asset.pixelWidth;
//    if (isnan(h)) return CGSizeZero;
//
//    if (h > kViewHeight || isnan(h)) {
//    h = kViewHeight;
//    w = h * model.asset.pixelWidth / model.asset.pixelHeight;
//    }
//
//    return CGSizeMake(w, h);
//    }
    
}

//extension ETPhotoThumbnailBrower: ZLInteractiveAnimateProtocol {
//
//}
