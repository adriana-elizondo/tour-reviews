//
//  CodableExtensions.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation

extension Encodable {
    func toJsonDictionary() throws -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
            options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
