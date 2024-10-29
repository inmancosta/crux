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
            "difficultyLevel": project.difficultyLevel
        ]
        
        try await Firestore.firestore()
            .collection("projects")
            .document(project.id)
            .setData(projectData)
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
}
