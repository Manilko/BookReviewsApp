//
//  Category.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko  on 14.07.2023.
//

import Foundation
import UIKit
import RealmSwift

final class CategorysData: Object, Codable {
    @objc dynamic var uuid: String?
    var results = List<Category>()
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
}

final class Category: Object, Codable {
    
    @objc dynamic var listName: String?
    @objc dynamic var displayName: String?
    @objc dynamic var listNameEncoded: String?
    @objc dynamic var oldestPublishedDate: String?
    @objc dynamic var newestPublishedDate: String?
    @objc dynamic var updated: String?

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
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
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        listNameEncoded = try container.decodeIfPresent(String.self, forKey: .listNameEncoded)
        oldestPublishedDate = try container.decodeIfPresent(String.self, forKey: .oldestPublishedDate)
        newestPublishedDate = try container.decodeIfPresent(String.self, forKey: .newestPublishedDate)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(listName, forKey: .listName)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(listNameEncoded, forKey: .listNameEncoded)
        try container.encodeIfPresent(oldestPublishedDate, forKey: .oldestPublishedDate)
        try container.encodeIfPresent(newestPublishedDate, forKey: .newestPublishedDate)
        try container.encodeIfPresent(updated, forKey: .updated)
    }
}
