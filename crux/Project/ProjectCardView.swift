import SwiftUI

struct ProjectCardView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Created by: \(project.createdBy)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Difficulty: \(project.difficultyLevel)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(project.description)
                .font(.body)
                .lineLimit(3)
                .padding(.top, 2)
            
            HStack {
                ForEach(project.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(5)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                        
                }
            }
        }
        .padding()
        .background(Color.white)  // Card background color
        .cornerRadius(5)
        .shadow(radius: 3)
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 150)  // Set fixed height for cards
    }
}

