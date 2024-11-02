import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProjectManager {
    
    static let shared = ProjectManager()
    private init() {}

    // Upload a new project to Firestore
    func uploadProject(project: Project, userId: String) async throws {
        let projectData: [String: Any] = [
            "id": project.id,
            "name": project.name,
            "description": project.description,
            "tags": project.tags,
            "createdBy": project.createdBy,
            "creatorId": userId,
            "skills": project.skills,
            "dateCreated": Timestamp(),
            "difficultyLevel": project.difficultyLevel,
            "joinRequests": []  // Initialize as an empty array
        ]

        
        try await Firestore.firestore()
            .collection("projects")
            .document(project.id)
            .setData(projectData)
    }
    
    func requestToJoinProject(projectId: String) async throws {
        guard let userId = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("User not authenticated")
            return
        }

        let projectRef = Firestore.firestore().collection("projects").document(projectId)
        
        try await projectRef.updateData([
            "joinRequests": FieldValue.arrayUnion([userId])
        ])
    }


    // Fetch all projects from Firestore
    func fetchProjects() async throws -> [Project] {
        let snapshot = try await Firestore.firestore().collection("projects").getDocuments()
        
        let projects: [Project] = snapshot.documents.compactMap { document in
            try? document.data(as: Project.self) // Deserialize Firestore data into Project model
        }
        
        return projects
    }
    
    // Fetch recommended projects based on user preferences
        func fetchRecommendedProjects(userPreferences: [String]) async throws -> [Project] {
            let allProjects = try await fetchProjects() // Fetch all projects
            let recommendedProjects = allProjects.filter { project in
                // Check if any tag in the project matches a user preference
                !Set(project.tags).intersection(Set(userPreferences)).isEmpty
            }
            return recommendedProjects
        }
    
    // Fetch requesters' details based on user IDs in the join requests
        func fetchRequesters(for projectId: String) async throws -> [(userId: String, name: String)] {
            let projectDoc = try await Firestore.firestore().collection("projects").document(projectId).getDocument()
            
            guard let projectData = projectDoc.data(),
                  let joinRequests = projectData["joinRequests"] as? [String] else {
                return []
            }
            
            var requesters: [(userId: String, name: String)] = []
            
            for userId in joinRequests {
                let userDoc = try await Firestore.firestore().collection("users").document(userId).getDocument()
                
                if let userData = userDoc.data(),
                   let name = userData["name"] as? String {
                    requesters.append((userId: userId, name: name))
                }
            }
            
            return requesters
        }
        
        // Accept a join request by moving the user from joinRequests to project members
    func acceptJoinRequest(projectId: String, userId: String) async throws {
        let projectRef = Firestore.firestore().collection("projects").document(projectId)
        
        try await Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            do {
                // Fetch the project document within the transaction
                let projectDoc = try transaction.getDocument(projectRef)
                
                var joinRequests = projectDoc.data()?["joinRequests"] as? [String] ?? []
                var members = projectDoc.data()?["members"] as? [String] ?? []
                
                // Remove the user ID from joinRequests and add it to members
                joinRequests.removeAll { $0 == userId }
                members.append(userId)
                
                // Update the transaction with the modified joinRequests and members
                transaction.updateData(["joinRequests": joinRequests, "members": members], forDocument: projectRef)
            } catch {
                // If an error occurs, set it to the NSErrorPointer to indicate transaction failure
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            return nil
        }
    }

        
        // Decline a join request by removing the user from joinRequests
        func declineJoinRequest(projectId: String, userId: String) async throws {
            let projectRef = Firestore.firestore().collection("projects").document(projectId)
            
            try await projectRef.updateData([
                "joinRequests": FieldValue.arrayRemove([userId])
            ])
        }
}

extension ProjectManager {
    func fetchProjectsCreatedByUser(userId: String) async throws -> [Project] {
        let snapshot = try await Firestore.firestore()
            .collection("projects")
            .whereField("creatorId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Project.self)
        }
    }
}
