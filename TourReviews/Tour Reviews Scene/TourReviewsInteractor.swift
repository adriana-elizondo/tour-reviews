//
//  TourReviewsInteractor.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation

protocol TourReviewsBusinessLogic {
    func loadReviews(in page: Int, totalToLoad: Int)
}
class TourReviewsInteractor: TourReviewsBusinessLogic {
    var presenter: TourReviewsPresentingProtocol?
    var apiWorker: TourReviewsAPIProtocol = TourReviewsWorker()
    func loadReviews(in page: Int, totalToLoad: Int) {
        apiWorker.loadReviews(in: page, numberToLoad: totalToLoad) { (result) in
            switch result {
            case .success(let response):
                self.presenter?.presentReviews(with: response)
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        }
    }
}
