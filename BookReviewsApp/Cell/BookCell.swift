//
//  BookCell.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class BookCell: UITableViewCell {

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var tempView: UIView!
    let title = UILabel()
    let descriptionBook = UILabel()
    let author = UILabel()
    let publisher = UILabel()
    let button = UIButton()

    override func prepareForReuse() {
        super.prepareForReuse()
        tempView.removeFromSuperview()
    }

    // MARK: - Configure
    func configure(with book: Book, closure: @escaping (String)->(Void)){
        tempView = UIView()

        button.setTitle("BUY", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).withAlphaComponent(1.0)
        button.layer.cornerRadius = 12


        title.text = "name: " + (book.bookDetails.first?.title ?? "")
        descriptionBook.text = book.bookDetails.first?.description
        author.text = "author: " + (book.bookDetails.first?.author ?? "")
        publisher.text = "published by: " + (book.bookDetails.first?.publisher ?? "")

        descriptionBook.numberOfLines = 0
        descriptionBook.font = descriptionBook.font.withSize(10)
        selectionStyle = .none
        backgroundColor = .clear
//        contentView.backgroundColor = .red
        contentView.addSubview(tempView)

//        tempView.backgroundColor = .green
        tempView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
        }

        let stackView = UIStackView()


        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(descriptionBook)
        stackView.addArrangedSubview(author)
        stackView.addArrangedSubview(publisher)
        stackView.addArrangedSubview(button)

        tempView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-24)
        }

        stackView.axis = .vertical
        stackView.spacing = 4

        button.rx.tap
            .subscribe(onNext: { _ in
                closure(book.amazonProductUrl ?? "")
            })
            .disposed(by: disposeBag)
    }
}


