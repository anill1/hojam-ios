import SwiftUI

struct MatchDetailView: View {
    let match: MatchItem

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AvatarView(url: match.profile.photos.first, size: 140, anonymityMode: match.profile.anonymityMode)
                Text(match.profile.name)
                    .font(UniTypography.titleMedium)
                Text(match.profile.bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 12) {
                    Text("profile_faculty_placeholder")
                        .font(UniTypography.bodyBold)
                    Text(match.profile.faculty)
                    Text("profile_department_placeholder")
                        .font(UniTypography.bodyBold)
                    Text(match.profile.department)
                    Text("profile_photos")
                        .font(UniTypography.bodyBold)
                    ForEach(match.profile.interests) { interest in
                        TagChip(interest.title)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
                .padding(.horizontal)
            }
            .padding(.top, 32)
        }
        .navigationTitle(Text(match.profile.name))
    }
}
