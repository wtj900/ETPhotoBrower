//
//  ETPhotoBrower.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/22.
//  Copyright © 2018年 ET. All rights reserved.
//

import UIKit

class ETPhotoBrower: UITableViewController {
    
    var configuration: ETPhotoConfiguration = ETPhotoConfiguration()
    
    fileprivate var albumList: [ETAlbumModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .top
//        title = ZLPhotoBrowserBursts
        
        if let navigationController = self.navigationController as? ETNavigationController {
            self.configuration = navigationController.configuration
            initNavigationBarActionButton(navigationController: navigationController)
        }
        
        let nib = UINib(nibName: "ETPhotoBrowserCell", bundle: Bundle(for: ETPhotoBrower.self))
        self.tableView.register(nib, forCellReuseIdentifier: "ETPhotoBrowserCell")
        
    }
    
    func initNavigationBarActionButton(navigationController: ETNavigationController) {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle(GetLocalLanguageTextValue(key: ETPhotoBrowserCancelText), for: .normal)
        button.setTitleColor(configuration.navTitleColor, for: .normal)
        button.addTarget(self, action: #selector(cancelAction(button:)), for: .touchUpInside)
        button.sizeToFit()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    @objc func cancelAction(button: UIButton) {
        
        guard let navigationController = self.navigationController as? ETNavigationController else { return }
        if let cancelBlock = navigationController.cancel {
            cancelBlock()
        }
        navigationController.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue(label: "ETPhotoBrower").async {
            ETPhotoManager.getPhotoAblumList(allowSelectVideo: self.configuration.allowSelectVideo, allowSelectImage: self.configuration.allowSelectImage, completion: { (albumData) in
                self.albumList = albumData
                DispatchQueue.main.async(execute: {
                    self.reloadTableView()
                })
            })
        }
    }
    
    func reloadTableView() {
        self.placeholderView.isHidden = self.albumList.count > 0
        self.tableView.reloadData()
    }
    
    // MARK: - Property
    
    fileprivate lazy var placeholderView: UIView = {
        
        let backView = UIView(frame: self.view.bounds)
        backView.isHidden = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
//        imageView.image =
        imageView.contentMode = .scaleAspectFit
//        imageView.center =
        backView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        backView.addSubview(label)
        
        self.view.addSubview(backView)
        
        return backView
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.albumList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ETPhotoBrowserCell", for: indexPath) as! ETPhotoBrowserCell
        cell.albumModel = self.albumList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let albumModel = self.albumList[indexPath.row]
        
        let thumbnailBrower = ETPhotoThumbnailBrower()
        thumbnailBrower.albumModel = albumModel
        self.navigationController?.pushViewController(thumbnailBrower, animated: true)
    }

}
