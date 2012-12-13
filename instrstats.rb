#!/usr/bin/ruby

def slurpFile file
   print "Reading file %s\n" % file
   f = File.new file
   l = f.readlines
   f.close
   print "Done reading file\n"
   return l
end

def cleanLines lines
   print "Cleaning lines...\n"
   newlines = []
   lines.each {|l| if (l =~ /^  /) then newlines.push l end}
   newlines = newlines.map {|l| l.split[1]}
   newnewlines = []
   newlines.each {|l| if (l =~ /^[a-z]*$/) then newnewlines.push l end}
   print "Done cleaning lines\n"
   return newnewlines
end

def incElement table, elt
   if table[elt] then
      table[elt] += 1
   else
      table[elt] = 1
   end
end

def disasm filename
   newfile = File.basename( filename ) + '.S'
   system( 'objdump -d --no-show-raw-insn %s > %s' % [filename, newfile] )
   print "Objdump done\n"
   lines = cleanLines( slurpFile newfile )
   File.delete newfile
   return lines
end

def countInstructions table, filename
   print "Disassembling " + filename + "\n"
   instrs = disasm filename
   print "Done disassembling, starting counting...\n"
   instrs.each { |x| incElement table, x }
   print "Done counting.\n"
end
   
def printInstrs table
   arr = table.to_a
   arr.each {|x| print "%s\n" % x}
   arr.sort! {|x,y| x[1] - y[1]}
   arr.reverse!
   arr.each {|val| print "%s %s\n" % val}
end

def main
   table = {}
   #print ARGV + "\n"
   ARGV.each {|file| countInstructions table, file}
   printInstrs table
end

main()
