# Philosopher Simulation Tester

This repository includes a philosopher simulation program along with a script for testing various aspects of the simulation, including memory leaks and race conditions.

## tester.sh

`tester.sh` is a Bash script that automates the testing of the philosopher simulation program. It runs the simulation with randomly generated configurations, ensuring that your program works under a variety of conditions. The script also includes tests for memory leaks and race conditions using Valgrind.

### Features:
- **Randomized Test Parameters**: The script generates random parameters for the number of philosophers, time to die, time to eat, time to sleep, and the number of meals.
- **Normal Test**: Runs the philosopher simulation with random parameters and checks if any philosopher dies.
- **Valgrind Leak Test**: Runs the philosopher simulation with random parameters and checks for memory leaks using Valgrind.
- **Helgrind Race Condition Test**: Runs the philosopher simulation with random parameters and checks for race conditions using Helgrind.

### How to Use:
1. Clone the repository:
   ```bash
   git clone https://github.com/HalilAlb/42_philo_tester.git

Additional Notes:
To run the tester.sh script, you need to be in the directory where philo.c is located. This script is used to verify that your philo program is functioning correctly.
test.sh çalışması için philo dosya içerisinde olması gerekiyor ./tester.sh yaptıgınızda istediğiniz testi deneyebilirsiniz şimdiden kolay gelsin... :)

Make the script executable:
chmod +x tester.sh

./tester.sh
Choose the type of test you would like to run:

Normal Run

Valgrind Leak Check

Valgrind Helgrind (Race Condition Check)

Example Output:
The script will run a set of tests and output results such as:

"No one died ✅"

"Memory Leak detected ❌"

"Race Condition detected ❌"
