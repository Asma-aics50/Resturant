//
//  Order.swift
//  ordersApp
//
//  Created by Asmaa Mohamed on 09/08/2023.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]

    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
