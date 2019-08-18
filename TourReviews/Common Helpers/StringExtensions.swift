//
//  StringExtensions.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/18.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func emojiForCountryCode() -> String {
        let code = uppercased()
        guard Locale.isoLanguageCodes.contains(code) else {
            return ""
        }
        var flagString = ""
        for scalar in code.unicodeScalars {
            guard let newScalar = UnicodeScalar(127397 + scalar.value) else {
                continue
            }
            flagString.append(String(newScalar))
        }
        return flagString
    }
}
