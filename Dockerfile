FROM golang:1.20-alpine as builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/app -v ./cmd/app

###

FROM alpine

WORKDIR /

COPY --from=builder /bin/app ./
COPY --from=builder /src/config.yaml ./
COPY --from=builder /src/certs ./certs

EXPOSE 8080

ENTRYPOINT ["/app"]
