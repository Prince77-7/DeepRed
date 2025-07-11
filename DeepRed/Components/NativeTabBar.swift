import SwiftUI

// MARK: - Native Tab Bar Implementation

struct NativeTabBar: View {
    @State private var selectedTab: TabItem = .home
    @State private var showCameraView = false
    
    var body: some View {
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
            
            // Services Tab
            ServicesView()
                .tabItem {
                    TabBarIcon(
                        item: .services,
                        isSelected: selectedTab == .services
                    )
                }
                .tag(TabItem.services)
            
            // Record Tab (Special Handling)
            RecordView()
                .tabItem {
                    TabBarIcon(
                        item: .record,
                        isSelected: selectedTab == .record
                    )
                }
                .tag(TabItem.record)
            
            // Inbox Tab
            InboxView()
                .tabItem {
                    TabBarIcon(
                        item: .inbox,
                        isSelected: selectedTab == .inbox
                    )
                }
                .tag(TabItem.inbox)
            
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
        .tint(DeepRedDesign.Colors.accent) // iOS 15+ tint for selected state
        .onAppear {
            configureTabBarAppearance()
        }
        .onChange(of: selectedTab) { _, newValue in
            // Haptic feedback on tab change
            HapticFeedback.selection()
            
            // Special handling for record button - open camera directly
            if newValue == .record {
                // Open camera immediately
                showCameraView = true
                HapticFeedback.impact(.heavy)
                
                // Reset to home tab so record tab doesn't stay selected
                DispatchQueue.main.async {
                    selectedTab = .home
                }
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
            if item == .record {
                // Special Record Button
                RecordTabIcon(isSelected: isSelected)
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

// MARK: - Special Record Tab Icon

struct RecordTabIcon: View {
    let isSelected: Bool
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Background circle with shadow effect
                Circle()
                    .fill(DeepRedDesign.Colors.accent)
                    .frame(width: 36, height: 36)
                    .shadow(
                        color: DeepRedDesign.Colors.accent.opacity(0.3),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                
                // Record icon
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(DeepRedDesign.Colors.snow)
                    .rotationEffect(.degrees(isSelected ? 45 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
            }
            
            Text("Create")
                .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                .foregroundColor(DeepRedDesign.Colors.accent)
                .opacity(isSelected ? 1.0 : 0.8)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
        .onAppear {
            // Subtle pulse animation for the record button
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
}

// MARK: - Tab Item Enum (Updated)

enum TabItem: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case record = "Create"
    case inbox = "Inbox"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .services: return "briefcase"
        case .record: return "plus.circle"
        case .inbox: return "message"
        case .profile: return "person.crop.circle"
        }
    }
    
    var iconFilled: String {
        switch self {
        case .home: return "house.fill"
        case .services: return "briefcase.fill"
        case .record: return "plus.circle.fill"
        case .inbox: return "message.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

// MARK: - Preview

#Preview("Native Tab Bar") {
    NativeTabBar()
} 