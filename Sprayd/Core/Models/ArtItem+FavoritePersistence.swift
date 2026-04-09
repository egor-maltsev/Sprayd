import Foundation
import SwiftData

extension ArtItem {
    @MainActor
    func toggleFavorite(in modelContext: ModelContext) {
        isFavorite.toggle()

        do {
            try modelContext.save()
        } catch {
            isFavorite.toggle()
            print("Favorite save error:", error)
        }
    }
}
