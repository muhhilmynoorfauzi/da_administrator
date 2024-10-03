# Gunakan Flutter image dengan versi terbaru yang mendukung Dart 3.4.0
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build
# FROM google/flutter AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Jalankan flutter pub get
RUN flutter pub get

# Copy source code
COPY . .

# Build Flutter web app
RUN flutter build web --release --web-renderer html

# Gunakan Nginx sebagai web server
FROM nginx:stable-alpine

# Copy hasil build ke direktori Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Jalankan Nginx
CMD ["nginx", "-g", "daemon off;"]
