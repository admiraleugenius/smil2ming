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

# synchronization

#parallel
root.elements[2].elements.each("//par") do |par|
	puts "kuku"
	if par.elements["par"].nil? & par.elements["seq"].nil? then
		@media= addMediaOfElement(par)
		@media.each do |s|
		@m.add(s)
		end

	else
		puts "medien müssen synchronisiert werden"
	end
end

#sequential

root.elements[2].elements.each("*/seq/") do
end



def addMediaOfElement(element)

	@movieClips=Array.new	
	element.elements.each do |e|	
		@movieClip = SWFMovieClip.new
		@beginOffset = (element.attributes["begin"].to_i)*20
		@duration = (element.attributes["dur"].to_i)*20
		(0...(@beginOffset)).each {@movieClip.next_frame}
	
		@i=@movieClip.add(SWFBitmap.new(element.attributes["src"]))
	
		if element.attributes["left"].nil? then
			@left=0
		else
			@left=element.attributes["left"].to_f
		end
	
		if element.attributes["top"].nil? then
			@top=0
		else
			@top=element.attributes["top"].to_f
		end
	
		@i.move_to(@left,@top)
		
		((@beginOffset+1)...(@beginOffset+@duration)).each {@movieClip.next_frame}
	
		@i.remove()
		@movieClip.add(SWFAction.new('this.stop();'))
		@movieClip.next_frame
		@movieClips.push(@movieClip)
		return @movieClips
	end
end

@m.save("smil2mingTest.swf")




