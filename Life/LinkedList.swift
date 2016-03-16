//
//  LinkedList.swift
//  Life
//
//  Created by David Westgate on 3/10/16.
//  Copyright © 2016 Refabricants. All rights reserved.
//

import Foundation

class LinkedList<T> {
  
  let head: Node<T>
  var tail: Node<T>
  private var count = 0
  private var isVertical = false

  init(_ value: Node<T>, isVertical: Bool) {
    self.head = value
    self.tail = self.head
    self.isVertical = isVertical
  }
  
  init(_ isVertical: Bool) {
    self.head = Node<T>()
    self.tail = self.head
    self.isVertical = isVertical
  }
  
  init(_ isVertical: Bool, position: Int) {
    if isVertical {
      self.head = Node<T>(col: position)
      self.isVertical = isVertical
    } else {
      self.head = Node<T>(row: position)
    }
    self.tail = self.head
  }
  
  init(_ position: Int) {
    self.head = Node<T>(row: position)
    self.tail = self.head
  }
  
  init() {
    self.head = Node<T>()
    self.tail = self.head
  }

  
  func appendWithPosition(node: Node<T>, position: Int) {
    if isVertical {
      node.row = position
      append(node)
    } else {
      node.col = position
      append(node)
    }
  }
  
  func append(node: Node<T>) {
    if isVertical {
      tail.nodeBelow = node
      node.nodeAbove = tail
      tail = node
    } else {
      tail.nodeOnRight = node
      node.nodeOnLeft = tail
      tail = node
    }
    count++
  }
  
  func insertValueAtPosition(value: T, position: Int) {
    if isVertical {
      insertNode(Node(value, row: position))
    } else {
      insertNode(Node(value, col: position))
    }
  }
  
  func insertNode(node: Node<T>) {
    
    if (head === tail) {
      append(node)
    } else if isVertical {
      var current = head
      var next = head.nodeBelow
      
      while ((next!.nodeBelow != nil) && (node.row > next!.row)) {
        current = next!
        next = next!.nodeBelow
      }
      
      if (node.row == next!.row) {
        next!.value = node.value
      } else if (node.row < next!.row) {
        node.nodeAbove = current
        node.nodeBelow = next
        current.nodeBelow = node
        next?.nodeAbove = node
        count++
      } else {
        append(node)
      }
    } else {
      var current = head
      var next = head.nodeOnRight
      
      while ((next!.nodeOnRight != nil) && (node.col > next!.col)) {
        current = next!
        next = next!.nodeOnRight
      }
      
      if (node.col == next!.col) {
        next?.value = node.value
      } else if (node.col < next!.col) {
        node.nodeOnLeft = current
        node.nodeOnRight = next
        current.nodeOnRight = node
        next?.nodeOnLeft = node
        count++
      } else {
        append(node)
      }
    }
    
  }
  
  func clear() {
    head.nodeBelow = nil
    tail = head
    count = 0
  }
  
  func getValueAtRow(row: Int) -> T? {
    var elemPointer = head
    
    while ((row > elemPointer.row) && (elemPointer.nodeBelow != nil)) {
      elemPointer = elemPointer.nodeBelow!
    }
    if (row == elemPointer.row) {
      return elemPointer.value
    }
    return nil
  }
  
  func getValueAtCol(col: Int) -> T? {
    var elemPointer = head
    
    while ((col > elemPointer.col) && (elemPointer.nodeOnRight != nil)) {
      elemPointer = elemPointer.nodeOnRight!
    }
    if (col == elemPointer.col) {
      return elemPointer.value
    }
    return nil
  }
  
  func getColumnIndex() -> Int {
    return head.col
  }
  
  func getRowIndex() -> Int {
    return head.row
  }

  func removeFromRow(index: Int) -> Int {
    var elemPointer1 = head
    var elemPointer2 = head.nodeBelow
    
    while ((index > elemPointer2!.col) && (elemPointer2!.nodeBelow != nil)) {
      elemPointer1 = elemPointer2!
      elemPointer2 = elemPointer2!.nodeBelow
    }
    if (elemPointer2 === tail) {
      elemPointer1.nodeBelow = nil
      tail = elemPointer1
    } else if (index == elemPointer2!.col) {
      elemPointer1.nodeBelow = elemPointer2!.nodeBelow
    }
    return count--
  }

  func removeFromCol(index: Int) -> Int {
    var elemPointer1 = head
    var elemPointer2 = head.nodeOnRight
    
    while ((index > elemPointer2!.row) && (elemPointer2!.nodeOnRight != nil)) {
      elemPointer1 = elemPointer2!
      elemPointer2 = elemPointer2!.nodeOnRight
    }
    if (elemPointer2 === tail) {
      elemPointer1.nodeOnRight = nil
      tail = elemPointer1
    } else if (index == elemPointer2!.row) {
      elemPointer1.nodeOnRight = elemPointer2!.nodeOnRight
    }
    return count--
  }

  func size() -> Int {
    return count
  }
  
  func toString() -> String {
    var listAsString = ""
    var c = 0
    var current = head
    
    repeat {
      current = current.nodeOnRight!
      c++
      while (c < current.col) {
        c++
        listAsString = listAsString + "   "
      }
      
      if let s = current.value {
        listAsString = listAsString + " " + String(s) + " "
      }
    } while current !== tail
    
    return listAsString
  }
}

extension LinkedList: SequenceType {
  func generate() -> DoublyLinkedListGenerator<T> {
    return DoublyLinkedListGenerator(self)
  }
}

struct DoublyLinkedListGenerator<T>: GeneratorType {
  var current: Node<T>?
  var isVertical: Bool
  
  init(_ list: LinkedList<T>) {
    current = list.head
    isVertical = list.isVertical

  }
  
  mutating func next() -> T? {
    if isVertical {
      current = current?.nodeBelow
    } else {
      current = current?.nodeOnRight
    }
    return current?.value
  }
  
  func hasNext() -> Bool {
    if isVertical {
      return current != nil && current?.nodeBelow != nil
    } else {
      return current != nil && current?.nodeOnRight != nil
    }
  }
}