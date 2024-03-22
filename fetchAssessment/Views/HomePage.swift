//
//  HomePage.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import SwiftUI

enum HomeNavigation: Hashable {
    case child(String)
}

struct HomePage: View {
    @StateObject var viewModel = MealsViewModel()
    @State private var seeMore = false
    @State private var path = [HomeNavigation]()
    @State private var scrollTarget: String = ""
    @State private var isScrolling: Bool = false
    @State private var scrollingOutsideAlphabetBar: Bool = true
   
    var body: some View {
        NavigationStack(path: $path) {
            screenContents
                .navigationDestination(for: HomeNavigation.self) { page in
                    switch page {
                    case .child(let str): MealDescriptionView(viewModel: viewModel, path: $path, mealId: str)
                    }
                }
        }
        .onAppear {
            viewModel.getMeals()
        }
    }
    
    //if first loading page, return corresponding view based on status
    private var screenContents: some View {
        VStack {
            TopNavBar(path: $path, hasBackButton: false)
            
            switch viewModel.basicStatus {
            case .loaded:
                if viewModel.meals.count > 0 {
                    loadedContents
                } else {
                    emptyContents
                }
            case .error:
                errorContents
            case .loading:
                loadingContents
            case .initial:
                initialContents
            }
        }
    }
    
    // main view once meals is loaded
    private var loadedContents: some View {
        ScrollViewReader { value in
            ScrollView(showsIndicators: false) {
                panelAndList
                    .background(GeometryReader { geometry in
                        Color.clear
                            .onChange(of: geometry.frame(in: .named("scroll")).origin) {
                                isScrolling = true
                                scrollingOutsideAlphabetBar = true
                            }
                    })
            }
            .coordinateSpace(name: "scroll")
            .overlay {
                if seeMore && isScrolling {
                    AlphabetScrollBar(scrollTarget: $scrollTarget, stillScrolling: $isScrolling, scrolledOutside: $scrollingOutsideAlphabetBar, proxy: value)
                }
            }
        }
    }
    
    // view if meals api works but returns empty array
    private var emptyContents: some View {
        VStack {
            Spacer()
            Text("No meals data available.")
            Button {
                viewModel.getMeals()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
            }
            Spacer()
        }
    }
    
    // Error view for first time loading
    private var errorContents: some View {
        VStack {
            Spacer()
            
            Text("Error getting meals, please try again")
            
            Button {
                viewModel.getMeals()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
            }
            
            Spacer()
        }
    }
    
    // Intermediate view for initial loading of meals
    private var loadingContents: some View {
        VStack {
            Spacer()
            
            Text("Loading...")
            
            Spacer()
        }
    }
    
    // Default state before we load breeds for first time
    private var initialContents: some View {
        VStack {
            Spacer()
            
            Text("Waiting to load...")
            
            Spacer()
        }
    }
    
    private var panelAndList: some View {
        LazyVStack{
            featuredPanel
            MealsListView(meals: viewModel.meals, seeMore: $seeMore, isScrolling: $isScrolling)
                .coordinateSpace(name: "grid")
        }
    }
    
    private var featuredPanel: some View {
        Group {
            title
            NavigationLink(value: HomeNavigation.child(viewModel.featuredMeal?.id ?? "")) {
                FeaturedRecipeView(meal: viewModel.featuredMeal ?? Meal(id: "", name: "", imageUrl: ""))
            }
        }
        .padding(.horizontal)

    }
    
    private var title: some View {
        HStack {
            Text("Featured Dessert")
                .font(.largeTitle).bold()
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    HomePage()
}
