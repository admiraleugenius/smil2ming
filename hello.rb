#!/usr/bin/ruby
# text.rb
# example for Ming/Ruby
# http://blue.ribbon.to/~harpy/ming/example/hello/show.php?hello.php

require 'ming/ming'
include Ming

use_SWF_version(7)

b = SWFBitmap.new("picture.jpg")

c = SWFShape.new

c.set_left_fill(c.add_fill(b, SWFFill::TILED_BITMAP))

c.move_pen_to(10,10)

c.set_line(1,0,0,0)

c.draw_line(140, 0)
c.draw_line(0, 140)
c.draw_line(-140, 0)
c.draw_line(0, -140)

c.move_pen_to(200,200)
c.draw_circle(50)

s = SWFSound.new("look.mp3")


m = SWFMovie.new
m.set_dimension(600,400)
m.set_background(0xcc, 0xcc, 0xcc)

m.add(c)

m.save("fill.swf")





