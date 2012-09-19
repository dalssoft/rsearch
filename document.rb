#encoding: UTF-8
# rsearch: a vector model information retrieval implemented in Ruby
# Author: David Lojudice Sobrinho
# 22/11/2008
# <dalssoft@gmail.com>.
#
# info:
#     http://www.ruby-doc.org/docs/ProgrammingRuby/
#     http://en.wikipedia.org/wiki/Vector_space_model
#     http://www.hray.com/5264/math.htm

class Document
  
  attr_reader :name, :text, :terms, :most_common_term, :most_common_term_freq
    
  def initialize()
    
    @terms = Hash.new()
    @most_common_term = ""
    @most_common_term_freq = 0
    
  end
  
  def process(stopwords)
  
    terms = text.scan(/\w+/)
    
    normalizedterms = Array.new
    
    terms.each {|term| normalizedterms << term.downcase}
    
    normalizedterms = normalizedterms - stopwords
    
    normalizedterms.each {|normalizedterm|  
    
      @terms[normalizedterm] = DocumentTerm.new unless @terms.has_key?(normalizedterm)
    
      doc_term = @terms[normalizedterm]
      
      doc_term.term = normalizedterm
      doc_term.term_freq += 1
      
      if doc_term.term_freq > @most_common_term_freq
        @most_common_term = normalizedterm 
        @most_common_term_freq = doc_term.term_freq 
      end
      
    }
    
    #normalize frequency
    @terms.each_value do |term|
      term.normalized_freq = term.term_freq / Float(@most_common_term_freq)
    end
  
  end
  
end

class DocumentTerm

  attr_reader :term, :term_freq, :normalized_freq, :term_weight
  attr_writer :term, :term_freq, :normalized_freq, :term_weight

  def initialize()
    
    @term_freq = 0
    @normalized_freq = 0
    @term_weight = 0
    
  end
end


class DocumentFile < Document

  def initialize(filename)
    super()
    @filename = filename
  end
  
  def filename
    @filename
  end 

  def readtext()
    text = ""
    File.open(@filename, 'rb') do |f1|  
      while line = f1.gets  
        text = text + " " + line.strip
      end  
    end
    return text
  end

  def name 
    filename
  end
  
  def text
    readtext()
  end
end 


