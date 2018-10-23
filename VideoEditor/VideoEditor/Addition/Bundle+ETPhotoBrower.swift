//
//  Bundle+ETPhotoBrower.swift
//  VideoEditor
//
//  Created by 王史超 on 2018/10/23.
//  Copyright © 2018 ET. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var bundle: Bundle?
    
    class func et_photoBrowserBundle() -> Bundle? {
        
        guard let path = Bundle(for: ETPhotoBrower.self).path(forResource: "ETPhotoBrowser", ofType: "bundle") else { return nil }

        let sourceBundle = Bundle(path: path)
        
        return sourceBundle
    }
    
    class func et_resetLanguage() {
        bundle = nil
    }
    
    class func et_localizedStringForKey(key: String) -> String? {
        return et_localizedStringForKey(key: key, value: nil)
    }
    
    class func et_localizedStringForKey(key: String, value: String?) -> String? {
        
        if bundle == nil {
            guard let currentBundle = et_photoBrowserBundle() else { return nil }
            guard let path = currentBundle.path(forResource: et_getLanguage(), ofType: "lproj") else { return nil }
            bundle = Bundle(path: path)
        }
        
        let valueString = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: valueString, table: nil)
    }
    
    class func et_getLanguage() -> String? {
        
        let typeValue = UserDefaults.standard.integer(forKey: ETLanguageTypeKey)
        guard let type = ETLanguageType(rawValue: typeValue) else { return nil }
        
        var language: String?
        switch (type) {
        case .System:
            language = Locale.preferredLanguages.first
            guard let languageString = language else { return nil }
            if languageString.hasPrefix("en") {
                language = "en"
            }
            else if languageString.hasPrefix("zh") {
                if (languageString as NSString).range(of: "Hans").location == NSNotFound {
                    language = "zh-Hant"
                }
                else {
                    language = "zh-Hans"
                }
            }
            else if languageString.hasPrefix("ja") {
                language = "ja-US"
            }
            else {
                language = "en"
            }
        case .ChineseSimplified:
            language = "zh-Hans"
        case .ChineseTraditional:
            language = "zh-Hant"
        case .English:
            language = "en"
        case .Japanese:
            language = "ja-US"
        }
        
        return language
    }

}
