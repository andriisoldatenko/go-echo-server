FROM --platform=$BUILDPLATFORM golang:trixie as tel2-build

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app
COPY go.mod ./
COPY main.go .
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /usr/local/bin/echo-server .

EXPOSE 8080

ENTRYPOINT ["echo-server"]
CMD []
