//
//  UIExtensions.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    convenience init(nibName: String? = nil) {
        guard nibName != nil else {
            self.init(nibName: String(describing: type(of: self)), bundle: nil)
            return
        }
        self.init(nibName: nibName, bundle: nil)
    }
}
