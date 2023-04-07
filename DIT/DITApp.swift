//
//  DITApp.swift
//  DIT
//
//  Created by cdann on 4/6/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct DITApp: App {
  var ditStore: StoreOf<DIT> = .init(initialState: .init(value: 0), reducer: DIT())

  var body: some Scene {
    WindowGroup {
      ContentView(ditStore: ditStore)
    }
  }
}
