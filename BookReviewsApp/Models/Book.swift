//
//  Book.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko  on 14.07.2023.
//

import Foundation
import UIKit
import RealmSwift

class BookData: Object, Codable {
    var results = List<Book>()
}

class Book: Object, Codable {
    @objc dynamic var listName: String?
    @objc dynamic var amazonProductUrl: String?
    @objc dynamic var publishedDate: String?
    var bookDetails = List<BookDetails>()
    @objc dynamic var displayName: String?
    @objc dynamic var listNameEncoded: String?
    @objc dynamic var oldestPublishedDate: String?
    @objc dynamic var newestPublishedDate: String?
    @objc dynamic var updated: String?

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
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listName = try container.decodeIfPresent(String.self, forKey: .listName)
        amazonProductUrl = try container.decodeIfPresent(String.self, forKey: .amazonProductUrl)
        publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        bookDetails = try container.decodeIfPresent(List<BookDetails>.self, forKey: .bookDetails) ?? List<BookDetails>()
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        listNameEncoded = try container.decodeIfPresent(String.self, forKey: .listName)
        oldestPublishedDate = try container.decodeIfPresent(String.self, forKey: .oldestPublishedDate)
        newestPublishedDate = try container.decodeIfPresent(String.self, forKey: .newestPublishedDate)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(listName, forKey: .listName)
        try container.encodeIfPresent(amazonProductUrl, forKey: .amazonProductUrl)
        try container.encodeIfPresent(publishedDate, forKey: .publishedDate)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(listNameEncoded, forKey: .listNameEncoded)
        try container.encodeIfPresent(oldestPublishedDate, forKey: .oldestPublishedDate)
        try container.encodeIfPresent(newestPublishedDate, forKey: .newestPublishedDate)
        try container.encodeIfPresent(updated, forKey: .updated)
    }
    
}

class BookDetails: Object, Codable {
    @objc dynamic var title: String?
    @objc dynamic var descriptionValue: String?
    @objc dynamic var contributor: String?
    @objc dynamic var author: String?
    @objc dynamic var price: String?
    @objc dynamic var publisher: String?
    
    enum CodingKeys: String, CodingKey {
        case descriptionValue = "description"
        case title
        case contributor
        case author
        case price
        case publisher
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
        contributor = try container.decodeIfPresent(String.self, forKey: .contributor)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(descriptionValue, forKey: .descriptionValue)
        try container.encodeIfPresent(contributor, forKey: .contributor)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(publisher, forKey: .publisher)
    }
    
}
