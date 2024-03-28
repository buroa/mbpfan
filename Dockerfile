FROM debian:latest as build
WORKDIR /app
COPY ./mbpfan .
COPY ./Makefile .
RUN apt update && \
    apt install build-essential -y && \
    make install

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /usr/sbin/mbpfan /usr/sbin/mbpfan
COPY --from=build /etc/mbpfan.conf /etc/mbpfan.conf
CMD ["/usr/sbin/mbpfan", "-f"]
