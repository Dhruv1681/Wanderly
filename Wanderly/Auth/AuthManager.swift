//
//  AuthManager.swift
//  Wanderly
//
//  Created by Dhruv Soni on 02/12/24.
//

//import FirebaseAuth
//
//class AuthManager {
//    static let shared = AuthManager()
//
//    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(false, error.localizedDescription)
//            } else {
//                completion(true, nil)
//            }
//        }
//    }
//
//    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(false, error.localizedDescription)
//            } else {
//                completion(true, nil)
//            }
//        }
//    }
//
//    func signOut(completion: @escaping (Bool) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            completion(true)
//        } catch {
//            completion(false)
//        }
//    }
//}

import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    static let shared = AuthManager()
    private let db = Firestore.firestore() // Firestore instance

    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else if let user = authResult?.user {
                // Save user details to Firestore
                self.saveUserData(uid: user.uid, email: email) { success in
                    completion(success, success ? nil : "Failed to save user data")
                }
            }
        }
    }

    private func saveUserData(uid: String, email: String, completion: @escaping (Bool) -> Void) {
        let userData: [String: Any] = [
            "uid": uid,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping ([String: Any]?) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                completion(document.data())
            } else {
                print("User data not found")
                completion(nil)
            }
        }
    }

    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("users").document(uid).updateData(data) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }


    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
