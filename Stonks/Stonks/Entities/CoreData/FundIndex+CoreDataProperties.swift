//
//  FundIndex+CoreDataProperties.swift
//  Stonks
//
//  Created by Иван Лизогуб on 27.07.2021.
//
//

import Foundation
import CoreData


extension FundIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundIndex> {
        return NSFetchRequest<FundIndex>(entityName: "FundIndex")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var allCompanySymbols: String?
    @NSManaged public var companySymbols: NSSet?

}

// MARK: Generated accessors for companySymbols
extension FundIndex {

    @objc(addCompanySymbolsObject:)
    @NSManaged public func addToCompanySymbols(_ value: Stock)

    @objc(removeCompanySymbolsObject:)
    @NSManaged public func removeFromCompanySymbols(_ value: Stock)

    @objc(addCompanySymbols:)
    @NSManaged public func addToCompanySymbols(_ values: NSSet)

    @objc(removeCompanySymbols:)
    @NSManaged public func removeFromCompanySymbols(_ values: NSSet)

}

extension FundIndex : Identifiable {

}
