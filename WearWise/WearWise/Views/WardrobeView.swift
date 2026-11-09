//
//  WardrobeView.swift
//  WearWise
//

import SwiftUI
import SwiftData

struct WardrobeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: WardrobeViewModel
    let items: [ClothingItem]

    @State private var showingAddItem = false
    @State private var selectedItem: ClothingItem?

    var filteredItems: [ClothingItem] {
        viewModel.filteredItems(items)
    }

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    EmptyWardrobeView {
                        showingAddItem = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Filters
                            FilterSection(viewModel: viewModel)

                            // Items grouped by category
                            let grouped = viewModel.groupedByCategory(filteredItems)

                            if grouped.isEmpty {
                                Text("No items match your filters")
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                ForEach(ClothingCategory.allCases, id: \.self) { category in
                                    if let categoryItems = grouped[category], !categoryItems.isEmpty {
                                        CategorySection(
                                            category: category,
                                            items: categoryItems,
                                            onItemTap: { item in
                                                selectedItem = item
                                            },
                                            onToggleFavorite: { item in
                                                viewModel.toggleFavorite(context: modelContext, item: item)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Wardrobe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add clothing item")
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddClothingItemView()
            }
            .sheet(item: $selectedItem) { item in
                ClothingItemDetailView(item: item)
            }
        }
    }
}

struct FilterSection: View {
    @ObservedObject var viewModel: WardrobeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search wardrobe...", text: $viewModel.searchText)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All",
                        isSelected: viewModel.selectedCategory == nil,
                        action: { viewModel.selectedCategory = nil }
                    )

                    ForEach(ClothingCategory.allCases, id: \.self) { category in
                        FilterChip(
                            title: category.rawValue,
                            icon: category.icon,
                            isSelected: viewModel.selectedCategory == category,
                            action: { viewModel.selectedCategory = category }
                        )
                    }
                }
            }

            // Formality filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All Styles",
                        isSelected: viewModel.selectedFormality == nil,
                        action: { viewModel.selectedFormality = nil }
                    )

                    ForEach(FormalityLevel.allCases, id: \.self) { formality in
                        FilterChip(
                            title: formality.description,
                            isSelected: viewModel.selectedFormality == formality,
                            action: { viewModel.selectedFormality = formality }
                        )
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    var icon: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
    }
}

struct CategorySection: View {
    let category: ClothingCategory
    let items: [ClothingItem]
    let onItemTap: (ClothingItem) -> Void
    let onToggleFavorite: (ClothingItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                Text(category.rawValue)
                    .font(.headline)
                Spacer()
                Text("\(items.count)")
                    .foregroundColor(.secondary)
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(items) { item in
                    WardrobeItemCard(
                        item: item,
                        onTap: { onItemTap(item) },
                        onToggleFavorite: { onToggleFavorite(item) }
                    )
                }
            }
        }
    }
}

struct WardrobeItemCard: View {
    let item: ClothingItem
    let onTap: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Color preview
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: item.color) ?? .gray)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: item.category.icon)
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.8))
                    )

                // Favorite button
                Button {
                    onToggleFavorite()
                } label: {
                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(item.isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .accessibilityLabel(item.isFavorite ? "Remove from favorites" : "Add to favorites")
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .lineLimit(1)

                Text(item.color)
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "thermometer")
                    Text(item.warmthLevel.description)
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
        .onTapGesture(perform: onTap)
    }
}

struct EmptyWardrobeView: View {
    let onAddItem: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Your Wardrobe is Empty")
                .font(.title2)
                .bold()

            Text("Start adding your clothing items to get personalized outfit suggestions.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button(action: onAddItem) {
                Label("Add First Item", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct ClothingItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let item: ClothingItem
    @State private var showingDeleteAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Color preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: item.color) ?? .gray)
                            .frame(height: 200)

                        Image(systemName: item.category.icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()

                    // Details
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(label: "Category", value: item.category.rawValue)
                        DetailRow(label: "Color", value: item.color)
                        DetailRow(label: "Warmth Level", value: item.warmthLevel.description)
                        DetailRow(label: "Formality", value: item.formalityLevel.description)

                        if !item.weatherSuitability.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Weather Suitability")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                FlowLayout(spacing: 8) {
                                    ForEach(item.weatherSuitability, id: \.self) { condition in
                                        HStack(spacing: 4) {
                                            Image(systemName: condition.icon)
                                            Text(condition.rawValue)
                                        }
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        DetailRow(label: "Added", value: item.dateAdded.formatted(date: .abbreviated, time: .omitted))
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .accessibilityLabel("Delete item")
                }
            }
            .alert("Delete Item", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    modelContext.delete(item)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete \(item.name)?")
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
        .padding(.horizontal)
    }
}

// Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
