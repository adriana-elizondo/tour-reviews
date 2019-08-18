//
//  ReviewTableViewCell.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet weak var authorAndDate: UILabel!
    func loadData(with review: Reviews.Review) {
        reviewTitle.text = review.title
        reviewTitle.sizeToFit()
        reviewMessage.text = review.message
        authorAndDate.text = "\(review.reviewerName) - \(review.reviewerCountry) • \(review.date)     \(CountryCodeEmoji.sharedInstance.emojiForCountry(with: review.reviewerCountry))"
        ratingLabel.text = starsForRating(rating: Double(review.rating) ?? 0)
    }
    private func starsForRating(rating: Double) -> String {
        guard rating > 0 else { return "" }
        var starsString = "★"
        for _ in 1...Int(rating.rounded()) {
            starsString += "★"
        }
        return starsString
    }
}
