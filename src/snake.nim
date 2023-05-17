import os, terminal, strutils, random, lib/term

let (cols, rows) = terminalSize()

var
  snakeLength: int = 3
  snakeX: int = cols div 2
  snakeY: int = rows div 2
  snakeBody: seq[(int, int)] = @[]
  direction: char = 'U'
  foodX, foodY: int
  delay: int = 500

proc initTerm() =
  altBuffer()
  hideCursor()
  echoOff()

proc gameOver(n: int) =
  for _ in 0..<n:
    for i in ["\e[37m", "\e[31m"]:
      setCursorPos(cols div 2 - 4, rows div 2)
      stdout.write(i, "GAME OVER\e[m")
      stdout.flushFile
      sleep(150)

  mainBuffer()
  showCursor()
  echoOn()
  quit()

proc drawSnake() =
  setCursorPos(snakeX, snakeY)
  stdout.styledWrite(bgGreen, " ")

proc drawFood() =
  setCursorPos(foodX, foodY)
  stdout.styledWrite(bgRed, " ")

proc placeFood() =
  while true:
    foodX = rand(cols - 2) + 1
    foodY = rand(rows - 2) + 1
    if (foodX, foodY) notin snakeBody and foodX != snakeX and foodY != snakeY:
      break
  drawFood()

proc consumeFood() =
  if snakeX == foodX and snakeY == foodY:
    snakeLength += 1
    placeFood()
    delay -= 25

proc selfCollision() =
  if (snakeX, snakeY) in snakeBody[0..<len(snakeBody)-1]:
    gameOver(4)

proc wallCollision() =
  if snakeX == -1 or snakeX == cols or snakeY == -1 or snakeY == rows:
    gameOver(4)

proc keyMap(): bool =
  case toUpper(readKey())
  of "H", "A", "[D":
    if direction == 'R':
      return
    snakeX -= 1
    direction = 'L'
  of "J", "S", "[B":
    if direction == 'U':
      return
    snakeY += 1
    direction = 'D'
  of "K", "W", "[A":
    if direction == 'D':
      return
    snakeY -= 1
    direction = 'U'
  of "L", "D", "[C":
    if direction == 'L':
      return
    snakeX += 1
    direction = 'R'
  of "Q": gameOver(2)
  else: return false
  return true

randomize()
initTerm()
placeFood()

while true:
  if not keyMap(): continue

  drawSnake()

  selfCollision()
  wallCollision()
  consumeFood()

  snakeBody.add((snakeX, snakeY))
  if len(snakeBody) > snakeLength:
    for i in 0..<len(snakeBody) - snakeLength:
      let (eraseX, eraseY) = snakeBody[i]
      setCursorPos(eraseX, eraseY)
      stdout.styledWrite(bgDefault, " ")
    snakeBody = snakeBody[len(snakeBody)-snakeLength..<len(snakeBody)]

  sleep(delay)