//
//  TourReviewsPresenterTests.swift
//  TourReviewsTests
//
//  Created by Adriana Elizondo on 2019/8/18.
//  Copyright © 2019 adriana. All rights reserved.
//

import XCTest
@testable import TourReviews
/***
 *Test cases
 ***
 protocol TourReviewsPresentingProtocol {
    func presentReviews(with response: Reviews.Response)
    func presentError(error: NetworkResponseError)
 }
 ***/
class TourReviewsPresenterTests: XCTestCase {
    var presenter = TourReviewsPresenter()
    let viewController = TestTourReviewsViewController()
    override func setUp() {
        presenter.viewcontroller = viewController
    }
    class TestTourReviewsViewController: TourReviewsDisplayProtocol {
        var reviewItemsWereDisplayed = false
        var errorWasPresented = false
        func displayReviewItems(with viewModel: Reviews.ViewModel) {
            reviewItemsWereDisplayed = true
        }
        func displayError() {
            errorWasPresented = true
        }
    }
    func testPresentReviews() {
        presenter.presentReviews(with: Reviews.Response(status: true,
                                                        total_reviews_comments: 25, data: MockData.reviews))
        XCTAssertTrue(viewController.reviewItemsWereDisplayed, "Should have displayed items in view controller")
    }
    func testPresentError() {
        presenter.presentError(error: .badRequest)
        XCTAssertTrue(viewController.errorWasPresented, "Should have displayed error in view controller")
    }
}
