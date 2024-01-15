FROM debian:latest as build

RUN apt update && apt install build-essential -y

WORKDIR /app

COPY . .

RUN make install

FROM gcr.io/distroless/base-debian12

COPY --from=build /usr/sbin/mbpfan /usr/sbin/mbpfan

COPY --from=build /etc/mbpfan.conf /etc/mbpfan.conf

CMD ["/usr/sbin/mbpfan", "-f"]
