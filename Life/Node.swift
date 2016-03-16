//
//  Node.swift
//  Life
//
//  Created by David Westgate on 3/13/16.
//  Copyright © 2016 Refabricants. All rights reserved.
//

import Foundation

class Node<T> {
  
  var value: T? = nil
  var row = 0
  var col = 0
  var nodeAbove: Node<T>? = nil
  var nodeBelow: Node<T>? = nil
  var nodeOnLeft: Node<T>? = nil
  var nodeOnRight: Node<T>? = nil
  
  init(_ value: T?, row: Int, col: Int, nodeOnLeft: Node?, nodeOnRight: Node?, nodeAbove: Node?, nodeBelow: Node?) {
    self.value = value
    self.row = row
    self.col = col
    self.nodeAbove = nodeAbove
    self.nodeBelow = nodeBelow
    self.nodeOnLeft = nodeOnLeft
    self.nodeOnRight = nodeOnRight
  }
  
  init(_ value: T?, row: Int, col: Int) {
    self.value = value
    self.col = col
    self.row = row
  }
  
  init(_ value: T?, row: Int, previous: Node?, next: Node?) {
    self.value = value
    self.row = row
    self.nodeAbove = previous
    self.nodeBelow = next
  }
  
  init(_ value: T?, col: Int, previous: Node?, next: Node?) {
    self.value = value
    self.col = col
    self.nodeOnLeft = previous
    self.nodeOnRight = next
  }
  
  init(_ value: T?, row: Int) {
    self.value = value
    self.row = row
  }
  
  init(_ value: T?, col: Int) {
    self.value = value
    self.col = col
  }
  
  init(_ value: T?, next: Node?) {
    self.value = value
    self.nodeOnRight = next
  }
  
  init(_ value: T?) {
    self.value = value
  }
  
  init(row: Int) {
    self.row = row
  }
  
  init(col: Int) {
    self.col = col
  }
  
  init() {}
  
}
