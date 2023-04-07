//
//  DITFeature.swift
//  DIT
//
//  Created by cdann on 4/6/23.
//

import ComposableArchitecture
import Dependencies
import Foundation

struct DIT: ReducerProtocol {
  @Dependency(\.continuousClock) var continuousClock

  struct State: Equatable, Sendable {
    var value: Int
  }

  enum Action: Equatable, Sendable {
    case setValue(Int)
    case delayed
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .setValue(let value):
        state.value = value

        return .run { send in
          try? await continuousClock.sleep(for: .seconds(1))
          guard !Task.isCancelled else { return }
          await send(.delayed)
        }
      case .delayed:
        print("Delayed Effect: current value(\(state.value))")
        return .none
      }
    }
  }
}
