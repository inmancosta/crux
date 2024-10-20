import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let email: String
    let photoUrl: String?
    let dateCreated: Date?
let     isOnboarded: Bool
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
        let dateCreated = data["date_created"] as? Date
        let isOnboarded = data["isOnboarded"] as? Bool ?? false // Provide a default value if nil


        return DBUser(
            userId: userId,
            email: email,
            photoUrl: photoUrl,
            dateCreated: dateCreated,
            isOnboarded: isOnboarded
        )
    }

    func updateUserDetails(userId: String, name: String, githubUsername: String, schoolGradYear: String, preferences: [String]) async throws {
            let userRef = Firestore.firestore().collection("users").document(userId)
            try await userRef.updateData([
                "name": name,
                "githubUsername": githubUsername,
                "schoolGradYear": schoolGradYear,
                "preferences": preferences,
                "isOnboarded": true
            ])
        }

    
}
