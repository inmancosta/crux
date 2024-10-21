import Foundation



struct Project: Identifiable {
    var id = UUID().uuidString
    var name: String
    var description: String
    var tags: [String]
    var createdBy: String
    var creatorId: String
    var skills: [String]
    var dateCreated: Date = Date() // Set the creation date to now
    var difficultyLevel: String
}
