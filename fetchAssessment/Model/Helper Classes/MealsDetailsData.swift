//
//  MealsDetailsData.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

//Helper data structure to actually decode data
//JSON object returns as {meals:[]}, this helps reduce redundancy of having to access meals.first() every time we want to access an attribute
struct MealsDetails: Decodable {
    let meals: [MealDetails]
}
