//
//  TourReviewsInteractorTests.swift
//  TourReviewsTests
//
//  Created by Adriana Elizondo on 2019/8/18.
//  Copyright © 2019 adriana. All rights reserved.
//

import XCTest
import NetworkLayer
@testable import TourReviews

/***
 *Test cases
 ***
 protocol TourReviewsBusinessLogic {
 func loadReviews(in page: Int, totalToLoad: Int)
 }
 ***/

class TourReviewsInteractorTests: XCTestCase {
    var interactor = TourReviewsInteractor()
    var presenter = TestReviewsPresenter()
    var networkHelper = TestReviewsNetworkWorker()
    override func setUp() {
        interactor.apiWorker = networkHelper
        interactor.presenter = presenter
    }
    class TestReviewsNetworkWorker: TourReviewsAPIProtocol {
        var withSuccess = true
        func loadReviews(in page: Int, numberToLoad: Int, with completion: @escaping ReviewsAPICompletion) {
            if withSuccess {
                completion(Result.success(Reviews.Response(status: true,
                                                           total_reviews_comments: 40, data: MockData.reviews)))
            } else {
                completion(Result.failure(.requestFailed))
            }
        }
    }
    class TestReviewsPresenter: TourReviewsPresentingProtocol {
        var didPresentReviews = false
        var didPresentError = false
        func presentReviews(with response: Reviews.Response) {
            didPresentReviews = true
        }
        func presentError(error: NetworkResponseError) {
            didPresentError = true
        }
    }
    func testLoadReviews() {
        networkHelper.withSuccess = true
        interactor.loadReviews(in: 0, totalToLoad: 0)
        XCTAssertTrue(presenter.didPresentReviews, "Should have presented reviews successfully")
    }
    func testLoadReviewsWithError() {
        networkHelper.withSuccess = false
        interactor.loadReviews(in: 0, totalToLoad: 0)
        XCTAssertTrue(presenter.didPresentError, "Should have presented error")
    }
}
