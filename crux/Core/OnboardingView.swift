import SwiftUI

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAppCheck
import FirebaseAuth



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Limit picker to images only
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

import SwiftUI
import PhotosUI

struct OnboardingView: View {
    @State private var name = ""
    @State private var githubUsername = ""
    @State private var schoolGradYear = ""
    @State private var preferences: [String] = []
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @Binding var showOnboarding: Bool
    let userId: String

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Complete Your Profile")
                    .font(.largeTitle)
                    .bold()

                // Profile Image
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            showImagePicker = true
                        }
                }

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
                        // Upload the profile picture to storage and get the URL
                        let photoUrl = await uploadProfilePicture(profileImage)
                        print(photoUrl)
                        
                        do {
                            // Update Firestore with the onboarding details, including photo URL
                            try await UserManager.shared.updateUserDetails(
                                userId: userId,
                                name: name,
                                githubUsername: githubUsername,
                                schoolGradYear: schoolGradYear,
                                preferences: preferences,
                                photoUrl: photoUrl
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
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profileImage)
            }
        }
    }

    // Function to upload the profile picture to Firebase Storage
    func uploadProfilePicture(_ image: UIImage?) async -> String? {
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else { return nil }

        // Log the userId to ensure it's correct
        print("Uploading profile picture for userId: \(userId)")

        let storageRef = Storage.storage().reference().child("profile_pictures/\(userId).jpg")
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let downloadUrl = try await storageRef.downloadURL()
            return downloadUrl.absoluteString
        } catch {
            print("Failed to upload profile picture: \(error)")
            return nil
        }
    }

}



