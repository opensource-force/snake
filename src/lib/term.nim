import termios

proc echoOff*() =
  var term: Termios
  if termios.tcgetattr(0, addr term) != -1:
    term.c_lflag = term.c_lflag and not (ECHO or ECHOE or ECHOK or ECHONL)
    discard termios.tcsetattr(0, TCSANOW, addr term)

proc echoOn*() =
  var term: Termios
  if termios.tcgetattr(0, addr term) != -1:
    term.c_lflag = term.c_lflag or (ECHO or ECHOE or ECHOK or ECHONL)
    discard termios.tcsetattr(0, TCSANOW, addr term)

proc altBuffer*() = stdout.write("\e[?1049h")

proc mainBuffer*() = stdout.write("\e[?1049l")

proc readKey*(): string =
  var term: Termios
  discard tcgetattr(0, addr term)

  var newTerm = term
  newTerm.c_lflag = newTerm.c_lflag and not(uint32(ICANON) or uint32(ECHO))
  discard tcsetattr(0, TCSAFLUSH, addr newTerm)

  while true:
    let ch = readChar(stdin)
    case ch
    of '\e':
      var suffix: string = ""
      for _ in 1..2:
        suffix.add(readChar(stdin))
      discard tcsetattr(0, TCSANOW, addr term)
      return suffix
    else:
      discard tcsetattr(0, TCSANOW, addr term)
      return ch & ""