# Build the manager binary
FROM golang:1.17 as builder

# Copy in the go src
WORKDIR /go/src/github.com/slntopp/operator
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/slntopp/operator/cmd/manager

# Copy the controller-manager into a thin image
FROM scratch
WORKDIR /
COPY --from=builder /go/src/github.com/slntopp/operator/manager .
ENTRYPOINT ["/manager"]
