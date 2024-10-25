import SwiftUI

struct NavigationButton: View {
    var label: String
    var icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(label)
                .font(.caption)
        }
    }
}
