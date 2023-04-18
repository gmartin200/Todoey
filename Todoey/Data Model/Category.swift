//
//  Category.swift
//  Todoey
//
//  Created by Greg Martin on 4/7/23.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
