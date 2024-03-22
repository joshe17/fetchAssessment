//
//  FeaturedRecipeView.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/19/24.
//

import SwiftUI

struct FeaturedRecipeView: View {
    var meal: Meal
    
    var body: some View {
        VStack {
            image
            
            Spacer()
            
            label
        }
        .background(Color("sage"))
        .cornerRadius(25)
        .frame(maxWidth: .infinity, maxHeight: 450)
        .shadow(color: Color(UIColor.systemGray5), radius: 10)
        .padding()
    }
    
    private var image: some View {
        ZStack {
            Color.white
            AsyncImage(url: URL(string: meal.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(.systemGray3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 350)
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }
    
    private var label: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(meal.name)
                    .font(.title2).bold()
                    .foregroundColor(.black)
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
    }

}

#Preview {
    FeaturedRecipeView(meal: Meal(id: "0000", name: "Apple & Blackberry Crumble", imageUrl: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}


//Custom ViewModifier to allow for specifying which corners to apply a corner radius to
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

//Extending to view to override default .cornerRadius() modifier
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
