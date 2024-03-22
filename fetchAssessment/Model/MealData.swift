//
//  MealData.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

//Data type for decoding basic meal data
struct Meal: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageUrl = "strMealThumb"
    }
}
