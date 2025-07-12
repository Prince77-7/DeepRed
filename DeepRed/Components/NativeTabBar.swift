import SwiftUI

// MARK: - Native Tab Bar Implementation

struct NativeTabBar: View {
    @State private var selectedTab: TabItem = .home
    @State private var showCameraView = false
    @State private var isRecording = false
    @State private var recordingProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Main Tab View with 5 tabs (middle is empty)
            TabView(selection: $selectedTab) {
                // Home Tab
                HomeFeedView()
                    .tabItem {
                        TabBarIcon(
                            item: .home,
                            isSelected: selectedTab == .home
                        )
                    }
                    .tag(TabItem.home)
                
                // Influencers Tab
                InfluencersView()
                    .tabItem {
                        TabBarIcon(
                            item: .influencers,
                            isSelected: selectedTab == .influencers
                        )
                    }
                    .tag(TabItem.influencers)
                
                // Empty Middle Tab (for floating button space)
                Color.clear
                    .tabItem {
                        TabBarIcon(
                            item: .empty,
                            isSelected: false
                        )
                    }
                    .tag(TabItem.empty)
                
                // Sponsors Tab
                SponsorsView()
                    .tabItem {
                        TabBarIcon(
                            item: .sponsors,
                            isSelected: selectedTab == .sponsors
                        )
                    }
                    .tag(TabItem.sponsors)
                
                // Profile Tab
                ProfileView()
                    .tabItem {
                        TabBarIcon(
                            item: .profile,
                            isSelected: selectedTab == .profile
                        )
                    }
                    .tag(TabItem.profile)
            }
            .tint(DeepRedDesign.Colors.accent)
            .onAppear {
                configureTabBarAppearance()
            }
            .onChange(of: selectedTab) { _, newValue in
                // Redirect empty tab to home
                if newValue == .empty {
                    selectedTab = .home
                    HapticFeedback.selection()
                    return
                }
                // Haptic feedback on tab change
                HapticFeedback.selection()
            }
            
            // Floating Record Button positioned in middle of tab bar
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    // Floating Record Button using CameraRecordButton
                    CameraRecordButton(
                        isRecording: isRecording,
                        recordingProgress: recordingProgress,
                        onButtonPress: {
                            showCameraView = true
                            HapticFeedback.impact(.heavy)
                        }
                    )
                    .offset(y: -5) // Move up to center in tab bar
                    
                    Spacer()
                }
                .padding(.bottom, 8) // Adjust for tab bar height
            }
        }
        .fullScreenCover(isPresented: $showCameraView) {
            CameraRecordingView(useBackCamera: false) {
                // Camera will automatically dismiss when done
            }
        }
    }
    
    private func configureTabBarAppearance() {
        // Configure native tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(DeepRedDesign.Colors.snow)
        
        // Standard appearance (unselected)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(DeepRedDesign.Colors.graphite)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(DeepRedDesign.Colors.graphite),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Selected appearance
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DeepRedDesign.Colors.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(DeepRedDesign.Colors.accent),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        // Shadow
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        appearance.shadowImage = createShadowImage()
        
        // Apply appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // iOS 15+ additional configuration
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func createShadowImage() -> UIImage? {
        let shadowHeight: CGFloat = 1
        let shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: shadowHeight))
        return renderer.image { context in
            shadowColor.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: shadowHeight))
        }
    }
}

// MARK: - Tab Bar Icon Component

struct TabBarIcon: View {
    let item: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            // For empty tab, show nothing
            if item == .empty {
                Color.clear
                    .frame(width: 22, height: 22)
                
                Text("")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.clear)
            } else {
                // Standard Tab Icon
                Image(systemName: isSelected ? item.iconFilled : item.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(iconColor)
                
                Text(item.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(iconColor)
            }
        }
    }
    
    private var iconColor: Color {
        return isSelected ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.graphite
    }
}

// MARK: - Tab Item Enum (Updated)

enum TabItem: String, CaseIterable {
    case home = "Home"
    case influencers = "Influencers"
    case empty = ""
    case sponsors = "Sponsors"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .influencers: return "person.2"
        case .empty: return ""
        case .sponsors: return "building.2"
        case .profile: return "person.crop.circle"
        }
    }
    
    var iconFilled: String {
        switch self {
        case .home: return "house.fill"
        case .influencers: return "person.2.fill"
        case .empty: return ""
        case .sponsors: return "building.2.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

// MARK: - Preview

#Preview("Native Tab Bar") {
    NativeTabBar()
} 
