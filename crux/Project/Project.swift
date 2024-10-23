import Foundation

import Foundation

struct Project: Identifiable, Codable { // Add Codable here
    var id = UUID().uuidString
    var name: String
    var description: String
    var tags: [String]
    var createdBy: String
    var creatorId: String
    var skills: [String]
    var dateCreated: Date = Date()
    var difficultyLevel: String
}
