# rsearch: a vector model information retrieval implemented in Ruby
# Author: David Lojudice Sobrinho
# 22/11/2008
# <dalssoft@gmail.com>.
#
# info:
#     http://www.ruby-doc.org/docs/ProgrammingRuby/
#     http://en.wikipedia.org/wiki/Vector_space_model
#     http://www.hray.com/5264/math.htm


class Indexer

  def initialize(index)
    @index = index
    
    @stopwords = ["and", "is", "or", "as"]
  
  end

  def add(doc)
    
    @index.documents[doc.name] = doc if @index.documents[doc.name].nil?
    
    # extract the terms from the document
    doc.process(@stopwords)
        
    doc.terms.each_value do |t|  
    
      term = t.term
      
      indexItem = @index.invertedIndex[term]
      
      @index.invertedIndex[term] = indexItem = [0, Array.new] if indexItem.nil?
      
      # IDF
      #indexItem[0] = idf = 0
      
      # Add doc with this term to the index and its term weight (initially 0)
      indexItem[1] << [doc, 0]
      
    end
    
    num_docs = @index.documents.length 
    @index.invertedIndex.each do |term, indexItem|
      
      #ni = ni is # of documents in which the search term of interest appears
      ni = indexItem[1].length 
      
      #calc idf (Inverse document frequency) for each term
      idf = Math.log(num_docs/Float(ni))
      indexItem[0] = idf
      
      #AND calc weight for a term in the document.
      docs = indexItem[1]
      docs.each do |doc|
        nf = doc[0].terms[term].normalized_freq
        doc[1] = nf * idf
      end
      
    end
    
  end

end



