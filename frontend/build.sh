#!/bin/bash
echo "Installing dependencies and running Flutter build"

# Exit on any error
set -e

echo "Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Verifying Flutter version..."
flutter --version

echo "Building Flutter web application..."
flutter build web --release

echo "Build successful!"
