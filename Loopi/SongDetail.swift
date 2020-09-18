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
            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 100.0)
                
            
            Text(song.title)
            HStack {
                Spacer()
                Button(action: {
                    userData.audioController.seekTo(time: 0.0)
                }) {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                }
                Spacer()
                Button(action: {
                    self.userData.audioController.toggle()
                }) {
                    if self.userData.audioController.isPlaying() {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                    } else {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                        
                }
                Spacer()
                Button(action: {
                    self.userData.audioController.toggleRain()
                }) {
                    if self.userData.audioController.isRaining() {
                        Image(systemName: "cloud.rain.fill")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                    } else {
                        Image(systemName: "cloud.rain")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                    
                }
                Spacer()
            }
            Slider(value: $userData.sliderValue, in: 0...100, onEditingChanged: { _ in
                self.userData.seek()
            })
            
        }
        .navigationBarTitle(Text(song.title), displayMode: .inline)
        .onAppear(perform: {
            userData.prepare(song: song)
        })
    }
}

struct SongDetail_Previews: PreviewProvider {
    static var previews: some View {
        SongDetail(song: testData[0]).environmentObject(UserData())
    }
}
