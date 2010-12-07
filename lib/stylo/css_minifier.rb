module Stylo
  class CssMinifier
    def self.minify(original)
      result = original.gsub /\s+/, ' '
      result = result.gsub /\/\*.*?\*\//s, ''
      result = result.gsub '; ', ';'
      result = result.gsub ': ', ':'
      result = result.gsub ' {', '{'
      result = result.gsub '{ ', '{'
      result = result.gsub ', ', ','
      result = result.gsub '} ', '}'
      result = result.gsub ';}', '}'
      result.strip
    end
  end
end
