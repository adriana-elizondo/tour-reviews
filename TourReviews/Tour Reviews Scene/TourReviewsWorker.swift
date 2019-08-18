//
//  TourReviewsWorker.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import NetworkLayer

typealias ReviewsAPICompletion = (Result<Reviews.Response, NetworkResponseError>) -> Void
protocol TourReviewsAPIProtocol {
    func loadReviews(in page: Int, numberToLoad: Int, with completion: @escaping ReviewsAPICompletion)
}

class TourReviewsWorker: TourReviewsAPIProtocol {
    private var apiPath = "/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json"
    private var reviewsService = ReviewsService()
    func loadReviews(in page: Int, numberToLoad: Int, with completion: @escaping ReviewsAPICompletion) {
        let parameters = ReviewsParamaters(count: numberToLoad, page: page, sortBy: "date_of_review", direction: "desc")
        reviewsService.parameters = parameters
        reviewsService.apiPath = apiPath
        reviewsService.loadReviews { (response, error) in
            guard error == nil else { completion(.failure(error!)); return }
            guard response != nil else { completion(.failure(.parsingError)); return}
            completion(.success(response!))
        }
    }
}
