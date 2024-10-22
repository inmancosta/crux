import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let email: String
    let photoUrl: String?
    let dateCreated: Date?
    let isOnboarded: Bool
    let githubUsername: String? // Removed the extra comma
    let name: String
    let schoolGradYear: String
    let preferences: [String]
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
        
        try await Firestore.firestore()
            .collection("users")
            .document(auth.uid)
            .setData(userData, merge: false)
    }
        
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument()

        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }

        let email = data["email"] as? String ?? "" // Provide a default value if nil

        let photoUrl = data["photo_url"] as? String
        let githubUsername = data["githubUsername"] as? String
        let name = data["name"] as? String
        let schoolGradYear = data["schoolGradYear"] as? String
        let dateCreated = data["date_created"] as? Date
        let isOnboarded = data["isOnboarded"] as? Bool ?? false // Provide a default value if nil
        let preferences = data["preferences"] as? [String] ?? [] // Provide a default empty array if nil

        


        return DBUser(
            userId: userId,
            email: email,
            photoUrl: photoUrl,
            dateCreated: dateCreated,
            isOnboarded: isOnboarded,
            githubUsername: githubUsername, // Already an optional, no need to unwrap
            name: name ?? "", // Unwrap with a default value
            schoolGradYear: schoolGradYear ?? "" ,// Unwrap with a default value,
            preferences: preferences
        )


    }

    func updateUserDetails(userId: String, name: String, githubUsername: String, schoolGradYear: String, preferences: [String], photoUrl: String?) async throws {
        let userRef = Firestore.firestore().collection("users").document(userId)
        var updateData: [String: Any] = [
            "name": name,
            "githubUsername": githubUsername,
            "schoolGradYear": schoolGradYear,
            "preferences": preferences,
            "isOnboarded": true
        ]
        
        if let photoUrl = photoUrl {
            updateData["photo_url"] = photoUrl
        }

        try await userRef.updateData(updateData)
    }


    
}
