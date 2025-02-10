# First stage: Build the application
FROM golang:1.22.12-alpine

WORKDIR /app
ENV GO111MODULE=auto

# ARG directive for the secret in the first image
ARG SECRET_KEY

# Install dependencies (git in this case)
RUN apk add --no-cache git

# Create a go.mod file for Go module
RUN go mod init gocalc

# Copy the main.go file into the container
COPY main.go .

# Install dependencies (go modules)
RUN go mod tidy
RUN go mod download

# Build the Go application
RUN go build -o app

# Second stage: The final image with the application
FROM alpine:3.10.3

WORKDIR /root/

# Copy the built application from the first stage (using index 0)
COPY --from=0 /app/app .

# Write the value of SECRET_KEY to a file in the final image
RUN echo $SECRET_KEY > /root/secret_key.txt

# Set the default command to run the application
CMD ["./app"]