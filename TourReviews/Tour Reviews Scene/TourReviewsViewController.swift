//
//  TourReviewsViewController.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit
protocol TourReviewsDisplayProtocol: class {
    func displayReviewItems(with viewModel: Reviews.ViewModel)
    func displayError()
}

class TourReviewsViewController: UIViewController, TourReviewsDisplayProtocol {
    @IBOutlet weak var reviewsTableView: UITableView! {
        didSet {
            reviewsTableView.tableFooterView = UIView()
            reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil),
            forCellReuseIdentifier: "reviewCell")
            reviewsTableView.rowHeight = UITableView.automaticDimension
            reviewsTableView.estimatedRowHeight = 100
        }
    }
    private var interactor: TourReviewsBusinessLogic?
    private var viewModel: Reviews.ViewModel? {
        didSet {
            if let updatedReviews = viewModel?.reviews {
                reviews = updatedReviews
            }
        }
    }
    private var reviews = [Reviews.Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        let viewcontroller = self
        let interactor = TourReviewsInteractor()
        let presenter = TourReviewsPresenter()
        presenter.viewcontroller = viewcontroller
        interactor.presenter = presenter
        self.interactor = interactor
        interactor.loadReviews(in: 0, totalToLoad: 20)
    }
    func displayReviewItems(with viewModel: Reviews.ViewModel) {
        self.viewModel = viewModel
        reviewsTableView.reloadData()
    }
    func displayError() {}
}

extension TourReviewsViewController: UITableViewDataSource, UITableViewDelegate {
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
}
