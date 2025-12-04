FROM cirrusci/flutter:stable AS build
WORKDIR /app

# Copy project files
COPY . .

# Ensure dependencies are fetched (avoid switching channels inside container)
RUN flutter pub get

# Build the web release
RUN flutter build web --release

FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built web app from the builder stage
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
