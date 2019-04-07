//
//  Category.swift
//  ToDoey
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
