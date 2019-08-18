//
//  TourReviewsMockData.swift
//  TourReviewsTests
//
//  Created by Adriana Elizondo on 2019/8/18.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
@testable import TourReviews

struct MockData {
    static let review = Reviews.Review(review_id: 0,
                                       rating: "4",
                                       title: "Test",
                                       message: "Test",
                                       author: "Adri",
                                       foreignLanguage: true,
                                       date: "Todat",
                                       languageCode: "es",
                                       traveler_type: nil,
                                       reviewerName: "Adri",
                                       reviewerCountry: "Mexico",
                                       reviewerProfilePhoto: nil,
                                       isAnonymous: false,
                                       firstInitial: "A")
    static let reviews = [MockData.review,
                          MockData.review,
                          MockData.review,
                          MockData.review,
                          MockData.review,
                          MockData.review]
}
