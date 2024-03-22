//
//  MealsViewModel.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

// Helper enum to track loading states
enum AsyncStatus {
    case initial, loading, loaded, error
}

@MainActor class MealsViewModel: ObservableObject {
    //Published Variables
    @Published var meals: [Meal] = []
    @Published var basicStatus: AsyncStatus = .initial
    @Published var selectedMealDetails: MealDetails?
    @Published var detailStatus: AsyncStatus = .initial
    @Published var selectedIngredientsList: [String: String] = [:]
    @Published var featuredMeal: Meal?
    
    //Variables
    let service: MealsServiceProtocol
    
    init(service: MealsServiceProtocol = MealsService()) {
        self.service = service
    }
    
    //Functions
    
    //Function to call MealsService. Stores result into meals published variable, or sets basicStatus to error
    func getMeals() {
        Task {
            do {
                basicStatus = .loading
                
                meals = try await service.fetchBasicMealData()
                //Populate featuredMeal after awaiting fetch call
                self.produceRandomMeal()

                basicStatus = .loaded
            } catch {
                basicStatus = .error
                print("Error fetching basic meal data")
            }
        }
    }
    
    //Function to call MealsService for a particular meal.
    //Takes in a mealId as argument and stores result into selectedMealDetails published variable, or sets detailStatus to error
    func getMealDetails(id: String) {
        Task {
            do {
                detailStatus = .loading
                
                selectedMealDetails = try await service.fetchDetailedMealData(mealId: id)
                if selectedMealDetails == nil {
                    //if we had an empty array for whatever reason, set detailStatus to error
                    detailStatus = .error
                } else {
                    //Call function to create selectedIngredientsList after awaiting object from fetch call
                    self.matchMeasurementsToIngredients()
                    detailStatus = .loaded
                }
            } catch {
                detailStatus = .error
                print("Error fetching meal details data")
            }
        }
    }
    
    //Helper function to match ingredients to measurements. Stores resulting dictionary in selectedIngredientsList variable
    //JSON data returns ingredient and measurement data as object properties, so this helps convert the properties into an iterable to reduce code within View
    private func matchMeasurementsToIngredients() {
        var ingredientsList: [String] = [
            selectedMealDetails?.ingredient1 ?? "",
            selectedMealDetails?.ingredient2 ?? "",
            selectedMealDetails?.ingredient3 ?? "",
            selectedMealDetails?.ingredient4 ?? "",
            selectedMealDetails?.ingredient5 ?? "",
            selectedMealDetails?.ingredient6 ?? "",
            selectedMealDetails?.ingredient7 ?? "",
            selectedMealDetails?.ingredient8 ?? "",
            selectedMealDetails?.ingredient9 ?? "",
            selectedMealDetails?.ingredient10 ?? "",
            selectedMealDetails?.ingredient11 ?? "",
            selectedMealDetails?.ingredient12 ?? "",
            selectedMealDetails?.ingredient13 ?? "",
            selectedMealDetails?.ingredient14 ?? "",
            selectedMealDetails?.ingredient15 ?? "",
            selectedMealDetails?.ingredient16 ?? "",
            selectedMealDetails?.ingredient17 ?? "",
            selectedMealDetails?.ingredient18 ?? "",
            selectedMealDetails?.ingredient19 ?? "",
            selectedMealDetails?.ingredient20 ?? ""
        ]

        var measurementsList: [String] = [
            selectedMealDetails?.measurement1 ?? "",
            selectedMealDetails?.measurement2 ?? "",
            selectedMealDetails?.measurement3 ?? "",
            selectedMealDetails?.measurement4 ?? "",
            selectedMealDetails?.measurement5 ?? "",
            selectedMealDetails?.measurement6 ?? "",
            selectedMealDetails?.measurement7 ?? "",
            selectedMealDetails?.measurement8 ?? "",
            selectedMealDetails?.measurement9 ?? "",
            selectedMealDetails?.measurement10 ?? "",
            selectedMealDetails?.measurement11 ?? "",
            selectedMealDetails?.measurement12 ?? "",
            selectedMealDetails?.measurement13 ?? "",
            selectedMealDetails?.measurement14 ?? "",
            selectedMealDetails?.measurement15 ?? "",
            selectedMealDetails?.measurement16 ?? "",
            selectedMealDetails?.measurement17 ?? "",
            selectedMealDetails?.measurement18 ?? "",
            selectedMealDetails?.measurement19 ?? "",
            selectedMealDetails?.measurement20 ?? ""
        ]
        
        //Filter lists for blank values
        ingredientsList = ingredientsList.filter{ $0 != "" }
        measurementsList = measurementsList.filter{ $0 != "" && $0 != " "}
        
        //If there are not the same amount of ingredients to measurements we should present an empty view for ingredients list
        if ingredientsList.count != measurementsList.count {
            self.selectedIngredientsList = [:]
        } else {
            self.selectedIngredientsList = Dictionary(zip(ingredientsList, measurementsList), uniquingKeysWith: { (first, _) in first })
        }
    }
    
    //Helper function to select a featured meal. Produces a random index and stores the meal at that index into featuredMeal variable
    private func produceRandomMeal() {
        let count = self.meals.count
        let randInt = Int.random(in: 0..<count)
        
        self.featuredMeal = self.meals[randInt]
    }
}
