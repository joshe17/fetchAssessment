//
//  MealsListView.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/19/24.
//

import SwiftUI

struct MealsListView: View {
    let meals: [Meal]
    @Binding var seeMore: Bool
    @Binding var isScrolling: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    var body: some View {
        Group {
            dessertsTitle
            
            if !seeMore {
                previewMealGrid
                seeMoreButton
            } else {
                sectionedWholeMealGrid
                seeLessButton
            }
        }
    }
    
    private var dessertsTitle: some View {
        HStack {
            Text("Available Recipes")
                .font(.largeTitle).bold()
            Spacer()
        }
        .padding()
    }
    
    private var previewMealGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(meals.prefix(6)) { meal in
                NavigationLink(value: HomeNavigation.child(meal.id)) {
                    MealCardView(meal: meal)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
    }
    
    private var sectionedWholeMealGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(alphabet, id: \.self) { letter in
                Group {
                    ForEach(meals.filter{ $0.name.hasPrefix(letter) }) { meal in
                        NavigationLink(value: HomeNavigation.child(meal.id)) {
                            MealCardView(meal: meal)
                        }
                    }
                    .id(letter)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
    }
    
    private var seeMoreButton: some View {
        Button {
            seeMore.toggle()
        } label: {
            HStack {
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.leading)
                Text("See More")
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.trailing)
                    .padding(.vertical, 5)
            }
        }
        .cornerRadius(20)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .padding()
    }
    
    private var seeLessButton: some View {
        Button {
            seeMore.toggle()
        } label: {
            HStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.leading)
                Text("See Less")
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.trailing)
                    .padding(.vertical, 5)
            }
        }
        .cornerRadius(20)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    MealsListView(meals: [Meal(id: "0000", name: "Apple & Blackberry Crumble", imageUrl: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")], seeMore: .constant(false), isScrolling: .constant(false))
}
