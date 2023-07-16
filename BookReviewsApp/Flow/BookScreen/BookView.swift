//
//  BookView.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import UIKit


final class BookView: UIView {

    // MARK: - Properties
    var booksTabele: UITableView = {
         let tableView = UITableView(frame: .zero, style: .grouped)
         tableView.backgroundColor = .clear
         tableView.estimatedRowHeight = 240
         tableView.rowHeight = UITableView.automaticDimension
         tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .singleLine
//         tableView.backgroundColor = .red
         tableView.bounces = false
         return tableView
    }()

    // MARK: - Lifecycle
    required init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {

        backgroundColor = .white
        addSubview(booksTabele)

        booksTabele.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-32)
        }
    }

}


