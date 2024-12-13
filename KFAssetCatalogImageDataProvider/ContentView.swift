import SwiftUI
import Kingfisher

struct ContentView : View {
  var body: some View {
    VStack {
      Text("Remote")
      KFImage(URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/logo.png")!)
        .placeholder({ _ in
          ProgressView()
        })
        .resizable()
        .scaledToFit()
      
      Text("Local")
      KFImage(smartURL: URL(string: "asset-catalog://locallogo.jpg?delay=3")!)
        .placeholder({ _ in
          ProgressView()
        })
        .resizable()
        .scaledToFit()
    }
  }
}

#Preview {
  ContentView()
}
