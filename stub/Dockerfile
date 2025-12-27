FROM golang:1.22 AS builder

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app ./main.go

FROM alpine:3.19

WORKDIR /root/
COPY --from=builder /app/app .

RUN apk add --no-cache ca-certificates

ENV DOMAINS=""
CMD ["./app"]