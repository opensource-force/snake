import os, terminal, strutils, random, term

let (cols, rows) = terminalSize()

var
  snakeX: int = cols div 2
  snakeY: int = rows div 2
  snakeBody: seq[(int, int)] = @[]
  snakeLength: int = 3
  direction: char = 'U'
  foodX, foodY: int
  delay: int = 700

proc initTerm() =
  altBuffer()
  hideCursor()
  setMode(noecho)

proc gameOver(n: int) =
  for _ in 0..<n:
    setCursorPos(cols div 2 - 4, rows div 2)
    echoRandColor("GAME OVER")
    stdout.flushFile
    sleep(150)

  mainBuffer()
  showCursor()
  setMode(cooked)
  quit()

proc drawSnake() =
  setCursorPos(snakeX, snakeY)
  stdout.styledWrite(bgGreen, " ")

proc drawFood() =
  setCursorPos(foodX, foodY)
  stdout.write(randColorSeq(bg), " \e[m")

proc moveSnake(x, y: int, snakeX, snakeY: var int) =
  if x == -1:
    if direction == 'R': snakeX += 1
    else: direction = 'L'; snakeX -= 1
  elif y == 1:
    if direction == 'U': snakeY -= 1
    else: direction = 'D'; snakeY += 1
  elif y == -1:
    if direction == 'D': snakeY += 1
    else: direction = 'U'; snakeY -= 1
  elif x == 1:
    if direction == 'L': snakeX -= 1
    else: direction = 'R'; snakeX += 1

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
    gameOver(10)

proc wallCollision() =
  if snakeX == -1 or snakeX == cols or snakeY == -1 or snakeY == rows:
    gameOver(10)

proc keyMap(): bool =
  case getch().toUpperAscii
  of 'Q': gameOver(6)
  of 'H', 'A': moveSnake(-1, 0, snakeX, snakeY)
  of 'J', 'S': moveSnake(0, 1, snakeX, snakeY)
  of 'K', 'W': moveSnake(0, -1, snakeX, snakeY)
  of 'L', 'D': moveSnake(1, 0, snakeX, snakeY)
  of '\e':
    case getch() & getch()
    of "[D": moveSnake(-1, 0, snakeX, snakeY)
    of "[B": moveSnake(0, 1, snakeX, snakeY)
    of "[A": moveSnake(0, -1, snakeX, snakeY)
    of "[C": moveSnake(1, 0, snakeX, snakeY)
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