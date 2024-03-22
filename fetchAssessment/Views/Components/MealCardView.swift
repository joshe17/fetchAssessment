//
//  MealCardView.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import SwiftUI

struct MealCardView: View {
    let meal: Meal
    
    var body: some View {
        VStack {
            image
           
            Spacer()
            
            label
        }
        .padding()
        .frame(height: 250)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: Color(UIColor.systemGray5), radius: 5)
    }
    
    private var image: some View {
        AsyncImage(url: URL(string: meal.imageUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(25)
                .frame(maxWidth: 150, maxHeight: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("periwinkle"), lineWidth: 10))
            
        } placeholder: {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(.systemGray3))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(25)
        }
        
    }
    
    private var label: some View {
        Text(meal.name)
            .foregroundColor(.black)
    }
}

#Preview {
    MealCardView(meal: Meal(id: "52893", name: "Apple & Blackberry Crumble", imageUrl: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}
