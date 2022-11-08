import Foundation
import SwiftUI
import Commons

public struct ImportViewCategoryItem: View {

    private let icon: [String]
    private let title: String
    private let description: String

    public init(icon: [String], title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: -6) {
                    ForEach(icon, id:\.self) { icon in
                        Image(icon)
                            .frame(width: 32, height: 32)
                            .padding([.leading, .top], 16)
                    }
                }
                Text(title)
                    .foregroundColor(Color(Colors.Label.primary))
                    .padding(.leading, 16).padding(.top, 8)
                    .font(.system(size: 17, weight: .semibold))
                HStack {
                    Text(description)
                        .foregroundColor(Color(Colors.Label.secondary))
                        .padding([.leading, .bottom], 16).padding(.top, 8)
                        .font(.system(size: 13, weight: .regular))
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .background(Color(Colors.System.secondary))
        .cornerRadius(14)
    }
}
