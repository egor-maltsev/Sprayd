//
//  ArtObjectViewModel.swift
//  Sprayd
//

import Foundation
import SwiftData

@Observable
final class ArtObjectViewModel {
    // MARK: - Data fields
    let name: String
    let itemDescription: String
    let photoImageNames: [String]
    let location: String
    let author: String
    let category: String
    let postedBy: String
    let dateText: String

    // MARK: - UI state
    var selectedPhotoIndex: Int = 0
    var isPhotoPreviewPresented: Bool = false
    var isFavorite: Bool = false
    var isVisited: Bool = false
    private var item: ArtItem?

    // MARK: - Init
    init(
        name: String,
        itemDescription: String,
        photoImageNames: [String],
        location: String,
        author: String,
        category: String,
        postedBy: String,
        dateText: String
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.photoImageNames = photoImageNames
        self.location = location
        self.author = author
        self.category = category
        self.postedBy = postedBy
        self.dateText = dateText
        self.item = nil
    }

    convenience init(item: ArtItem) {
        let uploadedByValue = item.uploadedBy?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let imageURLs = item.images
            .map(\.urlString)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        self.init(
            name: item.name,
            itemDescription: item.itemDescription,
            photoImageNames: imageURLs,
            location: item.location,
            author: item.author,
            category: item.category,
            postedBy: (uploadedByValue?.isEmpty == false ? uploadedByValue! : "Unknown"),
            dateText: item.createdAt.formatted(date: .numeric, time: .omitted)
        )

        self.item = item
        isFavorite = item.isFavorite
    }

    // MARK: - Actions

    func toggleFavorite() {
        isFavorite.toggle()
        item?.isFavorite = isFavorite
    }

    func toggleVisited() {
        isVisited.toggle()
    }

    func openPhotoPreview(at index: Int) {
        selectedPhotoIndex = index
        isPhotoPreviewPresented = true
    }
}
