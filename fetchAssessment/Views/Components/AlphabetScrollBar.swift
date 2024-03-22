//
//  AlphabetScrollBar.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/19/24.
//

import SwiftUI

struct AlphabetScrollBar: View {
    @Binding var scrollTarget: String
    @Binding var stillScrolling: Bool
    @Binding var scrolledOutside: Bool
    @State private var oldScrollTarget: String = " "
    var proxy: ScrollViewProxy //ScrollViewProxy to keep track of where to navigate to in list

    @GestureState private var dragLocation: CGPoint = .zero //GestureState to allow for changing scroll bar location by dragging
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        alphabetBar
            .padding(.trailing, 3)
            .onAppear { //Whenever alphabet bar appears
                //Reset scroll indicator mark if we move outside of alphabet bar
                if scrolledOutside {
                    scrollTarget = ""
                }
                //Hide scrollbar after inactivity
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                    withAnimation(.easeInOut(duration: 1)) {
                        stillScrolling = false
                    }
                }
            }
            .onChange(of: stillScrolling) { //when we start scrolling again
                if stillScrolling {
                    //Reset scroll indicator mark if we move outside of alphabet bar
                    if scrolledOutside {
                        scrollTarget = ""
                    }
                    //Hide scrollbar after inactivity
                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                        withAnimation(.easeInOut(duration: 1)) {
                            stillScrolling = false
                        }
                    }
                }
            }
    }
    
    private var alphabetBar: some View {
        HStack{
            Spacer()
            alphabetList
                .gesture( //Update dragLocation to see where user's pointer is in coordinate space
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .updating($dragLocation) { value, state, _ in
                            state = value.location
                            stillScrolling = true
                        }
                )
                .onChange(of: scrollTarget) { //navigate to target letter when we select a new one
                    withAnimation {
                        proxy.scrollTo(scrollTarget)
                    }
                    //if we're still scrolling. check if we're changing the target, if not hide bar
                    if stillScrolling {
                        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                            if oldScrollTarget == scrollTarget {
                                withAnimation(.easeInOut(duration: 1)) {
                                    stillScrolling = false
                                }
                            } else {
                                oldScrollTarget = scrollTarget
                            }
                        }
                    }
                }
        }
    }
    
    private var alphabetList: some View {
        VStack {
            ForEach(0..<alphabet.count, id: \.self) { idx in
                Text(alphabet[idx])
                    .font(.system(size: 13))
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 0.5)
                    .background(scrollTarget == alphabet[idx] ? Color(UIColor.systemGray5) : Color.clear)
                    .cornerRadius(5)
                    .onTapGesture {
                        scrollTarget = alphabet[idx]
                        scrolledOutside = false
                    }
                    .background(dragObserver(letterDestination: alphabet[idx]))
            }
        }
    }
    
    //Function that uses Geometry Reader to read which letter is selected: takes in a letter destination, and returns a view
    func dragObserver(letterDestination: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, letterDestination: letterDestination)
        }
      }

    //Function to handle logic of Geometry Reader for dragObserver(): checks if dragLocation contains letterDestination, and sets scrollTarget to targeted one. Returns clear view
    private func dragObserver(geometry: GeometryProxy, letterDestination: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
          // we need to dispatch to the main queue because we cannot access to the
          // `ScrollViewProxy` instance while the body is rendering
          DispatchQueue.main.async {
            scrollTarget = letterDestination
          }
        }
        return Rectangle().fill(Color.clear)
      }
}

//#Preview {
//    AlphabetScrollBar()
//}
