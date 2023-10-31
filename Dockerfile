FROM archlinux

RUN pacman -Sy --noconfirm gcc nim

WORKDIR /

RUN nim --hints:off -d:danger --app:console c -o:/snake /snake.nim

CMD ["/snake"]