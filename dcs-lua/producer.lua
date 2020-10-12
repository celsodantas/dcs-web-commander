#!/usr/bin/env lua5.2

require 'io'

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function write(data)
  file = io.open("data.comms", "a")
  file:write(data)
  file:close()
end

print "#####"
print "starting producer..."
print "#####"

-- SETUP
file = io.open("data.comms", "w")
file:write("foor")
file:write("bar")
file:close()
-- END SETUP

sleep(10)

-- count = 0
-- repeat
--   sleep(1)
--   print "producing..."

  write("bobs")
  sleep(2)
  write("nelson")
  sleep(2)
  write("booooo")
  -- count = count + 1
-- until(count >= 3)

print "#####"
print "Goodbye!"
print "#####"
