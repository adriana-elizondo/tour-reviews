//
//  TourReviewsPresenter.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import NetworkLayer

protocol TourReviewsPresentingProtocol {
    func presentReviews(with response: Reviews.Response)
    func presentError(error: NetworkResponseError)
}
class TourReviewsPresenter: TourReviewsPresentingProtocol {
    weak var viewcontroller: TourReviewsDisplayProtocol?
    func presentReviews(with response: Reviews.Response) {
        viewcontroller?.displayReviewItems(with: Reviews.ViewModel(with: response))
    }
    func presentError(error: NetworkResponseError) {
        viewcontroller?.displayError()
    }
}
