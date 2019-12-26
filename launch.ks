// launch
clearscreen.

lock throttle to 1.0.
stage.
until ship:altitude > 2000 {
  print ship:velocity:surface.
  wait 0.5.
}
print "exceed 2000 meters".
