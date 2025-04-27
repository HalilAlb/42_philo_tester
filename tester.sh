#!/bin/bash

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Your program
PHILO=./philo

# Test configs: (philo_num, time_to_die, time_to_eat, time_to_sleep [, meals])
TESTS=(
  "5 800 200 200"
  "5 800 200 200 7"
  "2 310 200 100"
  "3 310 200 100"
  "5 800 200 200 7"
  "100 800 200 200"
  "200 610 200 100"
  "199 610 200 100"
)

# Function to run a normal test
run_normal_test() {
    args=$1
    echo -e "Running: ${GREEN}$PHILO $args${NC}"
    timeout 10s $PHILO $args > /tmp/philo_test_output.txt
    if grep -q "died" /tmp/philo_test_output.txt; then
        echo -e "${RED}[FAIL]${NC} Philosopher died ❌"
    else
        echo -e "${GREEN}[PASS]${NC} No one died ✅"
    fi
    echo "----------------------------"
}

# Function to run valgrind memory leak test
run_valgrind_leak() {
    args=$(run_random_test)
    echo -e "Valgrind Leak Test: ${YELLOW}$PHILO $args${NC}"
    valgrind --leak-check=full --error-exitcode=42 timeout 5s $PHILO $args > /tmp/philo_valgrind_output.txt 2>&1
    if [ $? -eq 42 ]; then
        echo -e "${RED}[LEAK]${NC} Memory Leak detected ❌"
        grep "definitely lost" /tmp/philo_valgrind_output.txt
    else
        echo -e "${GREEN}[NO LEAK]${NC} No Memory Leak ✅"
    fi
    echo "----------------------------"
}

# Function to run helgrind race condition test
run_helgrind_test() {
    args=$(run_random_test)
    echo -e "Helgrind Race Test: ${YELLOW}$PHILO $args${NC}"
    timeout 10s valgrind --tool=helgrind --history-level=none --error-exitcode=42 $PHILO $args > /tmp/philo_helgrind_output.txt 2>&1
    if [ $? -eq 42 ]; then
        echo -e "${RED}[RACE CONDITION]${NC} Detected ❌"
        grep "Possible data race" /tmp/philo_helgrind_output.txt
    else
        echo -e "${GREEN}[NO RACE]${NC} No Data Race ✅"
    fi
    echo "----------------------------"
}

# New test: Only Dead Test (to ensure philosophers don't die)
run_only_dead_test() {
    args=$(run_random_test)
    echo -e "Dead Test: ${YELLOW}$PHILO $args${NC}"
    timeout 10s $PHILO $args > /tmp/philo_dead_test_output.txt
    if grep -q "died" /tmp/philo_dead_test_output.txt; then
        echo -e "${RED}[FAIL]${NC} Philosopher died ❌"
    else
        echo -e "${GREEN}[PASS]${NC} No one died ✅"
    fi
    echo "----------------------------"
}

# Function to run all tests for random configurations
run_random_test() {
    philo_num=$((RANDOM % 10 + 2))        # Random philosophers between 2 and 10
    time_to_die=$((RANDOM % 1000 + 100))  # Random time_to_die between 100 and 1100 ms
    time_to_eat=$((RANDOM % 1000 + 100)) # Random time_to_eat between 100 and 1100 ms
    time_to_sleep=$((RANDOM % 1000 + 100)) # Random time_to_sleep between 100 and 1100 ms
    args="$philo_num $time_to_die $time_to_eat $time_to_sleep"
    echo -e "Random Test: ${YELLOW}$PHILO $args${NC}"
    timeout 10s $PHILO $args > /tmp/philo_random_test_output.txt
    if grep -q "died" /tmp/philo_random_test_output.txt; then
        echo -e "${RED}[FAIL]${NC} Philosopher died ❌"
    else
        echo -e "${GREEN}[PASS]${NC} No one died ✅"
    fi
    echo "----------------------------"
}

# Menu to select test mode
echo -e "${YELLOW}Select Test Mode:${NC}"
echo "1) Normal Run"
echo "2) Valgrind Leak Check"
echo "3) Valgrind Helgrind (Race Condition Check)"
echo "4) Dead Test (Check if philosophers die)"
echo "5) Random Test"
read -p "Choice: " choice

# Main loop
for test_case in "${TESTS[@]}"; do
    if [ "$choice" == "1" ]; then
        run_normal_test "$test_case"
    elif [ "$choice" == "2" ]; then
        run_valgrind_leak "$test_case"
    elif [ "$choice" == "3" ]; then
        run_helgrind_test "$test_case"
    elif [ "$choice" == "4" ]; then
        run_only_dead_test "$test_case"
    elif [ "$choice" == "5" ]; then
        run_random_test
    else
        echo "Invalid choice."
        exit 1
    fi
    sleep 1
done

# Clean up
rm -f /tmp/philo_test_output.txt /tmp/philo_valgrind_output.txt /tmp/philo_helgrind_output.txt
echo "Cleaning up temporary files..."
if [ -f /tmp/philo_test_output.txt ]; then
    rm /tmp/philo_test_output.txt
fi
if [ -f /tmp/philo_valgrind_output.txt ]; then
    rm /tmp/philo_valgrind_output.txt
fi
if [ -f /tmp/philo_helgrind_output.txt ]; then
    rm /tmp/philo_helgrind_output.txt
fi
echo -e "${GREEN}Cleanup complete.${NC}"
echo "----------------------------"
echo -e "${YELLOW}All tests completed.${NC}"
echo "----------------------------"
