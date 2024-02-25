//
//  ContentView.swift
//  MineSwepper_iPhone
//
//  Created by Konrad Ceniuch on 25.02.24.
//

import SwiftUI

let width: Int = 5
let length: Int = 10
let numberOfMinesAbsolut = 5
var viewModel = MineSweeperViewModel()

struct ContentView: View {
    
    var body: some View {
        let rangeX = 0..<width
        let rangeY = 0..<length
        
        VStack {
            ForEach(rangeY, id: \.self) { y in
                HStack {
                    ForEach(rangeX, id: \.self) { x in
                        HStack {
                            Button(viewModel.cellText(x: x, y: y)) {
                                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

class MineSweeperViewModel: ObservableObject {
    var playground: Playground
    
    init() {
        self.playground = Playground(x: width, y: length, numberOfMines: numberOfMinesAbsolut)
    }
    
    func leftClick(x: Int, y: Int) {
        playground.leftClick(givenX: x, givenY: y)
    }
    
    func cellText(x: Int, y: Int) -> String {
        var field = playground.playgroundArray[x][y]
        if field.getIsMine() {
            return("💣")
        } else {
            return("❤️")
        }
    }
}

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

class Field {
    var isOpen: Bool
    var isMine: Bool
    var numberOfMines: Int
    var numberOfMinesNearby: Int
    
    init(isOpen: Bool, isMine: Bool, numberOfMines: Int, numberOfMinesNearby: Int) {
        self.isOpen = isOpen
        self.isMine = isMine
        self.numberOfMines = numberOfMines
        self.numberOfMinesNearby = numberOfMinesNearby
    }
    
    func getIsOpen() -> Bool {
        return isOpen
    }
    
    func setIsOpen(isOpen: Bool) {
        self.isOpen = isOpen
    }
    
    func getIsMine() -> Bool {
        return isMine
    }
    
    func setIsMine(isMine: Bool) {
        self.isMine = isMine
    }
    
    func setNumberOfMinesNearby() {
        self.numberOfMines += 1
    }
    
    func getNumberOfMinesNearby() -> Int {
        return numberOfMines
    }
}

class Playground  {
    var x: Int
    var y: Int
    var numberOfMines: Int
    var playgroundArray: [[Field]] = []
    
    init(x: Int, y: Int, numberOfMines: Int) {
        self.x = x
        self.y = y
        self.numberOfMines = numberOfMines
        
        executeFunctions()
    }
    
    func getNumberOfMines() -> Int {
        return numberOfMines
    }
    
    func getX() -> Int {
        return x
    }
    
    func getY() -> Int {
        return y
    }
    
    func executeFunctions() {
        createPlayground()
    }
    
    func createPlayground() {
        for _ in 0..<y {
            var row: [Field] = []
            for _ in 0..<x {
                row.append(Field(isOpen: false, isMine: false, numberOfMines: 0, numberOfMinesNearby: 0))
            }
            playgroundArray.append(row)
        }
        settingRandomMines()
    }
    
    func settingRandomMines() {
        for _ in 0..<getNumberOfMines() {
            let x = Int.random(in: 0..<getX())
            let y = Int.random(in: 0..<getY())
            playgroundArray[x][y].setIsMine(isMine: true)
            generateNumberOfMinesNearby(givenX: x, givenY: y)
        }
    }
    
    func leftClick(givenX: Int, givenY: Int) {
        playgroundArray[givenX][givenY].setIsOpen(isOpen: true)
        if playgroundArray[givenX][givenY].getIsOpen() {
            
            if playgroundArray[givenX][givenY].getIsMine() {
                return
            }
            
            if playgroundArray[givenX][givenY].getNumberOfMinesNearby() != 0 {
                return
            }
            
            for x in -1...1 {
                for y in -1...1 {
                    let newX: Int = x + givenX
                    let newY: Int = y + givenY
                    if newX < getX() && newX >= 0 && newY < getY() && newY >= 0 && !playgroundArray[newX][newY].getIsOpen() {
                        leftClick(givenX: newX, givenY: newY)
                    }
                }
            }
        }
    }
    
    func generateNumberOfMinesNearby(givenX: Int, givenY: Int) {
        for x in -1...1 {
            for y in -1...1 {
                let newX: Int = x + givenX
                let newY: Int = y + givenY
                if newX < getX() && newX >= 0 && newY < getY() && newY >= 0 {
                    playgroundArray[newX][newY].setNumberOfMinesNearby()
                }
                
            }
        }
    }
}
