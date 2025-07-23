#!/bin/bash

# FitTrack Pro Test Runner Script

echo "🧪 FitTrack Pro Test Suite"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

# Function to run tests with error handling
run_test() {
    echo -e "${YELLOW}Running: $1${NC}"
    if eval $2; then
        print_status 0 "$1 passed"
        return 0
    else
        print_status 1 "$1 failed"
        return 1
    fi
}

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run different test categories
echo ""
echo "🔧 Running Unit Tests..."
run_test "Workout Entity Tests" "flutter test test/features/workout/domain/entities/ --reporter=compact"

echo ""
echo "🎨 Running Widget Tests..."
run_test "Custom Progress Ring Tests" "flutter test test/shared/widgets/custom_progress_ring_test.dart --reporter=compact"

echo ""
echo "📱 Running Main App Tests..."
run_test "Main Widget Tests" "flutter test test/widget_test.dart --reporter=compact"

echo ""
echo "🔍 Running All Available Tests..."
run_test "All Tests" "flutter test --reporter=compact"

echo ""
echo "📊 Test Summary Complete!"
echo "=========================="