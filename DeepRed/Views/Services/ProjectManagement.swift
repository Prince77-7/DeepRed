import SwiftUI

// MARK: - Project Management View (Mission Control)
struct ProjectManagement: View {
    let project: Project
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: ProjectTab = .overview
    @State private var newMessage = ""
    @State private var showingMilestoneDetail = false
    @State private var selectedMilestone: ProjectMilestone?
    
    enum ProjectTab: String, CaseIterable {
        case overview = "Overview"
        case timeline = "Timeline"
        case communication = "Messages"
        case payment = "Payment"
        
        var icon: String {
            switch self {
            case .overview:
                return "chart.line.uptrend.xyaxis"
            case .timeline:
                return "timeline.selection"
            case .communication:
                return "message.fill"
            case .payment:
                return "creditcard.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Tab Navigation
                tabNavigation
                
                // Content
                tabContent
            }
                    .background(Color.white)
        .navigationBarHidden(true)
        .dismissKeyboardOnBackgroundTap()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingMilestoneDetail) {
            if let milestone = selectedMilestone {
                MilestoneDetailView(milestone: milestone)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Top Navigation
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Mission Control")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(project.gig.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: {
                    // Options menu
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Project Status Card
            projectStatusCard
        }
        .padding(.bottom, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Project Status Card
    private var projectStatusCard: some View {
        VStack(spacing: 16) {
            // Participants
            HStack(spacing: 16) {
                // Creator
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(project.creator.username)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("Creator")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Status Badge
                ProjectStatusBadge(status: project.status)
                
                Spacer()
                
                // Business
                HStack(spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(project.business.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("Business")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                }
            }
            
            // Progress Overview
            VStack(spacing: 12) {
                HStack {
                    Text("Project Progress")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(completedMilestones)/\(project.milestones.count) milestones")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#850101")))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                HStack {
                    Text("Started \(formatDate(project.startDate))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Due \(formatDate(project.expectedDelivery))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(daysUntilDeadline <= 3 ? .red : .primary)
                }
            }
        }
        .padding(16)
                    .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    // MARK: - Tab Navigation
    private var tabNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ProjectTab.allCases, id: \.rawValue) { tab in
                    ProjectTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        ScrollView {
            switch selectedTab {
            case .overview:
                overviewContent
            case .timeline:
                timelineContent
            case .communication:
                communicationContent
            case .payment:
                paymentContent
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    
    // MARK: - Overview Content
    private var overviewContent: some View {
        VStack(spacing: 24) {
            // Quick Stats
            quickStatsSection
            
            // Recent Activity
            recentActivitySection
            
            // Next Milestones
            nextMilestonesSection
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Days Active",
                    value: "\(daysSinceStart)",
                    icon: "calendar",
                    color: .blue
                )
                
                StatCard(
                    title: "Messages",
                    value: "\(project.communications.count)",
                    icon: "message.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Budget Used",
                    value: "\(Int(progressPercentage * 100))%",
                    icon: "dollarsign.circle",
                    color: Color(hex: "#850101")
                )
                
                StatCard(
                    title: "Days Left",
                    value: "\(max(0, daysUntilDeadline))",
                    icon: "clock",
                    color: daysUntilDeadline <= 3 ? .red : .orange
                )
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(project.communications.prefix(3)) { message in
                    ActivityCard(message: message)
                }
            }
        }
    }
    
    private var nextMilestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Milestones")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(upcomingMilestones) { milestone in
                    MilestoneCard(milestone: milestone) {
                        selectedMilestone = milestone
                        showingMilestoneDetail = true
                    }
                }
                
                if upcomingMilestones.isEmpty {
                    Text("No upcoming milestones")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
    
    // MARK: - Timeline Content
    private var timelineContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Project Timeline")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                ForEach(project.milestones.indices, id: \.self) { index in
                    let milestone = project.milestones[index]
                    let isLast = index == project.milestones.count - 1
                    
                    TimelineMilestoneCard(
                        milestone: milestone,
                        isLast: isLast
                    ) {
                        selectedMilestone = milestone
                        showingMilestoneDetail = true
                    }
                }
            }
        }
    }
    
    // MARK: - Communication Content
    private var communicationContent: some View {
        VStack(spacing: 16) {
            // Messages
            VStack(alignment: .leading, spacing: 16) {
                Text("Project Communication")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    ForEach(project.communications.reversed()) { message in
                        MessageBubble(message: message)
                    }
                }
            }
            
            // Message Input
            messageInput
        }
    }
    
    // MARK: - Payment Content
    private var paymentContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Payment & Escrow")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            // Payment Status
            PaymentStatusCard(payment: project.payment)
            
            // Payment History
            VStack(alignment: .leading, spacing: 16) {
                Text("Payment Breakdown")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    PaymentItemRow(title: "Project Total", amount: project.payment.totalAmount, isTotal: true)
                    PaymentItemRow(title: "Platform Fee (5%)", amount: project.payment.totalAmount * 0.05, isDeduction: true)
                    PaymentItemRow(title: "Creator Receives", amount: project.payment.totalAmount * 0.95, isHighlight: true)
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    // MARK: - Message Input
    private var messageInput: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $newMessage)
                .font(.system(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
            Button(action: {
                sendMessage()
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(newMessage.isEmpty ? .gray : Color(hex: "#850101"))
            }
            .disabled(newMessage.isEmpty)
        }
        .padding(16)
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    // MARK: - Computed Properties
    private var completedMilestones: Int {
        project.milestones.filter { $0.isCompleted }.count
    }
    
    private var progressPercentage: Double {
        guard !project.milestones.isEmpty else { return 0 }
        return Double(completedMilestones) / Double(project.milestones.count)
    }
    
    private var daysSinceStart: Int {
        Calendar.current.dateComponents([.day], from: project.startDate, to: Date()).day ?? 0
    }
    
    private var daysUntilDeadline: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: project.expectedDelivery).day ?? 0
    }
    
    private var upcomingMilestones: [ProjectMilestone] {
        project.milestones.filter { !$0.isCompleted }.prefix(3).map { $0 }
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        // In a real app, this would send the message to the server
        newMessage = ""
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Supporting Views

struct ProjectStatusBadge: View {
    let status: Project.ProjectStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor.opacity(0.1))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(statusColor.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var statusColor: Color {
        switch status {
        case .active:
            return Color.green
        case .inReview:
            return Color.orange
        case .completed:
            return Color.blue
        case .cancelled:
            return Color.red
        case .disputed:
            return Color.purple
        }
    }
}

struct ProjectTabButton: View {
    let tab: ProjectManagement.ProjectTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: tab.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(tab.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color(hex: "#850101") : Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ActivityCard: View {
    let message: ProjectMessage
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(senderColor.opacity(0.1))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: senderIcon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(senderColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text("\(message.sender.rawValue) • \(formatTime(message.timestamp))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var senderColor: Color {
        switch message.sender {
        case .creator:
            return Color.blue
        case .business:
            return Color.green
        case .system:
            return Color.orange
        }
    }
    
    private var senderIcon: String {
        switch message.sender {
        case .creator:
            return "person.circle"
        case .business:
            return "building.2"
        case .system:
            return "gear"
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

struct MilestoneCard: View {
    let milestone: ProjectMilestone
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(milestone.isCompleted ? .green : .gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(milestone.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text("Due \(formatDate(milestone.dueDate))")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct TimelineMilestoneCard: View {
    let milestone: ProjectMilestone
    let isLast: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline indicator
            VStack(spacing: 0) {
                Circle()
                    .fill(milestone.isCompleted ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            // Milestone content
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(milestone.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(formatDate(milestone.dueDate))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(milestone.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if milestone.isCompleted, let completedDate = milestone.completedDate {
                        Text("Completed on \(formatDate(completedDate))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct MessageBubble: View {
    let message: ProjectMessage
    
    var body: some View {
        HStack {
            if message.sender == .business {
                Spacer()
            }
            
            VStack(alignment: message.sender == .business ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(message.sender == .business ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.sender == .business ? Color(hex: "#850101") : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(formatTime(message.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
            
            if message.sender != .business {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct PaymentStatusCard: View {
    let payment: PaymentInfo
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Payment Status")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                PaymentStatusBadge(status: payment.escrowStatus)
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Total Amount")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("$\(Int(payment.totalAmount))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Payment Method")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(payment.paymentMethod)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                if let releaseDate = payment.releaseDate {
                    HStack {
                        Text("Release Date")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(formatDate(releaseDate))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct PaymentStatusBadge: View {
    let status: PaymentInfo.EscrowStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor.opacity(0.1))
            .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .pending:
            return Color.orange
        case .escrowed:
            return Color.blue
        case .released:
            return Color.green
        case .disputed:
            return Color.red
        }
    }
}

struct PaymentItemRow: View {
    let title: String
    let amount: Double
    let isTotal: Bool
    let isDeduction: Bool
    let isHighlight: Bool
    
    init(title: String, amount: Double, isTotal: Bool = false, isDeduction: Bool = false, isHighlight: Bool = false) {
        self.title = title
        self.amount = amount
        self.isTotal = isTotal
        self.isDeduction = isDeduction
        self.isHighlight = isHighlight
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: isTotal || isHighlight ? .semibold : .regular))
                .foregroundColor(isHighlight ? Color(hex: "#850101") : .primary)
            
            Spacer()
            
            Text("\(isDeduction ? "-" : "")$\(Int(amount))")
                .font(.system(size: 14, weight: isTotal || isHighlight ? .bold : .semibold))
                .foregroundColor(isHighlight ? Color(hex: "#850101") : (isDeduction ? .red : .primary))
        }
        .padding(.vertical, isTotal ? 8 : 4)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .opacity(isTotal ? 1 : 0),
            alignment: .top
        )
    }
}

struct MilestoneDetailView: View {
    let milestone: ProjectMilestone
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Milestone details would go here")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(40)
                }
            }
            .navigationTitle(milestone.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Sample Data
private let sampleProject = Project(
    gig: ServicesModels.sampleGigs[0],
    creator: ServicesModels.sampleTalentProfile,
    business: ServicesModels.sampleBusiness,
    startDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
    expectedDelivery: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(),
    actualDelivery: nil,
    milestones: [
        ProjectMilestone(
            title: "Script & Concept Approval",
            description: "Create scripts for all 5 TikTok videos and get approval",
            dueDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            isCompleted: true,
            completedDate: Calendar.current.date(byAdding: .day, value: -6, to: Date()),
            deliverables: ["5 video scripts", "Concept outlines"]
        ),
        ProjectMilestone(
            title: "Video Production",
            description: "Film and edit all 5 TikTok videos",
            dueDate: Date(),
            isCompleted: false,
            completedDate: nil,
            deliverables: ["5 edited TikTok videos", "Raw footage"]
        ),
        ProjectMilestone(
            title: "Revisions & Final Delivery",
            description: "Implement feedback and deliver final videos",
            dueDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(),
            isCompleted: false,
            completedDate: nil,
            deliverables: ["Final video files", "Publishing schedule"]
        )
    ],
    communications: [
        ProjectMessage(
            sender: .business,
            content: "Great work on the scripts! The concept for video #3 is particularly strong.",
            timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            attachments: [],
            isRead: true
        ),
        ProjectMessage(
            sender: .creator,
            content: "Thank you! I'm starting production today. Should have the first 3 videos ready by tomorrow.",
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            attachments: [],
            isRead: true
        ),
        ProjectMessage(
            sender: .system,
            content: "Milestone 'Script & Concept Approval' has been completed.",
            timestamp: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
            attachments: [],
            isRead: true
        )
    ],
    status: .active,
    payment: PaymentInfo(
        totalAmount: 1000,
        currency: "USD",
        escrowStatus: .escrowed,
        paymentMethod: "Credit Card",
        releaseDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
    )
)

// MARK: - Preview
struct ProjectManagement_Previews: PreviewProvider {
    static var previews: some View {
        ProjectManagement(project: sampleProject)
    }
} 