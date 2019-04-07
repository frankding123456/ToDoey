//
//  Item.swift
//  ToDoey
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}


