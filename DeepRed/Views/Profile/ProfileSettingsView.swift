import SwiftUI

// MARK: - Profile Settings View

struct ProfileSettingsView: View {
    @Binding var profile: UserProfile
    @Environment(\.dismiss) var dismiss
    
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Profile Section
                    profileSection
                    
                    // Privacy Settings
                    privacySection
                    
                    // Notification Settings
                    notificationSection
                    
                    // Content Settings
                    contentSection
                    
                    // Account Actions
                    accountActionsSection
                }
                .padding(.vertical, DeepRedDesign.Spacing.md)
            }
            .background(DeepRedDesign.Colors.primaryBackground)
            .navigationTitle("Settings")
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
                        saveSettings()
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Sign Out", role: .destructive) {
                // Handle logout
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
            Button("Delete Account", role: .destructive) {
                // Handle account deletion
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
    
    private var profileSection: some View {
        SettingsSection(title: "Profile") {
            SettingsRow(
                title: "Show Email",
                subtitle: "Display your email on your profile",
                systemImage: "envelope.fill"
            ) {
                Toggle("", isOn: $profile.settings.showEmail)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Show Location",
                subtitle: "Display your location on your profile",
                systemImage: "location.fill"
            ) {
                Toggle("", isOn: $profile.settings.showLocation)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Show Earnings",
                subtitle: "Display your earnings on your profile",
                systemImage: "dollarsign.circle.fill"
            ) {
                Toggle("", isOn: $profile.settings.showEarnings)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
        }
    }
    
    private var privacySection: some View {
        SettingsSection(title: "Privacy") {
                    SettingsRow(
            title: "Private Profile",
            subtitle: "Only approved collaborators can see your profile",
            systemImage: "lock.fill"
        ) {
            Toggle("", isOn: $profile.settings.isPrivate)
                .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
        }
            
            SettingsNavigationRow(
                title: "Profile Visibility",
                subtitle: profile.settings.privacySettings.profileVisibility.rawValue,
                systemImage: "eye.fill"
            ) {
                // Handle profile visibility settings
            }
            
            SettingsNavigationRow(
                title: "Video Visibility",
                subtitle: profile.settings.privacySettings.videoVisibility.rawValue,
                systemImage: "video.fill"
            ) {
                // Handle video visibility settings
            }
            
            SettingsNavigationRow(
                title: "Services Visibility",
                subtitle: profile.settings.privacySettings.servicesVisibility.rawValue,
                systemImage: "briefcase.fill"
            ) {
                // Handle services visibility settings
            }
            
            SettingsRow(
                title: "Allow Direct Messages",
                subtitle: "Let others message you directly",
                systemImage: "message.fill"
            ) {
                Toggle("", isOn: $profile.settings.allowDirectMessages)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsNavigationRow(
                title: "Blocked Users",
                subtitle: "\(profile.settings.privacySettings.blockedUsers.count) blocked",
                systemImage: "person.fill.xmark"
            ) {
                // Handle blocked users
            }
        }
    }
    
    private var notificationSection: some View {
        SettingsSection(title: "Notifications") {
            SettingsRow(
                title: "Push Notifications",
                subtitle: "Receive notifications on your device",
                systemImage: "bell.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.pushNotifications)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Email Notifications",
                subtitle: "Receive notifications via email",
                systemImage: "envelope.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.emailNotifications)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            Divider()
                .padding(.horizontal, DeepRedDesign.Spacing.md)
            
            SettingsRow(
                title: "New Collaborators",
                subtitle: "When someone wants to collaborate with you",
                systemImage: "person.badge.plus"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.newCollaborators)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Video Likes",
                subtitle: "When someone likes your video",
                systemImage: "heart.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.videoLikes)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Video Comments",
                subtitle: "When someone comments on your video",
                systemImage: "message.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.videoComments)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Service Inquiries",
                subtitle: "When someone contacts you about services",
                systemImage: "briefcase.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.serviceInquiries)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Payment Updates",
                subtitle: "When you receive payments",
                systemImage: "creditcard.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.paymentUpdates)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Achievements",
                subtitle: "When you unlock achievements",
                systemImage: "star.fill"
            ) {
                Toggle("", isOn: $profile.settings.notificationSettings.achievements)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
        }
    }
    
    private var contentSection: some View {
        SettingsSection(title: "Content") {
            SettingsRow(
                title: "Auto-play Videos",
                subtitle: "Automatically play videos in feed",
                systemImage: "play.fill"
            ) {
                Toggle("", isOn: $profile.settings.contentSettings.autoPlayVideos)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsNavigationRow(
                title: "Video Quality",
                subtitle: profile.settings.contentSettings.videoQuality.rawValue,
                systemImage: "video.fill"
            ) {
                // Handle video quality settings
            }
            
            SettingsRow(
                title: "Download Over Wi-Fi Only",
                subtitle: "Save cellular data",
                systemImage: "wifi"
            ) {
                Toggle("", isOn: $profile.settings.contentSettings.downloadOverWiFiOnly)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
            
            SettingsRow(
                title: "Show Mature Content",
                subtitle: "Display age-restricted content",
                systemImage: "exclamationmark.triangle.fill"
            ) {
                Toggle("", isOn: $profile.settings.contentSettings.showMatureContent)
                    .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
            }
        }
    }
    
    private var accountActionsSection: some View {
        SettingsSection(title: "Account") {
            SettingsActionRow(
                title: "Export Data",
                subtitle: "Download your DeepRed data",
                systemImage: "square.and.arrow.down",
                color: DeepRedDesign.Colors.accent
            ) {
                // Handle export data
                HapticFeedback.impact(.light)
            }
            
            SettingsActionRow(
                title: "Sign Out",
                subtitle: "Sign out of your account",
                systemImage: "arrow.right.square",
                color: DeepRedDesign.Colors.warning
            ) {
                showingLogoutAlert = true
                HapticFeedback.impact(.medium)
            }
            
            SettingsActionRow(
                title: "Delete Account",
                subtitle: "Permanently delete your account",
                systemImage: "trash.fill",
                color: DeepRedDesign.Colors.error
            ) {
                showingDeleteAccountAlert = true
                HapticFeedback.impact(.heavy)
            }
        }
    }
    
    private func saveSettings() {
        // Handle saving settings
        HapticFeedback.impact(.light)
    }
}

// MARK: - Settings Components

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
            Text(title)
                .font(DeepRedDesign.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(DeepRedDesign.Colors.graphite)
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            
            VStack(spacing: 0) {
                content
            }
            .background(DeepRedDesign.Colors.primaryBackground)
            .cornerRadius(DeepRedDesign.CornerRadius.card)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
    }
}

struct SettingsRow<Content: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(DeepRedDesign.Colors.accent)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                Text(title)
                    .font(DeepRedDesign.Typography.body)
                    .fontWeight(.medium)
                    .primaryText()
                
                Text(subtitle)
                    .font(DeepRedDesign.Typography.caption)
                    .secondaryText()
            }
            
            Spacer()
            
            content
        }
        .padding(.horizontal, DeepRedDesign.Spacing.md)
        .padding(.vertical, DeepRedDesign.Spacing.sm)
    }
}

struct SettingsNavigationRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DeepRedDesign.Spacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    Text(title)
                        .font(DeepRedDesign.Typography.body)
                        .fontWeight(.medium)
                        .primaryText()
                    
                    Text(subtitle)
                        .font(DeepRedDesign.Typography.caption)
                        .secondaryText()
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.graphite)
            }
            .padding(.horizontal, DeepRedDesign.Spacing.md)
            .padding(.vertical, DeepRedDesign.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DeepRedDesign.Spacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    Text(title)
                        .font(DeepRedDesign.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                    
                    Text(subtitle)
                        .font(DeepRedDesign.Typography.caption)
                        .secondaryText()
                }
                
                Spacer()
            }
            .padding(.horizontal, DeepRedDesign.Spacing.md)
            .padding(.vertical, DeepRedDesign.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var profile = UserProfile.sampleProfile
    
    return ProfileSettingsView(profile: $profile)
} 