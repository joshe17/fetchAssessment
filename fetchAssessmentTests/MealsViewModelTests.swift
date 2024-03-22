//
//  MealsViewModelTests.swift
//  fetchAssessmentTests
//
//  Created by Joshua Ho on 3/21/24.
//

import XCTest
@testable import fetchAssessment
import Combine

final class MealsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = Set<AnyCancellable>()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test to ensure that getMeals() successfully calls api and populates meals published variable
    func test_getMeals_success() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsSuccess))

        let exp = XCTestExpectation(description: "expecting fetch success")
        
        await viewModel.getMeals()
        
        await viewModel.$meals
            .dropFirst()
            .sink { meals in
                XCTAssertFalse(meals.isEmpty)
                XCTAssertEqual(meals.count, 65)
                let first = meals.first!
                print(first)
                XCTAssertEqual(first.id, "53049")
                XCTAssertEqual(first.name, "Apam balik")
                XCTAssertEqual(first.imageUrl, "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            }
            .store(in: &cancellables)
        
        await viewModel.$basicStatus
            .dropFirst()
            .sink { s in
                XCTAssert(s == .loaded)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that if getMeals() fails, we change basicStatus published variable to error when finding error in basic fetch
    func test_getMeals_failure() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsFailure, detail: .getMealDetailsSuccess))

        let exp = XCTestExpectation(description: "expecting fetch failure")
        
        await viewModel.getMeals()
        
        await viewModel.$basicStatus
            .dropFirst()
            .sink { s in
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that getMealDetails() successfully calls api and populates selectedMealDetails published variable
    func test_getMealDetails_success() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsSuccess))

        let exp = XCTestExpectation(description: "expecting fetch success")
        
        await viewModel.getMealDetails(id: "52768")
        
        await viewModel.$selectedMealDetails
            .dropFirst()
            .sink { meal in
                XCTAssertEqual(meal?.id, "52768")
                XCTAssertEqual(meal?.name, "Apple Frangipan Tart")
                XCTAssertEqual(meal?.imageUrl, "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
                XCTAssertGreaterThan(meal?.instructions?.count ?? 0, 1)
                XCTAssertEqual(meal?.videoLink, "https://www.youtube.com/watch?v=rp8Slv4INLk")
                XCTAssertFalse(meal?.instructions?.isEmpty ?? true)
                XCTAssertEqual(meal?.ingredient9, "flaked almonds")
                XCTAssertNotEqual(meal?.measurement9, "")
                XCTAssertNil(meal?.ingredient16)
                XCTAssertNil(meal?.ingredient17)
            }
            .store(in: &cancellables)
        
        await viewModel.$detailStatus
            .dropFirst()
            .sink { s in
                XCTAssert(s == .loaded)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that if getMealDetails() fails, we change detailStatus published variable to error when finding error in basic fetch
    func test_getMealDetails_failure() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsFailure))

        let exp = XCTestExpectation(description: "expecting fetch failure")
        
        await viewModel.getMealDetails(id: "52768")

        await viewModel.$detailStatus
            .dropFirst()
            .sink { s in
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that if json returns an empty array, getMealDetails() fails and we change detailStatus published variable to error
    func test_getMealDetails_with_empty_response() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsEmpty))

        let exp = XCTestExpectation(description: "expecting empty meal details")
        
        await viewModel.getMealDetails(id: "")

        await viewModel.$selectedMealDetails
            .dropFirst()
            .sink { empty in
                XCTAssertNil(empty)
            }
            .store(in: &cancellables)
        
        await viewModel.$detailStatus
            .dropFirst()
            .sink { s in
                XCTAssertEqual(s, .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that matchMeasurementsToIngredients() is called when we call getMealDetails() and populates selectedIngredientsList published variable
    func test_matchMeasurementsToIngredients() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsSuccess))

        let exp = XCTestExpectation(description: "expecting properly matched dictionary")
        
        await viewModel.getMealDetails(id: "52768")
        
        await viewModel.$selectedIngredientsList
            .dropFirst()
            .sink { list in
                XCTAssertFalse(list.isEmpty)
                XCTAssertEqual(list.count, 9)
                let first = list.first!
                XCTAssertNotEqual(first.key, "")
                XCTAssertNotEqual(first.key, " ")
                XCTAssertNotEqual(first.value, "")
                XCTAssertNotEqual(first.value, " ")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that produceRandomMeal() is called when we call getMeals() and populates featuredMeal published variable
    func test_produceRandomMeal() async throws {
        let viewModel = await MealsViewModel(service: MockMealsService(basic: .getMealsSuccess, detail: .getMealDetailsSuccess))

        let exp = XCTestExpectation(description: "expecting featuredMeal is populated")
        
        await viewModel.getMeals()
        
        await viewModel.$featuredMeal
            .dropFirst()
            .sink { meal in
                XCTAssertNotNil(meal)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
}


enum FileName: String {
    case getMealsSuccess, getMealsFailure, getMealDetailsSuccess, getMealDetailsFailure, getMealDetailsEmpty
}

// Mock service for testing. Allows us to test results from bundle without having to make unnecessary calls to the network
class MockMealsService: MealsServiceProtocol {
    let basicFileName: FileName
    let detailFileName: FileName
    
    init(basic: FileName, detail: FileName) {
        self.basicFileName = basic
        self.detailFileName = detail
    }
    
    func loadMockData(file: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: file, withExtension: "json")
    }

    
    func fetchBasicMealData() async throws -> [fetchAssessment.Meal] {
        guard let url = loadMockData(file: basicFileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        
        do {
            let json = try JSONDecoder().decode(fetchAssessment.MealsBasicData.self, from: data)
            return json.meals
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
    
    func fetchDetailedMealData(mealId: String) async throws -> fetchAssessment.MealDetails? {
        guard let url = loadMockData(file: detailFileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        
        do {
            let json = try JSONDecoder().decode(fetchAssessment.MealsDetails.self, from: data)
            return json.meals.first ?? nil
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
}
