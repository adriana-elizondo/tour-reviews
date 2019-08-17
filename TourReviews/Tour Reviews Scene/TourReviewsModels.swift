//
//  TourReviewsModels.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
struct Reviews: Codable {
    struct Response: Codable {
        var status: Bool
        var total_reviews_comments: Int
        var data: [Review]
    }
    struct Review: Codable {
        var review_id: Int
        var rating: String
        var title: String?
        var message: String
        var author: String
        var foreignLanguage: Bool
        var date: String
        var languageCode: String
        var traveler_type: String?
        var reviewerName: String
        var reviewerCountry: String
        var reviewerProfilePhoto: String?
        var isAnonymous: Bool
        var firstInitial: String
    }
    struct ViewModel: Codable {
        var reviews = [Reviews.Review]()
        var total_reviews = 0
        init(with response: Reviews.Response) {
            reviews = response.data
            total_reviews = response.total_reviews_comments
        }
    }
}
