//
//  ResponseModels.swift
//  ordersApp
//
//  Created by Asmaa Mohamed on 09/08/2023.
//

import Foundation
struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct CategoriesResponse: Codable {
    let categories: [String]
}


struct OrderResponse: Codable {
    let prepTime: Int

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}


