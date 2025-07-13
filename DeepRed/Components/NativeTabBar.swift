import SwiftUI

// MARK: - App Router for Navigation
class AppRouter: ObservableObject {
    @Published var selectedTab: TabItem = .home
}

// MARK: - Native Tab Bar Implementation with Compose Overlay Support

struct NativeTabBar: View {
    @StateObject private var router = AppRouter()
    @State private var showComposeOverlay = false
    @State private var lastHomeTabTap: Date = Date()
    @State private var refreshTrigger: Bool = false
    
    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    TabRootView(tab: tab)
                        .tabItem {
                            if tab == .record {
                                Image(systemName: "")
                                    .hidden() // Completely hide original icon
                            } else {
                                Image(systemName: router.selectedTab == tab ? tab.iconFilled : tab.icon)
                                Text(tab.title)
                            }
                        }
                        .tag(tab)
                }
            }
            .tint(DeepRedDesign.Colors.accent)
            .onAppear {
                configureTabBarAppearance()
            }
            .onChange(of: router.selectedTab) { oldValue, newValue in
                handleTabChange(from: oldValue, to: newValue)
            }
            
            // Custom Red Record Icon Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Spacer()
                    
                    // Position red icon over middle tab
                    ZStack {
                        // Outer circle outline
                        Circle()
                            .stroke(DeepRedDesign.Colors.accent, lineWidth: 2)
                            .frame(width: 42, height: 42)
                        
                        // Inner filled circle
                        Circle()
                            .fill(DeepRedDesign.Colors.accent)
                            .frame(width: 36, height: 36)
                    }
                    .allowsHitTesting(false) // Allow taps to pass through to tab bar
                    
                    Spacer()
                    Spacer()
                }
                .padding(.bottom, 2) // Fine-tune alignment with other tab icons
            }
            
            ComposeOverlay(isPresented: $showComposeOverlay)
        }
        .environmentObject(router)
    }
    
    // MARK: - Helper Functions
    
    private func handleTabChange(from oldValue: TabItem, to newValue: TabItem) {
        // Handle home tab double-tap for refresh (TikTok style)
        if newValue == .home && oldValue == .home {
            handleHomeTabDoubleTap()
        } else {
            // Haptic feedback on tab change
            HapticFeedback.selection()
            
            // Special handling for record button - show compose overlay
            if newValue == .record {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showComposeOverlay = true
                }
                HapticFeedback.impact(.heavy)
                
                // Reset to previous tab so record tab doesn't stay selected
                DispatchQueue.main.async {
                    router.selectedTab = oldValue
                }
            }
        }
    }
    
    private func handleHomeTabDoubleTap() {
        let now = Date()
        let timeDifference = now.timeIntervalSince(lastHomeTabTap)
        
        // Double-tap threshold: 0.5 seconds (similar to TikTok)
        if timeDifference < 0.5 {
            // Trigger refresh
            refreshTrigger.toggle()
            HapticFeedback.impact(.medium)
        }
        
        lastHomeTabTap = now
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
        
        // Force red color for all states
        UITabBar.appearance().tintColor = UIColor(DeepRedDesign.Colors.accent)
        UITabBar.appearance().unselectedItemTintColor = UIColor(DeepRedDesign.Colors.graphite)
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

// MARK: - Tab Root View Component

struct TabRootView: View {
    let tab: TabItem
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        switch tab {
        case .home:
            HomeFeedView()
        case .services:
            ServicesView()
        case .record:
            // This won't be shown as the record tab triggers compose overlay
            Color.clear
        case .inbox:
            InboxView()
        case .profile:
            ProfileView()
        }
    }
}

// MARK: - Compose Overlay Component

struct ComposeOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                // Dreamy Glassmorphism Background - Full Screen Focus Effect
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .background(
                        // Multi-layer dreamy gradient for depth
                        ZStack {
                            // Base gradient layer
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.1),
                                    Color.gray.opacity(0.05),
                                    Color.black.opacity(0.3),
                                    Color.gray.opacity(0.05),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            // Radial gradient overlay for center focus
                            RadialGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black.opacity(0.1), location: 0.3),
                                    .init(color: .black.opacity(0.2), location: 0.5),
                                    .init(color: .black.opacity(0.4), location: 0.7),
                                    .init(color: .black.opacity(0.6), location: 1.0)
                                ]),
                                center: .center,
                                startRadius: 100,
                                endRadius: 400
                            )
                        }
                    )
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                
                // Camera Recording View
                CameraRecordingView(useBackCamera: false) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(20)
                .shadow(
                    color: .black.opacity(0.3),
                    radius: 20,
                    x: 0,
                    y: 10
                )
                .shadow(
                    color: .white.opacity(0.1),
                    radius: 10,
                    x: 0,
                    y: -5
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
            }
            .zIndex(1000)
        }
    }
}

// MARK: - Tab Bar Icon Component

struct TabBarIcon: View {
    let item: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: isSelected ? item.iconFilled : item.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(iconColor)
            
            Text(item.title)
                .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                .foregroundColor(iconColor)
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
        ZStack {
            // Background circle with shadow effect
            Circle()
                .fill(DeepRedDesign.Colors.snow)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(DeepRedDesign.Colors.accent, lineWidth: 2)
                )
                .shadow(
                    color: DeepRedDesign.Colors.accent.opacity(0.3),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            
            // Record icon - centered
            Image(systemName: "plus")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(DeepRedDesign.Colors.accent)
                .rotationEffect(.degrees(isSelected ? 45 : 0))
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
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
    
    var title: String {
        return self.rawValue
    }
    
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