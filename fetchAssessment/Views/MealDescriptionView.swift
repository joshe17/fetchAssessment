//
//  MealDescriptionView.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import SwiftUI

struct MealDescriptionView: View {
    @ObservedObject var viewModel: MealsViewModel
    @Binding var path: [HomeNavigation]
    @State private var showMoreDescription = false
    
    let mealId: String
    
    var body: some View {
        screenContents
        .onAppear {
            //Call API function to fetch mealDetails for the passed in id
            viewModel.getMealDetails(id: mealId)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var screenContents: some View {
        VStack {
            TopNavBar(path: $path, hasBackButton: true)
            
            switch viewModel.detailStatus {
            case .loaded:
                loadedContents
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
        ScrollView {
            AsyncImage(url: URL(string: viewModel.selectedMealDetails?.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(.systemGray3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Text(viewModel.selectedMealDetails?.name ?? "")
                .font(.largeTitle).bold()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            Divider()
            
            ingredientsList
            
            Divider()
            
            instructionsText
        }
    }
    
    // Error view for first time loading
    private var errorContents: some View {
        VStack {
            Spacer()
            
            Text("Error getting meal details, please try again")
            
            Button {
                viewModel.getMealDetails(id: mealId)
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
    
    private var ingredientsList: some View {
        VStack {
            HStack {
                Text("Ingredients")
                    .font(.title2).bold()
                Spacer()
            }
            .padding(.bottom)
            
            ForEach(Array(viewModel.selectedIngredientsList.keys), id: \.self) { key in
                HStack {
                    Text("• \(viewModel.selectedIngredientsList[key] ?? "")")
                        .bold()
                    Text(key)
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    private var instructionsText: some View {
        VStack {
            HStack {
                Text("Instructions")
                    .font(.title2).bold()
                Spacer()
            }
            .padding()
            
            Text(viewModel.selectedMealDetails?.instructions ?? "")
                .lineLimit(showMoreDescription ? nil : 6)
                .padding()
            
            Button {
                showMoreDescription.toggle()
            } label: {
                Image(systemName: showMoreDescription ? "chevron.compact.up" : "chevron.compact.down")
                    .resizable()
                    .frame(width: 20, height: 10)
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .padding()
    }
}

#Preview {
    MealDescriptionView(viewModel: MealsViewModel(), path: .constant([]), mealId: "52893")
}
