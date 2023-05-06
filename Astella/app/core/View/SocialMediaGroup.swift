//
//  SocialMediaGroup.swift
//  Astella
//
//  Created by Keith Kirtfield on 4/29/23.
//

import SwiftUI


struct SocialMediaGroup : View {
    var body: some View {
        HStack {
            
            Label("Twitter", systemImage: "bird" )
                .foregroundColor(.gray)
                .underline()
            Label("TikTok", systemImage: "clock" )
                .foregroundColor(.gray)
                .underline()
            Label("Instagram", systemImage: "camera" )
                .foregroundColor(.gray)
                .underline()
            
            Spacer()

        }
        .padding(.horizontal)
    }
}


struct SocialMediaGroup_Previews : PreviewProvider {
    static var previews : some View {
        SocialMediaGroup()
    }
}
