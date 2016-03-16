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


if (Process.arguments.count == 4) {
    
  var inputPath = Process.arguments[1]
  var outputPath = Process.arguments[2]
  var generations = Int(Process.arguments[3])
    
  var currentGeneration = SparseArray(0)
    
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
    var neighborCount = SparseArray(0)
    var nextGeneration = SparseArray(0)
    
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
