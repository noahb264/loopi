//
//  SongListView.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import SwiftUI

struct SongsListView: View {
    var body: some View {
        NavigationView {
            List(testData) { song in
                NavigationLink(destination: SongDetail(song: song)) {
                    SongsRowView(song: song)
                }
            }
            .navigationBarTitle(Text("Songs"))
        }
    }
}

struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            SongsListView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
