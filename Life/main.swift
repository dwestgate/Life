//
//  main.swift
//  Life
//
//  Created by David Westgate on 3/7/16.
//  Copyright © 2016 Refabricants. All rights reserved.
//

import Foundation

func usage() {
  print("This program playse the game of life. It takes three command line\n" +
    "parameters: the filename for the initial conditions, the filename\n" +
    "to output, and the number of generations to simulate.\n" +
    "The program reads in the initial conditions from the specified file,\n" +
    "simulates life for the specified number of generations, and then writes\n" +
    "the result to the output file.\n")
  print("The format for the input and output files are the same and consist of pairs of\n" +
    "integers separated by commas, as follows:\n")
  print("100,100")
  print("100,101")
  print("100,102")
  print("100,103")
  print("100,104")
  print("\nExample: Life testinput.txt testoutput.txt 4\n")
}


// Begin Testing
/*
var lltest = LinkedList<Int>(true)

lltest.insertValueAtPosition(1, position: 10)
lltest.insertValueAtPosition(2, position: 9)
lltest.insertValueAtPosition(3, position: 11)
lltest.insertValueAtPosition(4, position: 7)
lltest.insertValueAtPosition(5, position: 6)
lltest.insertValueAtPosition(6, position: 8)
lltest.insertValueAtPosition(7, position: 12)

var listAsString = ""
for element in lltest {
  listAsString = listAsString + String(element) + "  "
}
// print(listAsString)

// print(lltest.toString())

var satest = MySparseArray(0)

print("     1  2  3  4  5  6  7  8  9")
satest.setValue(7, row: 1, col: 1)
satest.setValue(6, row: 2, col: 1)
satest.setValue(5, row: 9, col: 7)
satest.setValue(4, row: 3, col: 6)
satest.setValue(3, row: 4, col: 4)
satest.setValue(2, row: 6, col: 3)
satest.setValue(1, row: 8, col: 1)
satest.setValue(1, row: 8, col: 2)
satest.setValue(1, row: 8, col: 3)
satest.setValue(1, row: 8, col: 4)
satest.setValue(1, row: 8, col: 5)
satest.setValue(1, row: 8, col: 6)
satest.setValue(1, row: 8, col: 7)
satest.setValue(3, row: 8, col: 8)
satest.setValue(1, row: 8, col: 9)


print(String(satest.elementAt(row: 4, col: 5)))
print(satest.toString())

for i in satest {
  print(String(i))
}
print("")

var g = satest.generate()
while g.hasNext() {
  print(g.next())
}

let y = MySparseArray(0)
var x = y.generate()
while x.hasNext() {
  print(x.next())
}
print("it worked!")
*/
// End Testing

if (Process.arguments.count == 4) {
    
  var inputPath = Process.arguments[1]
  var outputPath = Process.arguments[2]
  var generations = Int(Process.arguments[3])
    
  var currentGeneration = MySparseArray(0)
    
  var line: String
  
  print(NSFileManager.defaultManager().currentDirectoryPath)
  print("inputPath = \(inputPath)")
  print("outputPath = \(outputPath)")
  print("generations = \(String(generations))")
  
  
  let fileContents: String?
  do {
    fileContents = try NSString(contentsOfFile: inputPath, encoding: NSUTF8StringEncoding) as String?
  } catch _ {
    print("Error reading input file")
    fileContents = nil
  }
  
  let values = fileContents!.componentsSeparatedByString("\n")
  
  var valuesGenerator = values.generate()
  for value in valuesGenerator {
    let position = value.componentsSeparatedByString(",")
    if position.count == 2 {
    currentGeneration.setValue(1, row: Int(position[0])!, col: Int(position[1])!)
    }
  }
  
  for (var generation = 0; generation < generations; generation++) {
    var neighborCount = MySparseArray(0)
    var nextGeneration = MySparseArray(0)
    
    var row = 0
    
    var currentGenerationIterator = currentGeneration.generate()
    
    while (currentGenerationIterator.hasNext()) {
      let value = currentGenerationIterator.next()
      let row = currentGenerationIterator.currentNode?.row
      let col = currentGenerationIterator.currentNode?.col
      
      var counter = Int(neighborCount.elementAt(row: row! - 1, col: col! - 1)) + 1
      neighborCount.setValue(counter, row: row! - 1, col: col! - 1)
      
      counter = Int(neighborCount.elementAt(row: row! - 1, col: col!)) + 1
      neighborCount.setValue(counter, row: row! - 1, col: col!)
      
      counter = Int(neighborCount.elementAt(row: row! - 1, col: col! + 1)) + 1
      neighborCount.setValue(counter, row: row! - 1, col: col! + 1)
      
      counter = Int(neighborCount.elementAt(row: row!, col: col! - 1)) + 1
      neighborCount.setValue(counter, row: row!, col: col! - 1)
      
      counter = Int(neighborCount.elementAt(row: row!, col: col! + 1)) + 1
      neighborCount.setValue(counter, row: row!, col: col! + 1)
      
      counter = Int(neighborCount.elementAt(row: row! + 1, col: col! - 1)) + 1
      neighborCount.setValue(counter, row: row! + 1, col: col! - 1)
      
      counter = Int(neighborCount.elementAt(row: row! + 1, col: col!)) + 1
      neighborCount.setValue(counter, row: row! + 1, col: col!)
      
      counter = Int(neighborCount.elementAt(row: row! + 1, col: col! + 1)) + 1
      neighborCount.setValue(counter, row: row! + 1, col: col! + 1)
    }
    
    var neighborCountIterator = neighborCount.generate()
    
    while (neighborCountIterator.hasNext()) {
      let value = neighborCountIterator.next()
      let row = neighborCountIterator.currentNode?.row
      let col = neighborCountIterator.currentNode?.col
      
      if ((value == 3) || ((value == 2) &&
          currentGeneration.elementAt(row: row!, col: col!) !=
          currentGeneration.defaultValue)) {
              nextGeneration.setValue(1, row: row!, col: col!)
      }
    }
    
    currentGeneration = nextGeneration
  }
  
  var currentGenerationIterator = currentGeneration.generate()
  var text = ""
  
  while (currentGenerationIterator.hasNext()) {
    let value = currentGenerationIterator.next()
    let row = currentGenerationIterator.currentNode?.row
    let col = currentGenerationIterator.currentNode?.col
    
    text += String(format: "%d,%d\n", row!, col!)
  }
  
    do {
      try text.writeToFile(outputPath, atomically: false, encoding: NSUTF8StringEncoding)
    }
    catch {
      print("Error writing file")
    }
  
} else {
  usage()
}
    
/*

      
      RowIterator neighborRow = NeighborCount.iterateRows()
      
      while (neighborRow.hasNext()) {
        ElemIterator elem = neighborRow.next()
        row = elem.nonIteratingIndex()
        while (elem.hasNext()) {
          int col = elem.next().columnIndex()
          
          if ((NeighborCount.elementAt(row, col).equals(new Integer(3))) ||
            ((NeighborCount.elementAt(row, col).equals(
              new Integer(2)) && !CurrentGeneration.elementAt(row, col)
                .equals(CurrentGeneration.defaultValue())))) {
                  NextGeneration.setValue(row, col, new Integer(1))
          }
        }
      }
      
      CurrentGeneration = NextGeneration
      
    }
    
    
    try (BufferedWriter bw = new BufferedWriter(new FileWriter(outputPath))) {
      
      RowIterator currentRow = CurrentGeneration.iterateRows()
      int row = 0
      
      while (currentRow.hasNext()) {
        ElemIterator elem = currentRow.next()
        row = elem.nonIteratingIndex()
        while (elem.hasNext()) {
          int col = elem.next().columnIndex()
          bw.write(String.format("%d,%d%n", row, col))
        }
        
      }
      print("Output file %s generated successfully, exiting.", outputPath)
    } catch (IOException e) {
      print("Error writing to output file")
    }
  }
 else {
    usage()
  }*/
