//
//  Item.swift
//  Todoey
//
//  Created by Greg Martin on 4/7/23.
//

import Foundation
import RealmSwift
import UIKit

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
