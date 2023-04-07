//
//  ContentView.swift
//  DIT
//
//  Created by cdann on 4/6/23.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  let ditStore: StoreOf<DIT>
  var body: some View {
    VStack {
      WithViewStore(ditStore) { ditViewStore in
        Text("Value is: \(ditViewStore.value)")
        Button(
          action: {
            ditViewStore.send(
              .setValue(ditViewStore.value + 20)
            )
          },
          label: {
            HStack {
              Image(systemName: "globe")
              Text("Press Me")
            }
          }
        )
      }

      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      ditStore: .init(
        initialState: .init(value: 0),
        reducer: DIT()
      )
    )
  }
}
