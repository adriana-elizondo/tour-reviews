//
//  TourReviewsViewControllerTests.swift
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
 protocol TourReviewsDisplayProtocol:  class {
 func displayReviewItems(with viewModel: Reviews.ViewModel)
 func displayError()
 }
 ***/
class TourReviewsViewControllerTests: XCTestCase {
    var testTableView = TestTableView()
    var testLoadingView = TestLoadingView()
    let activityIndicator = UIActivityIndicatorView()
    var viewcontroller: TestTourReviewsViewController?
    class TestLoadingView: LoadingView {
        var didCallStartLoading = false
        var didCallStopLoading = false
        var didCallRefresh = false
        override func startLoading() {
            didCallStartLoading = true
        }
        override func stopLoading() {
            didCallStopLoading = true
        }
        override func displayRefreshUI(with action: @escaping () -> Void) {
            didCallRefresh = true
        }
    }
    class TestTableView: UITableView {
        var wasDataReloaded = false
        override func reloadData() {
            wasDataReloaded = true
        }
    }
    class TestTourReviewsViewController: TourReviewsViewController {
        var didFinishLoading = false
        var addedNewRows = false
        var fullFillClosure: (() -> Void)?
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        override func setup() {
            let viewcontroller = self
            let interactor = TourReviewsInteractor()
            let presenter = TourReviewsPresenter()
            presenter.viewcontroller = viewcontroller
            interactor.presenter = presenter
            self.interactor = interactor
            self.title = "Berlin-Tempelhof airport tour"
        }
        override func displayReviewItems(with viewModel: Reviews.ViewModel) {
            super.displayReviewItems(with: viewModel)
            didFinishLoading = true
            fullFillClosure?()
        }
        override func addNewRows() {
            addedNewRows = true
        }
    }
    override func setUp() {
        viewcontroller = TestTourReviewsViewController()
        viewcontroller?.setup()
        //UI elements
        viewcontroller?.loadingView = testLoadingView
        viewcontroller?.activityIndicator = activityIndicator
        viewcontroller?.reviewsTableView = testTableView
    }
    func testDisplayReviewItems() {
        viewcontroller?.loadInitialData()
        XCTAssertTrue(testLoadingView.didCallStartLoading,
                      "Immediately after loading data from api, loading UI should be displayed")
        let fetchItemsExpectation = expectation(description: "Data is fetched successfully")
        viewcontroller?.fullFillClosure = {
            fetchItemsExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (_) in
            XCTAssertTrue(self.testLoadingView.didCallStopLoading,
                          "After successfully fetching items, loading view should be hidden")
            XCTAssertNotNil(self.viewcontroller?.viewModel,
                            "View model should be successfully parsed")
            XCTAssertEqual(self.viewcontroller?.reviews.count, 20,
                           "Initial count of reviews loaded is 20, so after successfullly fetching we should have 20")
            XCTAssertTrue(self.testTableView.wasDataReloaded,
                          "We should reload data after fetching")
        }
    }
    func testDisplayError() {
        viewcontroller?.displayError()
        XCTAssertTrue(testLoadingView.didCallRefresh, "Should allow user to refresh if there is an error")
    }
    func testLoadNextPage() {
        viewcontroller?.didFinishLoading = false
        viewcontroller?.reviews = MockData.reviews
        viewcontroller?.currentPage = 1
        viewcontroller?.currentTotal = 40
        viewcontroller?.previousTotal = 20
        viewcontroller?.loadNextPage()
        XCTAssertFalse(testLoadingView.didCallStartLoading,
                       "Only display the loading view for the initial data, if theres an error when loading more user should still be able to see the already loaded ones")
        let fetchItemsExpectation = expectation(description: "Data is fetched successfully")
        viewcontroller?.fullFillClosure = {
            fetchItemsExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { (_) in
            XCTAssertTrue(self.testLoadingView.didCallStopLoading,
                          "After successfully fetching items, loading view should be hidden")
            XCTAssertNotNil(self.viewcontroller?.viewModel,
                            "View model should be successfully parsed")
            XCTAssertEqual(self.viewcontroller?.reviews.count, 26,
                           "Mock data is 6, plus the 20 that should be loaded")
            XCTAssertFalse(self.testTableView.wasDataReloaded,
                          "Only reload data the first time, afterwards only insert required rows")
            XCTAssertTrue((self.viewcontroller?.addedNewRows ?? false),
                                                  "Should add new rows after fetching next page from backend")
        }
    }
}
