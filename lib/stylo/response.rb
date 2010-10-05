module Stylo
  class Response
    def initialize(path)
      @headers = {}
      @path = path
    end

    attr_reader :body, :headers, :path

    def has_content?
      !body.nil?
    end

    def set_body(content, content_type)
      @body = content

      set_header 'Content-Length', content.length.to_s
      set_header "Content-Type", case content_type
                                   when :css
                                     'text/css'
                                   when :javascript
                                     'text/javascript'
                                   else
                                     raise "Unknown content type #{content_type}"
                                 end
    end

    def set_header(name, value)
      @headers[name] = value
    end

    def build
      [200, headers, body]
    end
  end

end