import SwiftUI

import SwiftUI

struct OnboardingView: View {
    @State private var name = ""
    @State private var githubUsername = ""
    @State private var schoolGradYear = ""
    @State private var preferences: [String] = []

    @Binding var showOnboarding: Bool
    let userId: String

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Complete Your Profile")
                    .font(.largeTitle)
                    .bold()

                // Name Input Field
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // GitHub Username Input Field
                TextField("GitHub Username", text: $githubUsername)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // School Graduation Year Input Field
                TextField("School/Grad Year", text: $schoolGradYear)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // Preferences Section
                Text("Select Your Preferences")
                    .font(.headline)

                List {
                    Toggle("Mobile Development", isOn: Binding(
                        get: { preferences.contains("Mobile Development") },
                        set: { newValue in
                            if newValue {
                                preferences.append("Mobile Development")
                            } else {
                                preferences.removeAll { $0 == "Mobile Development" }
                            }
                        }
                    ))
                    
                    Toggle("Data Science", isOn: Binding(
                        get: { preferences.contains("Data Science") },
                        set: { newValue in
                            if newValue {
                                preferences.append("Data Science")
                            } else {
                                preferences.removeAll { $0 == "Data Science" }
                            }
                        }
                    ))

                    Toggle("Web Development", isOn: Binding(
                        get: { preferences.contains("Web Development") },
                        set: { newValue in
                            if newValue {
                                preferences.append("Web Development")
                            } else {
                                preferences.removeAll { $0 == "Web Development" }
                            }
                        }
                    ))
                    
                    Toggle("UI/UX Design", isOn: Binding(
                        get: { preferences.contains("UI/UX Design") },
                        set: { newValue in
                            if newValue {
                                preferences.append("UI/UX Design")
                            } else {
                                preferences.removeAll { $0 == "UI/UX Design" }
                            }
                        }
                    ))
                }
                .frame(height: 150)
                .listStyle(PlainListStyle())

                // Complete Onboarding Button
                Button(action: {
                    Task {
                        do {
                            // Update Firestore with the onboarding details
                            try await UserManager.shared.updateUserDetails(
                                userId: userId,
                                name: name,
                                githubUsername: githubUsername,
                                schoolGradYear: schoolGradYear,
                                preferences: preferences
                            )
                            showOnboarding = false // Exit onboarding and show profile
                        } catch {
                            print("Failed to update user details: \(error)")
                        }
                    }
                }) {
                    Text("Complete Onboarding")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            
            .navigationBarItems(leading: Button(action: {
                showOnboarding = false // Navigate back to SignInEmailView
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            })
        }
    }
}

