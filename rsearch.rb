# rsearch: a vector model information retrieval implemented in Ruby
# Author: David Lojudice Sobrinho
# 22/11/2008
# <dalssoft@gmail.com>.
#
# info:
#     http://www.ruby-doc.org/docs/ProgrammingRuby/
#     http://en.wikipedia.org/wiki/Vector_space_model
#     http://www.hray.com/5264/math.htm


#
# Main Program
#


require './document'
require './index'
require './indexer'
require './searcher'


# ask the dir with the files to be indexed
print "Txt file folder [./txt/]:"
$stdout.flush
txt_dir = gets
txt_dir = ".//txt//" if txt_dir.strip.empty?


# index: scan all the TXT files and index it

index = Index.new
indexer = Indexer.new(index)

print "\n"

dirp = Dir.open(txt_dir)
for f in dirp
  case f
    when /\.txt/

      doc = DocumentFile.new(txt_dir + f)
      print "Processing [#{doc.name}] file.", "\n"
      
      indexer.add(doc)
      
    end
end
dirp.close

#index.each {|x| p x}
print "Index completed! Documents: #{index.total_number_of_documents} Terms: #{index.total_number_of_terms}", "\n"

# search
keywords = [" "]
searcher = Searcher.new(index)
  
until keywords.empty?
  print "\n", "Search:"
  $stdout.flush
  keywords = gets.scan(/\w+/)

  result = searcher.search(keywords)
  
  #sort by rank
  result = result.sort {|a, b| b[1][1] <=> a[1][1]}
  
  result.each do |key, docinfo| 
    doc = docinfo[0]
    rank = docinfo[1]
    
    print "file: #{doc.name}  [rank: #{rank}] ", "\n"
  
  end
  
end


