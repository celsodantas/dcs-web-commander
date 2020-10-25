#!/usr/bin/env lua5.2

require 'io'

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

print "starting consumer..."

file = io.open("data.comms", "r")
command = ""
timeout = 0

while (timeout < 10) do
  command = file:read()

  print("reading...")

  if (command == nil) then
    sleep(1)
    timeout = timeout + 1
  else
    timeout = 0
    print("COMMAND:" .. command)
  end
end

print "ending consumer. Goodbye."
