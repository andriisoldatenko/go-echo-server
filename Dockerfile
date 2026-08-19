FROM --platform=$BUILDPLATFORM golang:alpine as tel2-build

ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache gcc musl-dev fuse-dev libcap binutils-gold

WORKDIR /app
COPY go.mod ./
COPY main.go .
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /usr/local/bin/echo-server .

FROM alpine
#COPY --from=builder /app/echo-server /echo-server
COPY --from=tel2-build /usr/local/bin/echo-server /usr/local/bin

EXPOSE 8080

ENTRYPOINT ["echo-server"]
CMD []
