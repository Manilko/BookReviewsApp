//
//  CategoryCell.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class CategoryCell: UITableViewCell {

    // MARK: - Properties
    var tempView: UIView!
    let listName = UILabel()
    let oldestPublishedDate = UILabel()
    let newestPublishedDate = UILabel()
    let updated = UILabel()

    override func prepareForReuse() {
        super.prepareForReuse()
        tempView.removeFromSuperview()
    }

    // MARK: - Configure
    func configure(with category: Category){
        tempView = UIView()

        listName.text = category.listName
        oldestPublishedDate.text = category.oldestPublishedDate
        newestPublishedDate.text = category.newestPublishedDate
        updated.text = category.updated

        selectionStyle = .none
        backgroundColor = .clear
//        contentView.backgroundColor = .lightGray
        contentView.addSubview(tempView)

//        tempView.backgroundColor = .green
            tempView.snp.makeConstraints { make in
                make.top.equalTo(8)
                make.bottom.equalTo(-8)
                make.leading.equalTo(24)
                make.trailing.equalTo(-24)
            }

        let stackView = UIStackView()
        stackView.addArrangedSubview(listName)
        stackView.addArrangedSubview(oldestPublishedDate)
        stackView.addArrangedSubview(newestPublishedDate)
        stackView.addArrangedSubview(updated)

        tempView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-28)
        }
        stackView.axis = .vertical
        stackView.spacing = 4
    }
}


