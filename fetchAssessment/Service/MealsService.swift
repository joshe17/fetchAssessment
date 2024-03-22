//
//  MealsService.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

protocol MealsServiceProtocol {
    func fetchBasicMealData() async throws -> [Meal]
    func fetchDetailedMealData(mealId: String) async throws -> MealDetails?
}

class MealsService: MealsServiceProtocol {
    let basicDataUrl = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    let detailedDataBaseUrl = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    
    //Function that calls the basic Meal Data API for the Dessert Category. Returns an array of type [Meal]
    func fetchBasicMealData() async throws -> [Meal] {
        let urlString = basicDataUrl

        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, 200...299 ~= resp.statusCode else { throw APIError.invalidResponse }
        
        do {
            let json =  try JSONDecoder().decode(MealsBasicData.self, from: data)
            //returning json.meals since api returns a json object with an unnecessary attr. title "meals" -> prevents having to specify meals everytime
            return json.meals
        } catch {
            throw APIError.decodingError
        }
    }
    
    //Function that calls the detailed Meal Data API for more information by looking up a specific meal. Takes in a mealId as an argument and returns data for given id as type MealsDetails
    func fetchDetailedMealData(mealId: String) async throws -> MealDetails? {
        let urlString = detailedDataBaseUrl + mealId
        
        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, 200...299 ~= resp.statusCode else { throw APIError.invalidResponse }
        
        do {
            let json =  try JSONDecoder().decode(MealsDetails.self, from: data)
            //returning json.meals.first since api returns a json object (str: []) with an unnecessary attr. title "meals" -> prevents having to specify meals everytime
            return json.meals.first ?? nil
        } catch {
            throw APIError.decodingError
        }
    }
}
