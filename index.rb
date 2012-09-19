# rsearch: a vector model information retrieval implemented in Ruby
# Author: David Lojudice Sobrinho
# 22/11/2008
# <dalssoft@gmail.com>.
#
# info:
#     http://www.ruby-doc.org/docs/ProgrammingRuby/
#     http://en.wikipedia.org/wiki/Vector_space_model
#     http://www.hray.com/5264/math.htm

class Index
  
  attr_reader :invertedIndex, :documents
  attr_writer :invertedIndex, :documents
  
  def initialize()
    @invertedIndex = Hash.new
    @documents = Hash.new
  end
   
  
  def total_number_of_terms
    invertedIndex.length
  end
  
  def total_number_of_documents
    documents.length
  end
  

end