import SwiftUI

// MARK: - Edit Profile View

struct EditProfileView: View {
    @Binding var profile: UserProfile
    @Environment(\.dismiss) var dismiss
    
    @State private var displayName: String = ""
    @State private var bio: String = ""
    @State private var location: String = ""
    @State private var website: String = ""
    @State private var socialMediaLinks: [SocialMediaLink] = []
    @State private var showingImagePicker = false
    @State private var showingRemovePhotoAlert = false
    @State private var showingSocialMediaEditor = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Avatar Section
                    avatarSection
                    
                    // Basic Information
                    basicInfoSection
                    
                    // Bio Section
                    bioSection
                    
                    // Additional Information
                    additionalInfoSection
                    
                    // Social Media Links
                    socialMediaSection
                }
                .padding(.vertical, DeepRedDesign.Spacing.md)
            }
            .dismissKeyboardOnBackgroundTap()
            .background(DeepRedDesign.Colors.primaryBackground)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.onyx)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .fontWeight(.semibold)
                    .disabled(!hasChanges)
                }
            }
        }
        .onAppear {
            loadProfileData()
        }
        .alert("Remove Photo", isPresented: $showingRemovePhotoAlert) {
            Button("Remove", role: .destructive) {
                // Handle photo removal
                HapticFeedback.impact(.medium)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Remove your profile photo?")
        }
        .sheet(isPresented: $showingSocialMediaEditor) {
            AddSocialMediaView { newLink in
                socialMediaLinks.append(newLink)
            }
        }
    }
    
    private var avatarSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(DeepRedDesign.Colors.ash)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Group {
                            if let avatarURL = profile.avatarURL {
                                AsyncImage(url: URL(string: avatarURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.graphite)
                                }
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundColor(DeepRedDesign.Colors.graphite)
                            }
                        }
                    )
                    .clipShape(Circle())
                
                // Edit Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingImagePicker = true
                            HapticFeedback.impact(.light)
                        }) {
                            Circle()
                                .fill(DeepRedDesign.Colors.accent)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .frame(width: 120, height: 120)
            }
            
            // Photo Actions
            HStack(spacing: DeepRedDesign.Spacing.md) {
                Button("Change Photo") {
                    showingImagePicker = true
                    HapticFeedback.impact(.light)
                }
                .foregroundColor(DeepRedDesign.Colors.accent)
                .font(DeepRedDesign.Typography.body)
                .fontWeight(.medium)
                
                if profile.avatarURL != nil {
                    Button("Remove Photo") {
                        showingRemovePhotoAlert = true
                        HapticFeedback.impact(.light)
                    }
                    .foregroundColor(DeepRedDesign.Colors.error)
                    .font(DeepRedDesign.Typography.body)
                    .fontWeight(.medium)
                }
            }
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
    
    private var basicInfoSection: some View {
        EditSection(title: "Basic Information") {
            VStack(spacing: DeepRedDesign.Spacing.md) {
                EditField(
                    title: "Display Name",
                    placeholder: "Enter your display name",
                    text: $displayName,
                    icon: "person.fill"
                )
                
                EditField(
                    title: "Username",
                    placeholder: profile.username,
                    text: .constant(profile.username),
                    icon: "at",
                    isDisabled: true
                )
                .opacity(0.6)
            }
        }
    }
    
    private var bioSection: some View {
        EditSection(title: "Bio") {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                HStack {
                    Image(systemName: "text.alignleft")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DeepRedDesign.Colors.accent)
                        .frame(width: 20, height: 20)
                    
                    Text("Bio")
                        .font(DeepRedDesign.Typography.body)
                        .fontWeight(.medium)
                        .primaryText()
                    
                    Spacer()
                    
                    Text("\(bio.count)/150")
                        .font(DeepRedDesign.Typography.caption)
                        .foregroundColor(bio.count > 150 ? DeepRedDesign.Colors.error : DeepRedDesign.Colors.graphite)
                }
                
                TextField("Tell people about yourself...", text: $bio, axis: .vertical)
                    .font(DeepRedDesign.Typography.body)
                    .foregroundColor(DeepRedDesign.Colors.onyx)
                    .lineLimit(4...6)
                    .padding(.horizontal, DeepRedDesign.Spacing.md)
                    .padding(.vertical, DeepRedDesign.Spacing.sm)
                    .background(DeepRedDesign.Colors.ash)
                    .cornerRadius(DeepRedDesign.CornerRadius.button)
                    .onChange(of: bio) { _, newValue in
                        if newValue.count > 150 {
                            bio = String(newValue.prefix(150))
                        }
                    }
            }
        }
    }
    
    private var additionalInfoSection: some View {
        EditSection(title: "Additional Information") {
            VStack(spacing: DeepRedDesign.Spacing.md) {
                EditField(
                    title: "Location",
                    placeholder: "City, Country",
                    text: $location,
                    icon: "location.fill"
                )
                
                EditField(
                    title: "Website",
                    placeholder: "yourwebsite.com",
                    text: $website,
                    icon: "link",
                    keyboardType: .URL
                )
            }
        }
    }
    
    private var socialMediaSection: some View {
        EditSection(title: "Social Media") {
            VStack(spacing: DeepRedDesign.Spacing.md) {
                // Current social media links
                if !socialMediaLinks.isEmpty {
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        ForEach(socialMediaLinks) { link in
                            SocialMediaEditRow(link: link) {
                                // Remove social media link
                                socialMediaLinks.removeAll { $0.id == link.id }
                                HapticFeedback.impact(.light)
                            }
                        }
                    }
                }
                
                // Add new social media button
                Button(action: {
                    showingSocialMediaEditor = true
                    HapticFeedback.impact(.light)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        
                        Text("Add Social Media Account")
                            .font(DeepRedDesign.Typography.body)
                            .fontWeight(.medium)
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        
                        Spacer()
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.md)
                    .padding(.vertical, DeepRedDesign.Spacing.sm)
                    .background(DeepRedDesign.Colors.accent.opacity(0.1))
                    .cornerRadius(DeepRedDesign.CornerRadius.button)
                }
            }
        }
    }
    
    private var hasChanges: Bool {
        displayName != profile.displayName ||
        bio != profile.bio ||
        location != (profile.location ?? "") ||
        website != (profile.website ?? "") ||
        socialMediaLinks != profile.socialMediaLinks
    }
    
    private func loadProfileData() {
        displayName = profile.displayName
        bio = profile.bio
        location = profile.location ?? ""
        website = profile.website ?? ""
        socialMediaLinks = profile.socialMediaLinks
    }
    
    private func saveProfile() {
        profile.displayName = displayName
        profile.bio = bio
        profile.location = location.isEmpty ? nil : location
        profile.website = website.isEmpty ? nil : website
        profile.socialMediaLinks = socialMediaLinks
        
        // Handle API call to save profile
        HapticFeedback.impact(.light)
    }
}

// MARK: - Edit Components

struct EditSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            Text(title)
                .font(DeepRedDesign.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(DeepRedDesign.Colors.graphite)
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            
            content
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
    }
}

struct EditField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(DeepRedDesign.Typography.body)
                    .fontWeight(.medium)
                    .primaryText()
                
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .font(DeepRedDesign.Typography.body)
                .foregroundColor(DeepRedDesign.Colors.onyx)
                .padding(.horizontal, DeepRedDesign.Spacing.md)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                .background(DeepRedDesign.Colors.ash)
                .cornerRadius(DeepRedDesign.CornerRadius.button)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disabled(isDisabled)
        }
    }
}



// MARK: - Preview

#Preview {
    @Previewable @State var profile = UserProfile.sampleProfile
    
    return EditProfileView(profile: $profile)
} 