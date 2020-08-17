//
//  SongsRowView.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import SwiftUI

struct SongsRowView: View {
    var song: Song
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.title)
                Text(song.artist)
            }
            Spacer()
        }
    }
}

struct SongsRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongsRowView(song: testData[0])
            SongsRowView(song: testData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
