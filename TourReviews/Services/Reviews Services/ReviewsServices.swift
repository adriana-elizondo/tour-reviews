//
//  ReviewsServices.swift
//  TourReviews
//
//  Created by Adriana Elizondo on 2019/8/17.
//  Copyright © 2019 adriana. All rights reserved.
//

import Foundation
import NetworkLayer

struct ReviewsParamaters: Codable {
    var count = 20
    var page = 0
    var sortBy = "date_of_review"
    var direction = "desc"
}
class ReviewsService: EndpointType {
    var path: String {
        return apiPath
    }
    var httpMethod: HttpMethod { return .get }
    var parameters: ReviewsParamaters?
    var apiPath = ""
    var task: HttpTask<ReviewsParamaters> {
        let parametersDictionary = try? parameters?.toJsonDictionary()
        return HttpTask.requestWithParameters(bodyParameters: nil, queryParameters: parametersDictionary)
    }
    typealias ParameterType = ReviewsParamaters
    func loadReviews(with completion: @escaping (Reviews.Response?, NetworkResponseError?) -> Void) {
        let router = Router<ReviewsService, Reviews.Response>()
        router.request(with: self) { (response, _, error) in
            DispatchQueue.main.async {
                completion(response, error)
            }
        }
    }
}
extension EndpointType {
    var baseUrl: URL {
        return URL(string: "https://www.getyourguide.com")!
    }
}
