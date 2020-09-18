//
//  SongListView.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import SwiftUI

struct SongsListView: View {
    @EnvironmentObject var userData: UserData
    @State var modal = false
    
    var body: some View {
        TabView {
            NavigationView {
                List(userData.audioController.songs) { song in
                    NavigationLink(destination: SongDetail(song: song)) {
                        SongsRowView(song: song)
                    }
                }
                .navigationBarTitle(Text("Songs"))
            }
            .tabItem {
                Image(systemName: "music.note")
                Text("Songs")
            }
            
            NavigationView {
                List(userData.audioController.songs) { song in
                    Button(action: {
                        self.modal = true
                    }) {
                        SongsRowView(song: song)
                    }.sheet(isPresented: $modal) {
                        Button(action: {
                            self.modal = false
                        }) {
                            Text("Close")
                        }
                    }
                }
                .navigationBarTitle(Text("Loop"))
            }
            .tabItem {
                Image(systemName: "waveform")
                Text("Loop")
            }
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
