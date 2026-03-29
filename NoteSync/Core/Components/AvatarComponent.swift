//
//  AvatarComponent.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 28/03/26.
//

import Foundation
import SwiftUI

struct UserAvatarView: View {
    var photoUrl: String?
    var displayName: String?
    var size: CGFloat
    
    var initials: String {
        guard let name = displayName, !name.isEmpty else { return "?"}
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        
        return String(name.prefix(1)).uppercased()
    }
    var body: some View {
        Group {
            if let urlString = photoUrl,
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        initialsView
                            .overlay(
                                Circle()
                                    .stroke(Color.accentOrange, lineWidth: 1)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        initialsView
                    @unknown default:
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
    
    private var initialsView: some View {
        ZStack {
            Circle()
                .fill(Color.accentYellow)

            Text(initials)
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundColor(.black)
        }
    }
}
