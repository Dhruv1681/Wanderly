import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }

            Button(action: handleLogin) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()

            // NavigationLink that becomes active when logged in
            NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                EmptyView()
            }
        }
        .padding()
    }

    private func handleLogin() {
        AuthManager.shared.signIn(email: email, password: password) { success, error in
            if let error = error {
                errorMessage = error
            } else {
                let uid = Auth.auth().currentUser?.uid ?? ""
                AuthManager.shared.fetchUserData(uid: uid) { data in
                    print("User data: \(data ?? [:])")
                    isLoggedIn = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
