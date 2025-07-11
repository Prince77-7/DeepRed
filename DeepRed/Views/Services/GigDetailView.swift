import SwiftUI

// MARK: - Gig Detail View
struct GigDetailView: View {
    let gig: Gig
    @Environment(\.dismiss) private var dismiss
    @State private var showingApplicationModal = false
    @State private var isApplying = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header Card (Shared Element)
                        headerCard
                            .offset(y: scrollOffset > 0 ? -scrollOffset * 0.5 : 0)
                        
                        // Detail Content
                        detailContent
                            .background(Color.white)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .background(Color.white)
                
                // Floating Navigation Buttons
                VStack {
                    navigationButtons
                    Spacer()
                }
                
                // Floating Apply Button
                floatingApplyButton
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingApplicationModal) {
                GigApplicationView(gig: gig)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    // Share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Button(action: {
                    // Save action
                }) {
                    Image(systemName: "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    // MARK: - Header Card
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Business Header
            HStack(spacing: 16) {
                // Business Logo
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "building.2")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.secondary)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(gig.business.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        if gig.business.verificationStatus == .verified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", gig.business.rating))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            Text("• \(gig.business.totalGigs) gigs posted")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Urgent Badge
                if gig.isUrgent {
                    VStack(spacing: 4) {
                        Text("URGENT")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .clipShape(Capsule())
                        
                        Text("Fast Response")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
            }
            
            // Gig Title
            Text(gig.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Key Stats
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Budget")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(gig.budget.displayString)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "#850101"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Timeline")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(gig.timeline)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Applicants")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(gig.applicantCount)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 16) // 8pt grid: 16 = 2 * 8
        .padding(.vertical, 24) // 8pt grid: 24 = 3 * 8
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 8)
        .padding(.horizontal, 16)
        .padding(.top, 64) // Space for floating navigation buttons
        .padding(.bottom, 16)
    }
    
    // MARK: - Detail Content
    private var detailContent: some View {
        VStack(spacing: 32) {
            // Description Section
            descriptionSection
            
            // Categories Section
            categoriesSection
            
            // Deliverables Section
            deliverablesSection
            
            // Requirements Section
            requirementsSection
            
            // About Business Section
            aboutBusinessSection
            
            // Similar Gigs Section
            similarGigsSection
            
            // Bottom Padding for Floating Button
            Color.clear.frame(height: 96) // 8pt grid: 96 = 12 * 8
        }
        .padding(.horizontal, 16) // 8pt grid: 16 = 2 * 8
        .padding(.top, 24) // 8pt grid: 24 = 3 * 8
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Project Description")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text(gig.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skills Needed")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            FlexibleView(
                data: gig.categories,
                spacing: 8,
                alignment: .leading
            ) { category in
                CategoryTag(category: category)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var deliverablesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Deliverables")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(gig.deliverables.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#850101"))
                        
                        Text(gig.deliverables[index])
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requirements")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text(gig.requirements)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var aboutBusinessSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About \(gig.business.name)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(gig.business.description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Industry")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(gig.business.industry)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Member Since")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(formatDate(gig.business.memberSince))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var similarGigsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Similar Gigs")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(ServicesModels.sampleGigs.prefix(3)) { similarGig in
                        ServiceCard(gig: similarGig) {
                            // Navigate to similar gig
                        }
                        .frame(width: 280)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Floating Apply Button
    private var floatingApplyButton: some View {
        VStack(spacing: 0) {
            // Gradient overlay for button visibility
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0),
                    Color.white.opacity(0.8),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32) // 8pt grid: 32 = 4 * 8
            
            // Apply Button
            PrimaryCTAButton(
                title: "Apply",
                isLoading: isApplying
            ) {
                showingApplicationModal = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8) // Space between shadow and button
            .padding(.bottom, 40) // Safe area bottom (8pt grid: 40 = 5 * 8)
            .background(Color.white)
        }
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: -8)
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Flexible View for Categories
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            FlexibleViewContent(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct FlexibleViewContent<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowData in
                HStack(spacing: spacing) {
                    ForEach(rowData, id: \.self) { item in
                        content(item)
                    }
                    if alignment == .leading {
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }
    
    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = []
        var currentRow: [Data.Element] = []
        var currentRowWidth: CGFloat = 0
        
        for item in data {
            let itemWidth = widthForItem(item)
            
            if currentRowWidth + itemWidth + spacing <= availableWidth || currentRow.isEmpty {
                currentRow.append(item)
                currentRowWidth += itemWidth + (currentRow.count > 1 ? spacing : 0)
            } else {
                rows.append(currentRow)
                currentRow = [item]
                currentRowWidth = itemWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private func widthForItem(_ item: Data.Element) -> CGFloat {
        // Estimate width for category tags
        if let category = item as? ServiceCategory {
            return CGFloat(category.name.count * 8 + 40) // Rough estimation
        }
        return 100 // Default width
    }
}

// MARK: - Size Reading Extension
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - Scroll Offset Tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

// MARK: - Preview
struct GigDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GigDetailView(gig: ServicesModels.sampleGigs[0])
    }
} 