//
//  CountryCodeEmoji.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/18.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit

class CountryCodeEmoji {
    static let sharedInstance = CountryCodeEmoji()
    private var countryCodesForCountryNames = [String: String]()
    init() {
        setupCountryCodesDictionary()
    }
    private func setupCountryCodesDictionary() {
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            if let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode) {
                countryCodesForCountryNames[countryName.lowercased()] = localeCode
            }
        }
    }
    func emojiForCountry(with countryName: String) -> String {
        return countryCodesForCountryNames[countryName.lowercased()]?.emojiForCountryCode() ?? ""
    }
}
