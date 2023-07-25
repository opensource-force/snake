import terminal, term, os, strutils, random

let (cols, rows) = terminalSize()

var
  dirX: int = 1
  dirY: int
  snakeX: int = cols div 2
  snakeY: int = rows div 2
  snakeCells: seq[(int, int)] = @[]
  snakeLen: int = 3
  foodX, foodY: int

proc initTerm() =
  altBuffer()
  hideCursor()

proc gameOver(i: int) =
  for _ in 0..<i:
    setCursorPos(cols div 2 - 4, rows div 2)
    echoRandColor("Game Over")
    flushFile(stdout)
    sleep(150)

  mainBuffer()
  showCursor()
  quit()

proc drawFood() =
  foodX = rand(cols)
  foodY = rand(rows)

  setCursorPos(foodX, foodY)
  stdout.styledWrite(bgRed, " ")

initTerm()
randomize()
drawFood()

while true:
  case getch().toLowerAscii
  of 'q': gameOver(3)
  of 'h', 'a':
    if dirX != 1:
      dirX = -1; dirY = 0
  of 'j', 's':
    if dirY != -1:
      dirX = 0; dirY = 1
  of 'k', 'w':
    if dirY != 1:
      dirX = 0; dirY = -1
  of 'l', 'd':
    if dirX != -1:
      dirX = 1; dirY = 0
  else: continue

  snakeX += dirX; snakeY += dirY

  setCursorPos(snakeX, snakeY)
  stdout.styledWrite(bgGreen, " ")

  snakeCells.add((snakeX, snakeY))
  if len(snakeCells) > snakeLen:
    for i in 0..<len(snakeCells) - snakeLen:
      let (eraseX, eraseY) = snakeCells[i]

      setCursorPos(eraseX, eraseY)
      stdout.styledWrite(bgDefault, " ")

    snakeCells = snakeCells[len(snakeCells)-snakeLen..<len(snakeCells)]

  if (snakeX, snakeY) in snakeCells[0..<len(snakeCells)-1]:
    gameOver(4)

  if snakeX == -1 or snakeX == cols or snakeY == -1 or snakeY == rows:
    gameOver(4)

  if (snakeX, snakeY) == (foodX, foodY):
    drawFood()
    snakeLen += 1