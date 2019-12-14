#!/usr/bin/awk -f

BEGIN {
  sum = 0
}

{
  fuel = int($1 / 3) - 2
  sum += fuel
}

END {
  print "Total fuel required: " sum
}
