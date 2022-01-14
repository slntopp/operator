# Build the manager binary
FROM golang:1.17-alpine as builder

RUN apk add upx

# Copy in the go src
WORKDIR /go/src/github.com/slntopp/operator
COPY go.mod go.sum ./
RUN go mod download

# Build
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" ./cmd/manager
RUN upx ./manager

# Copy the controller-manager into a thin image
FROM scratch
WORKDIR /
COPY --from=builder /go/src/github.com/slntopp/operator/manager .

LABEL org.opencontainers.image.source https://github.com/slntopp/operator

ENTRYPOINT ["/manager"]
