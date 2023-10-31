import sdl2

const
  WIN_WIDTH = 640
  WIN_HEIGHT = 480

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr
  evt = sdl2.defaultEvent
  runGame = true
  rect: Rect
  #timestamp: uint32
  x = cint(WIN_WIDTH div 2)
  y = cint(WIN_HEIGHT div 2)
  snake = @[(x, y), (x - 10, y), (x - 10, y + 10)]

window = createWindow(
  "Snake",
  100, 100, WIN_WIDTH, WIN_HEIGHT,
  SDL_WINDOW_SHOWN
)
render = createRenderer(
  window, -1,
  Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
)

while runGame:
  #[ implement delay
  let deltaTime = sdl2.getTicks() - timestamp
  timestamp = sdl2.getTicks()
  ]#

  while pollEvent(evt):
    case evt.kind
    of QuitEvent:
      runGame = false
    of KeyDown:
      let scancode = evt.key.keysym.scancode
      
      case scancode
      of SDL_SCANCODE_UP:
        dec(y, 10)
        add(snake, (x, y))
      of SDL_SCANCODE_DOWN:
        inc(y, 10)
        add(snake, (x, y))
      of SDL_SCANCODE_LEFT:
        dec(x, 10)
        add(snake, (x, y))
      of SDL_SCANCODE_RIGHT:
        inc(x, 10)
        add(snake, (x, y))
      else: discard
    else: discard

    if len(snake) > 3:
      snake = snake[1..^1]

  render.setDrawColor(0, 0, 0, 255)
  render.clear
  render.setDrawColor(0, 255, 0, 255)
  
  for (snakeX, snakeY) in snake:
    rect.x = snakeX
    rect.y = snakeY
    rect.w = 25
    rect.h = 25

    render.fillRect(rect)
  
  render.present
