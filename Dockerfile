FROM archlinux

RUN pacman -Sy --noconfirm gcc nim

WORKDIR /

COPY src/lib/ /lib
COPY src/snake.nim /snake.nim

RUN nim --hints:off -d:danger --app:console c -o:/snake /snake.nim

CMD ["/snake"]