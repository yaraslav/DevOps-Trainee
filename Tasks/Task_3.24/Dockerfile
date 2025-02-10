# first stage
FROM golang:1.22.12-alpine AS build

WORKDIR /app
ENV GO111MODULE=auto

# set git and deps
RUN apk add --no-cache git

# create go.mod
RUN go mod init gocalc

# Копируем main.go
COPY main.go .

# get deps
RUN go mod tidy
RUN go mod download

# app build
RUN go build -o app

# runtime build
FROM alpine:3.10.3
WORKDIR /root/
COPY --from=build /app/app .

CMD ["./app"]