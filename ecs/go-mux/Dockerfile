# Stage 1: Build the binary
FROM golang:1.24-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files first to leverage Docker cache
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
# CGO_ENABLED=0 creates a statically linked binary (ideal for scratch/alpine)
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Stage 2: Create a small runtime image
FROM alpine:latest

# Add certificates for applications that make HTTPS requests
RUN apk --no-cache add ca-certificates
RUN apk add --no-cache shadow

ARG USERNAME=go-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME 
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

WORKDIR /app

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/main .

# 
RUN chown -R $USER_UID:$USER_GID /app/

#
USER $USERNAME

# Expose the port your app runs on
EXPOSE 8080

# Command to run the executable
CMD ["./main"]
