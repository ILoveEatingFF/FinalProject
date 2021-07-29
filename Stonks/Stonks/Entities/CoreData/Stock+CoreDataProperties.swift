//
//  Stock+CoreDataProperties.swift
//  Stonks
//
//  Created by Иван Лизогуб on 25.07.2021.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var change: NSDecimalNumber?
    @NSManaged public var companyName: String?
    @NSManaged public var logo: Data?
    @NSManaged public var logoURL: String?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var symbol: String?
    @NSManaged public var fundIndex: NSSet?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for fundIndex
extension Stock {

    @objc(addFundIndexObject:)
    @NSManaged public func addToFundIndex(_ value: FundIndex)

    @objc(removeFundIndexObject:)
    @NSManaged public func removeFromFundIndex(_ value: FundIndex)

    @objc(addFundIndex:)
    @NSManaged public func addToFundIndex(_ values: NSSet)

    @objc(removeFundIndex:)
    @NSManaged public func removeFromFundIndex(_ values: NSSet)

}

// MARK: Generated accessors for users
extension Stock {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension Stock : Identifiable {

}
