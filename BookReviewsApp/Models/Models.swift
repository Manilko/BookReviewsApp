//
//  Models.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import UIKit
import RealmSwift

struct CategorysData: Codable {
    let results: [Category]
}

struct Category: Codable {
    let listName: String?
    let displayName: String?
    let listNameEncoded: String?
    let oldestPublishedDate: String?
    let newestPublishedDate: String?
    let updated: String?

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
        case updated
    }
}


struct BookData: Codable {
    let results: [Book]
}

struct Book: Codable {
    let listName: String?
    let amazonProductUrl: String?
    let publishedDate: String?
    let bookDetails: [BookDetails]
    let displayName: String?
    let listNameEncoded: String?
    let oldestPublishedDate: String?
    let newestPublishedDate: String?
    let updated: String?

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case amazonProductUrl = "amazon_product_url"
        case publishedDate = "published_date"
        case bookDetails = "book_details"

        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
        case updated
    }
}

struct BookDetails: Codable {
    let title: String?
    let description: String?
    let contributor: String?
    let author: String?
    let price: String?
    let publisher: String?
}

