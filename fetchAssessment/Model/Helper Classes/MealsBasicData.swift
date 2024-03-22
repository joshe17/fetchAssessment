//
//  MealsBasicData.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

//Helper data structure to actually decode data
//JSON object returns as {meals:[]}, this helps reduce redundancy of having to access obj.meals every time we want to access an element
struct MealsBasicData: Decodable {
    let meals: [Meal]
}
