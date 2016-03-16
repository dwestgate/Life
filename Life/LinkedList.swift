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

  /*func add(newNode: Node<T>) {
    
    if (head === tail) {
      tail.nodeOnRight = newNode
      tail = tail.nodeOnRight!
      count++
    } else {
      var tmp1 = head
      var tmp2 = head.nodeOnRight
      
      while ((tmp2!.nodeOnRight != nil) &&
        (newNode.row > tmp2!.row)) {
          tmp1 = tmp2!
          tmp2 = tmp2!.nodeOnRight
      }
      
      if (newNode.row == tmp2!.row) {
      } else if (newNode.row < tmp2!.row) {
        newNode.nodeOnRight = tmp2
        tmp1.nodeOnRight = newNode
        count++
      } else {
        tail.nodeOnRight = newNode
        tail = tail.nodeOnRight!
        count++
      }
    }
  }*/
 
  /*
  func insertAtPosition(node: Node<T>, col: Int, row: Int) {
    insertAtHorizontalPosition(node: node, position: col)
    insertAtVerticalPosition(node: node, position: row)
  }*/
  
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
  
  /*func insertValueAtPosition(value: LinkedList<T>, position: Int) {
    if isVertical {
      insertNode(Node(value, row: position))
    } else {
      insertNode(Node(value, col: position))
    }
  }*/
  
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
  /*
  func add(value: T, colIndex: Int, rowIndex: Int) -> Node<T>? {
    
    if (head === tail) {
      tail.nodeBelow = newNode
      tail.nodeAbove = tail
      tail = tail.nodeBelow!
      count++
      return newNode
    } else {
      var tmp1 = head
      var tmp2 = head.nodeBelow
      
      while ((tmp2!.nodeBelow != nil) && (colIndex > tmp2!.col)) {
        tmp1 = tmp2!
        tmp2 = tmp2!.nodeBelow
      }
      
      if (colIndex == tmp2!.col) {
        tmp2!.value = value
      } else if (colIndex < tmp2!.col) {
        let newNode = Node(value, col: colIndex, row: rowIndex, direction: "d", nodeAbove: tmp1, nodeBelow: tmp2, nodeOnLeft: nil, nodeOnRight: nil)
        tmp1.nodeBelow = newNode
        count++
        return newNode
      } else {
        let newNode = Node(value, col: colIndex, row: rowIndex, direction: "d", nodeAbove: tail, nodeBelow: nil, nodeOnLeft: nil, nodeOnRight: nil)
        tail = tail.nodeBelow!
        count++
        return newNode
      }
    }
    return nil
  }*/
  
  /**
   * Sets the LinkedList to nil
   */
  func clear() {
    head.nodeBelow = nil
    tail = head
    count = 0
  }
  
  // TODO: Fix this
  /**
   * Returns a new iterator for the row or column
   *
   * @param type ROW or COL
   * @return The newly-instantiated iterator
   */
//  func ElementIterator elemIterator(MySparseArray.ListType type) {
//    return new ElementIterator(type)
//  }
  
  /**
   * Returns an element of a row
   *
   * @param row The row
   * @return The value of the element at the given row position
   */
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
  
  /**
   * Returns an element of a col
   *
   * @param col The column
   * @return The value of the element at the given row position
   */
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
  
  /**
   * @return The column number of the column - used to determine which column we are at when traversing columns
   */
  func getColumnIndex() -> Int {
    return head.col
  }
  
  /**
   * @return THe row number of the row - used to determine which row we are at when traversing rows
   */
  func getRowIndex() -> Int {
    return head.row
  }
  
  /**
   * Deletes an element from a row
   *
   * @param index The column of the row element to be deleted
   * @return The new count of the LinkedList representing the row - this value is used to determine when all
   * elements of a row have been deleted and thus the row itself should be removed
   */
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
  
  /**
   * Deletes an element from a column
   *
   * @param index The row of the row element to be deleted
   * @return The new count of the LinkedList representing the column - this value is used to determine when all
   * elements of a column have been deleted and thus the column itself should be removed
   */
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
  
  // TODO: Fix this
  /**
   * Removes the first occurrence of the NSObject o from the list.  If the NSObject appears more than once, only the
   * first occurrence is removed.  If the NSObject does not occur in the list, the method does nothing.
   *
   * @param o The value of the element to be removed
   */
  /*func remove(value: T) {
    var tmp = head
    
    while (tmp.nodeBelow !== nil) {
      if (tmp.nodeBelow!.value == value) {
        tmp.setnodeBelow(tmp.nodeBelow!.nodeBelow!)
        break
      }
      tmp = tmp.nodeBelow!
    }
  }*/
  
  /**
   * @return The number of non-default values in the row or column LinkedList
   */
  func size() -> Int {
    return count
  }
  
  /**
   * @return A string representation of the LinkedList that consists of the list values separated by spaces
   * instead of the default value.
   */
  func toString() -> String {
    /*var listAsString = ""
    for element in self {
      listAsString = listAsString + String(element) + "  "
    }
    return listAsString*/
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
    
    /*
    while ((c < tail.col) && (current.nodeOnRight != nil)) {
      c++
      if (current.col == c) {
        current = current.nodeOnRight!
        if let s = current.value {
          listAsString = listAsString + " " + String(s) + "  "
        }
      } else {
        listAsString = listAsString + "   "
      }
    }
    listAsString = listAsString + " " + String(current.value!)*/
    return listAsString
  }
}


extension LinkedList: SequenceType {
  func generate() -> DoublyLinkedListGenerator<T> {
    return DoublyLinkedListGenerator(self)
  }
}

// Todo: Fix this
/**
* Iterator for the Elem class
*/
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
  
  /**
   *
   * @return  True if the row or column being traversed has more Elems
   */
  func hasNext() -> Bool {
    if isVertical {
      return current != nil && current?.nodeBelow != nil
    } else {
      return current != nil && current?.nodeOnRight != nil
    }
  }
}