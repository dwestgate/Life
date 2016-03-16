//
//  MySparseArray.swift
//  Life
//
//  Created by David Westgate on 3/7/16.
//  Copyright © 2016 Refabricants. All rights reserved.
//

import Foundation

class MySparseArray<T> {

  var defaultValue: T
  var rows: LinkedList<LinkedList<T>>
  var cols: LinkedList<LinkedList<T>>
  // var size = 0

  /**
   * Constructor
   *
   * @param defaultValue The MySparseArray default value - elements that do not exist are assumed to have this value.
   */
  init(_ defaultValue: T) {
    self.defaultValue = defaultValue
    cols = LinkedList()
    rows = LinkedList(cols.head, isVertical: true)
  }
  
  func setValue(value: T, row: Int, col: Int) {
    let newNode = Node(value, row: row, col: col)
    
    if let colAtIndex = cols.getValueAtCol(col) {
      colAtIndex.insertNode(newNode)
    } else {
      let newCol = LinkedList<T>(true, position: col)
      cols.insertValueAtPosition(newCol, position: col)
      newCol.insertNode(newNode)
    }
    if let rowAtIndex = rows.getValueAtRow(row) {
      rowAtIndex.insertNode(newNode)
    } else {
      let newRow = LinkedList<T>(row)
      rows.insertValueAtPosition(newRow, position: row)
      newRow.insertNode(newNode)
    }
  }
  
  func elementAt(row row: Int, col: Int) -> T {
    guard let colAtIndex = cols.getValueAtCol(col) else {
      return defaultValue
    }
    
    guard let elementAtRow = colAtIndex.getValueAtRow(row) else {
      return defaultValue
    }
    return elementAtRow
  }
  
  func toString() -> String {
    var listAsString = ""
    var c = 1
    var current = rows.head
    while ((c < 15) && (current.nodeBelow != nil)) {
      if (current.nodeBelow!.row == c) {
        current = current.nodeBelow!
        let v = current.value
        let s = v!.toString()
        listAsString = listAsString + String(c) + " - " + s + "\n"
        
        c++
      } else {
        listAsString = listAsString + String(c) + "\n"
        c++
      }
    }
    return listAsString
  }
  
}


extension MySparseArray: SequenceType {
  func generate() -> SparseArrayGenerator<T> {
    return SparseArrayGenerator(self)
  }
}

// Todo: Fix this
/**
* Iterator for the Elem class
*/
struct SparseArrayGenerator<T>: GeneratorType {
  var rows: LinkedList<LinkedList<T>>
  var cols: LinkedList<LinkedList<T>>
  var currentRow: Node<LinkedList<T>>
  var currentList: LinkedList<T>?
  var currentNode: Node<T>?
  
  init(_ sparseArray: MySparseArray<T>) {
    rows = sparseArray.rows
    cols = sparseArray.cols
    currentRow = rows.head
  }
  
  mutating func next() -> T? {
    // If this is the first row in the list and therefore has no List, advance to next row
    // If we this is the row tail and the list tail, return nil
    // If this is not the row tail but is the current list's tail, advance one row and call next
    if (currentRow.value == nil) {
      if (currentRow === rows.tail) {
        return nil
      } else {
        currentRow = currentRow.nodeBelow!
        currentNode = currentRow.value?.head
        next()
      }
    } else if (currentNode === currentRow.value?.tail) {
      if (currentRow === rows.tail) {
        return nil
      } else {
        currentRow = currentRow.nodeBelow!
        currentNode = currentRow.value?.head
        next()
      }
    } else {
      currentNode = currentNode?.nodeOnRight
      return currentNode?.value
    }
    return currentNode?.value
  }

  
  /**
   *
   * @return  True if the row or column being traversed has more Elems
   */
  func hasNext() -> Bool {
    let emptyArray = ((currentRow === rows.tail) && (currentRow.value == nil))
    let lastNode = (currentNode === rows.tail.value?.tail)
    return !(emptyArray || lastNode)
  }
}