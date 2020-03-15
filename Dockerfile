FROM swift:5.1.1 as builder
WORKDIR /root
COPY . .
RUN swift build -c release
RUN swift test -v

FROM swift:slim
WORKDIR /root
COPY --from=builder /root .
CMD [".build/x86_64-unknown-linux/release/docker-test"]

