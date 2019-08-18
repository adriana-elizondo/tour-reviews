//
//  TourReviewsViewController.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    @IBOutlet weak var loadingMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    var refreshAction: (() -> Void)?
    private func showMe() {
        guard let parent = superview else { return }
        parent.bringSubviewToFront(self)
    }
    func startLoading() {
        showMe()
        refreshButton.isHidden = true
        activityIndicator.startAnimating()
        loadingMessage.text = "Loading..."
    }
    func stopLoading() {
        guard let parent = self.superview else { return }
        activityIndicator.stopAnimating()
        loadingMessage.text = ""
        parent.sendSubviewToBack(self)
    }
    func displayRefreshUI(with action: @escaping () -> Void) {
        showMe()
        refreshAction = action
        refreshButton.isHidden = false
        activityIndicator.stopAnimating()
        loadingMessage.text = "Something wen't wrong 😢\nBut don't worry, you can tap to try again!"
    }
    @IBAction func refreshTapped() {
        refreshAction?()
    }
}

protocol TourReviewsDisplayProtocol: class {
    func displayReviewItems(with viewModel: Reviews.ViewModel)
    func displayError()
}

class TourReviewsViewController: UIViewController, TourReviewsDisplayProtocol {
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reviewsTableView: UITableView! {
        didSet {
            reviewsTableView.tableFooterView = UIView()
            reviewsTableView.prefetchDataSource = self
            reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "reviewCell")
            reviewsTableView.rowHeight = UITableView.automaticDimension
            reviewsTableView.estimatedRowHeight = 100
        }
    }
    var interactor: TourReviewsBusinessLogic?
    var viewModel: Reviews.ViewModel? {
        didSet {
            if let updatedReviews = viewModel?.reviews {
                reviews += updatedReviews
            }
        }
    }
    var reviews = [Reviews.Review]()
    var currentPage = 0
    var currentTotal = 20
    var previousTotal = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        let viewcontroller = self
        let interactor = TourReviewsInteractor()
        let presenter = TourReviewsPresenter()
        presenter.viewcontroller = viewcontroller
        interactor.presenter = presenter
        self.interactor = interactor
        self.title = "Berlin-Tempelhof airport tour"
        loadInitialData()
    }
    func loadInitialData() {
        loadingView.startLoading()
        interactor?.loadReviews(in: currentPage, totalToLoad: 20)
    }
    func loadNextPage() {
        activityIndicator.startAnimating()
        interactor?.loadReviews(in: currentPage, totalToLoad: 20)
    }
    func displayReviewItems(with viewModel: Reviews.ViewModel) {
        self.viewModel = viewModel
        loadingView.stopLoading()
        activityIndicator.stopAnimating()
        guard currentPage > 0 else { reviewsTableView.reloadData(); return }
        addNewRows()
    }
    func addNewRows() {
        var indexPaths = [IndexPath]()
        for current in previousTotal..<currentTotal {
            indexPaths.append(IndexPath(row: current, section: 0))
        }
        reviewsTableView.insertRows(at: indexPaths, with: .none)
    }
    func displayError() {
        if currentPage == 0 {
            loadingView.displayRefreshUI { [weak self] in
                self?.loadInitialData()
            }
        } else {
            //retry in background
            loadNextPage()
        }
    }
}

extension TourReviewsViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as? ReviewTableViewCell {
            cell.loadData(with: reviews[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    //prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentTotal < (viewModel?.total_reviews ?? 0) else { return }
        /*
         Start loading next 3 page 3 rows before
         Load content 20 by 20
         */
        if (indexPaths.last?.row ?? 0) > (currentTotal - 3) {
            currentPage += 1
            previousTotal = currentTotal
            currentTotal += 20
            loadNextPage()
        }
    }
}
