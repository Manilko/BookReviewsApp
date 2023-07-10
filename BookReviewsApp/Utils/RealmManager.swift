//
//  RealmManager.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private func getRealm() -> Realm {
        if NSClassFromString("XCTest") != nil {
            let configuration = Realm.Configuration(fileURL: nil,
                                                    inMemoryIdentifier: "realmTest",
                                                    encryptionKey: nil,
                                                    readOnly: false,
                                                    schemaVersion: 0,
                                                    migrationBlock: nil,
                                                    objectTypes: nil)
            // swiftlint:disable:next force_try
            return try! Realm( configuration: configuration)
        } else {
            // swiftlint:disable:next force_try
            return try! Realm()
        }
    }

    /// With check isRealmAccessible
    /// - Parameters:
    /// - Returns: Oprional Resluts
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }

        let realm = getRealm()
        realm.refresh()

        if let predicate = predicate {
            return realm.objects(type).filter(predicate)
        }

        return realm.objects(type)
    }

    /// Without check isRealmAccessible
    /// - Parameters:
    /// - Returns: Resluts
    func getObjects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T> {
        let realm = getRealm()
        realm.refresh()

        if let predicate = predicate {
            return realm.objects(type).filter(predicate)
        }

        return realm.objects(type)
    }

    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        if !isRealmAccessible() { return nil }

        let realm = getRealm()
        realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Object>(_ data: [T], update: Bool = true) {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()

        if realm.isInWriteTransaction {
            realm.add(data, update: .modified)
        } else {
            try? realm.write {
                realm.add(data, update: .modified)
            }
        }
    }

    func add<T: Object>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }

    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()

        try? realm.write {
            action()
        }
    }

    func delete<T: Object>(_ data: [T]) {
        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.delete(data) }
    }

    func delete<T: Object>(_ data: T) {
        delete([data])
    }

    func delete<T: Object>(_ objects: Results<T>?) {
        let realm = getRealm()
        realm.refresh()
        if let objects = objects {
            try? realm.write { realm.delete(objects) }
        }
    }

    func clearAllData() {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.deleteAll() }
    }

    func rewrite<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil, objects: [T]) {
        let realm = getRealm()
        realm.refresh()

        let results: Results<T>

        if let predicate = predicate {
            results = realm.objects(type).filter(predicate)
        } else {
            results = realm.objects(type)
        }

        try? realm.write {
            realm.delete(results)
            realm.add(objects, update: .all)
        }
    }
}

extension RealmManager {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            AppLogger.log(level: .error, "Realm is not accessible")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = Realm.Configuration(
          schemaVersion: 2,

//          migrationBlock: { _, _ in
//          },
            deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config

    }
}


