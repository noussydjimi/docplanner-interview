FROM golang:1.20 as builder
WORKDIR /app
COPY ./main.go .
RUN touch file.p12
RUN CGO_ENABLED=0 GOOS=linux go build main.go



FROM scratch
EXPOSE 80
WORKDIR /app
COPY --from=builder /app/ .

CMD ["/app/main"]

