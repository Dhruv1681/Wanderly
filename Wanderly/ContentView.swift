//
//  ContentView.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isUserAuthenticated = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // App Logo
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .padding(.top, 60)
                        .shadow(radius: 8)

                    // App Title and Tagline
                    VStack(spacing: 8) {
                        Text("Wanderly")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(Color.blue)

                        Text("Plan Your Perfect Journey")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    
                    // Authentication Buttons
                    VStack(spacing: 15) {
//                        NavigationLink(destination: LoginView()) {
//                            SignInButton(title: "Login")
//                        }
//
//                        NavigationLink(destination: SignUpView()) {
//                            SignInButton(title: "Sign Up")
//                        }
//                        
                        // Continue as Guest
                        NavigationLink(destination: HomeView()) {
                            Text("Welcome to Wanderly!")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
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
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                startPoint: .leading, endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 3)
    }
}

// Preview
#Preview {
    ContentView()
}
