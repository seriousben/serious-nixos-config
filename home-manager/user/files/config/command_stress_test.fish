stty -echoctl

if contains -- --help $argv; or contains -- -h $argv
  echo "command_stress_test - Run a command repeatedly for stress testing"
  echo ""
  echo "USAGE:"
  echo "  command_stress_test [COMMAND] [ARGS...]"
  echo ""
  echo "CONFIGURATION:"
  echo "  Use environment variables to configure behavior:"
  echo ""
  echo "  TEST_MAX=N         Maximum number of iterations (default: 50)"
  echo "                     Set to 0 for unlimited runs"
  echo ""
  echo "  TEST_TIMEOUT=TIME  Timeout for each command (default: 1m)"
  echo "                     Format: 10s, 1m, 5m, etc."
  echo ""
  echo "  TEST_FAIL_FAST=BOOL  Stop on first failure (default: false)"
  echo "                       Set to 'true' to stop at first error"
  echo ""
  echo "EXAMPLES:"
  echo "  # Run command 100 times with 30s timeout"
  echo "  TEST_MAX=100 TEST_TIMEOUT=30s command_stress_test curl https://api.example.com"
  echo ""
  echo "  # Run until failure (unlimited iterations, fail fast)"
  echo "  TEST_MAX=0 TEST_FAIL_FAST=true command_stress_test ./flaky-test.sh"
  echo ""
  echo "  # Run with defaults (50 iterations, 1m timeout)"
  echo "  command_stress_test npm test"
  echo ""
  echo "INTERRUPTING:"
  echo "  Press Ctrl+C once to stop gracefully after current command"
  echo "  Press Ctrl+C 5 times to force exit immediately"
  exit 0
end

set -q TEST_MAX; and set -g max $TEST_MAX; or set -g max 50
set -q TEST_TIMEOUT; and set -g timeout_val $TEST_TIMEOUT; or set -g timeout_val 1m
set -q TEST_FAIL_FAST; and set -g fail_fast $TEST_FAIL_FAST; or set -g fail_fast false

set -g stop 0
set -g total 0
set -g success 0
set -g start_time (date +"%s")
set -g command_status 0

function print_results
  echo "==========================="
  echo "Success Rate = $(math "$success / $total * 100")%"
  echo "==========================="
  echo "Failures     = $(math $total - $success)"
  echo "Total        = $total"
  echo "Elapsed      = $(math (date +"%s") - $start_time)s"
end

function stop_signgal --on-signal SIGINT
  if [ $stop -gt 4 ]
    print_results
    exit 1
  end
  set stop (math "$stop + 1")
end

while true
  timeout --preserve-status $timeout_val $argv &
  function command_exit --on-process-exit $last_pid
    set command_status $argv[3]
  end
  wait
  set total_duration (math "$total_duration + $CMD_DURATION")
  set total (math "$total + 1")
  if [ $command_status -eq 0 ]
    set success (math "$success + 1")
  else
    if [ "$fail_fast" = "true" ]
      echo "Failure (stopping on first failure FAIL_FAST=true)"
      break
    end
  end
  if test "$stop" -gt 0
    break
  end
  if test "$max" -gt 0 -a "$total" -ge "$max"
    break
  end
end

print_results
