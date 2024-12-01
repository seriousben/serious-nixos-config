stty -echoctl

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
  if test "$stop" -gt 0 -o "$total" -ge "$max"
    break
  end
end

print_results
