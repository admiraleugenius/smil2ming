#!/usr/bin/ruby

require 'ming/ming'
include Ming

require "rexml/document"
include REXML


# set scale and version of Movie

set_scale(20.0000000)
use_SWF_version(8)



xmlFile = File.new("test.smil")
doc = Document.new(xmlFile)
root=doc.root

# testen ob file ein SMIL-Dokument ist

if doc.elements["smil"].nil? then
	abort("file is not a SMIL document")
end


# init Movie

@m = SWFMovie.new
@m.set_rate(20.0)


# root-layout

@rootlayout= root.elements[1].elements["layout"].elements["root-layout"]
@m.set_dimension(@rootlayout.attributes["width"].to_f,@rootlayout.attributes["height"].to_f)


# background-color

@bgC=@rootlayout.attributes["background-color"]
@bgR = @bgC.slice!(0..1).hex
@bgG = @bgC.slice!(0..1).hex
@bgB =  @bgC.slice!(0..1).hex
@m.set_background(@bgR, @bgG, @bgB)


@images=Array.new
root.elements[2].elements.each("//img") do |img|
	
	@imageClip = SWFMovieClip.new
	(0...(((img.attributes["begin"].to_i)-1)*20)).each {@imageClip.next_frame}
	
	@i=@imageClip.add(SWFBitmap.new(img.attributes["src"]))
	
	(((img.attributes["begin"].to_i)*20+1)...(((img.attributes["begin"].to_i)*20)+(img.attributes["dur"].to_i)*20)). each {@imageClip.next_frame}
	
	@i.remove()
	@imageClip.add(SWFAction.new('this.stop();'))
	@imageClip.next_frame
	@images.push(@imageClip)
end

@images.each do |s|
	@m.add(s)
	@m.next_frame
end


@m.save("smil2mingTest.swf")




