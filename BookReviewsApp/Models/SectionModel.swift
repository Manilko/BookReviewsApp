//
//  SectionModel.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import RxDataSources

struct SectionModel {
    var hesder: String
    var items: [Category]
}

extension SectionModel: SectionModelType{
    init(original: SectionModel, items: [Category]) {
        self = original
        self.items = items
    }
}

struct SectionBookModel {
    var hesder: String
    var items: [Book]
}

extension SectionBookModel: SectionModelType{
    init(original: SectionBookModel, items: [Book]) {
        self = original
        self.items = items
    }
}

