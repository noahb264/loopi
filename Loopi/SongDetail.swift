//
//  SongDetail.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import SwiftUI


struct SongDetail: View {
    var song: Song
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            Text(song.title)
            Text(self.userData.isPlaying.description)
            Text(self.userData.sliderValue.description)
            Button(action: {
                self.userData.audioController.toggle()
                self.userData.isPlaying.toggle()
               
            }) {
                if self.userData.isPlaying {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                } else {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                }
                    
            }
            Slider(value: $userData.sliderValue, in: 0...100, onEditingChanged: { _ in
                self.userData.seek()
            })
            
        }.navigationBarTitle(Text(song.title), displayMode: .inline)
    }
}

struct SongDetail_Previews: PreviewProvider {
    static var previews: some View {
        SongDetail(song: testData[0]).environmentObject(UserData())
    }
}
