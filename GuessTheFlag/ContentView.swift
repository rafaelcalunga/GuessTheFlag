//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rafael Calunga on 2020-08-12.
//  Copyright © 2020 Rafael Calunga. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showScore = false
    @State private var isCorrectAnswer = false
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    
                    Text("Tap the flag of...")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        
                        withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                            self.animationAmount += 360
                        }
                    }) {
                        if self.showScore {
                            if number == self.correctAnswer {
                                FlagImage(name: self.countries[number])
                                    .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 0, y: 1, z: 0))
                            } else {
                                FlagImage(name: self.countries[number])
                                    .opacity(0.25)
                            }
                        } else {
                            FlagImage(name: self.countries[number])
                        }
                    }
                }
                if showScore {
                    Spacer()
                    
                    if isCorrectAnswer {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.largeTitle)
                            Text("Correct")
                                .foregroundColor(.green)
                                .font(.largeTitle)
                        }
                    } else {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                            Text("Wrong")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: restartGame) {
                        Text("Try another")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title)
                    .cornerRadius(40)
                }
                
                Spacer()
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if !showScore {
            isCorrectAnswer = number == correctAnswer
            showScore = true
        }
    }
    
    func restartGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showScore = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
