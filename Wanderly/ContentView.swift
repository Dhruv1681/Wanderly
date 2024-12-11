//
//  ContentView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

import SwiftUI

struct ContentView: View {
    // Simulating user authentication state
    @State private var isUserAuthenticated = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Logo and Tagline
                Image("app_logo") // Replace with your logo asset name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.top, 40)

                Text("Wanderly")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Plan Your Perfect Journey")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()

                // Authentication Buttons
                VStack(spacing: 15) {
                    NavigationLink(destination: LoginView()) {
                        SignInButton(title: "Login")
                    }
                    
                    NavigationLink(destination: SignUpView()) {
                        SignInButton(title: "Sign Up")
                    }

                    // Continue as Guest
                    NavigationLink(destination: HomeView()) {
                        Text("Continue as Guest")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true) // Hide navigation bar for this view
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Reusable SignInButton Component
struct SignInButton: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.blue) // Adjust color as needed
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
