# Stage 1: Build the Go application
FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o main .

# Stage 2: Create a small image with the compiled Go binary
FROM alpine:latest

# Install bash and ca-certificates
RUN apk --no-cache add bash ca-certificates

WORKDIR /root/

COPY --from=builder /app/main .
COPY --from=builder /app/.env .env


# Expose port 3000 to the outside world
EXPOSE 3000

# Command to run the executable
CMD ["./main"]
