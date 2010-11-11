# jsmin.rb
# Author: Mike Wagg
# This work is a reworking of the ruby port of jsmin produced by
# Uladzislau Latynski which itself was a translation of the original
# C version published by Douglas Crockford. Permission is hereby granted to use the Ruby
# version under the same conditions as the jsmin.c on which it is
# based.
#
# /* jsmin.c
#    2003-04-21
#
# Copyright (c) 2002 Douglas Crockford  (www.crockford.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# The Software shall be used for Good, not Evil.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'stringio'

class JSMin
  EOF = -1

  def initialize(original)
    @original = original
  end

  def minify
    @output = ''

    @in = StringIO.new(@original)
    @out = StringIO.new(@output)

    @the_a = ""
    @the_b = ""

    jsmin

    @output
  end

  private

  def is_alpha_numeric(c)
    return false if !c || c == EOF

    ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') ||
            (c >= 'A' && c <= 'Z') || c == '_' || c == '$' ||
            c == '\\' || (c[0].class == String ? c[0].ord : c[0]) > 126)
  end

  # get -- return the next character from stdin. Watch out for lookahead. If
  # the character is a control character, translate it to a space or linefeed.
  def get_next_character()
    c = @in.getc
    return EOF if (!c)
    c = c.chr
    return c if (c >= " " || c == "\n" || c.unpack("c") == EOF)
    return "\n" if (c == "\r")

    " "
  end

  def peek()
    lookahead_char = @in.getc
    @in.ungetc(lookahead_char)
    lookahead_char.chr
  end

  def my_next()
    c = get_next_character
    if (c == "/")
      if (peek == "/")
        while (true)
          c = get_next_character
          if (c <= "\n")
            return c
          end
        end
      end
      if (peek == "*")
        get_next_character
        while (true)
          case get_next_character
            when "*"
              if (peek == "/")
                get_next_character
                return " "
              end
            when EOF
              raise "Unterminated comment"
          end
        end
      end
    end

    c
  end

  def action(a)
    if (a==1)
      @out.write @the_a
    end
    if (a==1 || a==2)
      @the_a = @the_b
      if (@the_a == "\'" || @the_a == "\"")
        while (true)
          @out.write @the_a
          @the_a = get_next_character
          break if (@the_a == @the_b)
          raise "Unterminated string literal" if (@the_a <= "\n")
          if (@the_a == "\\")
            @out.write @the_a
            @the_a = get_next_character
          end
        end
      end
    end
    if (a==1 || a==2 || a==3)
      @the_b = my_next
      if (@the_b == "/" && (@the_a == "(" || @the_a == "," || @the_a == "=" ||
          @the_a == ":" || @the_a == "[" || @the_a == "!" ||
          @the_a == "&" || @the_a == "|" || @the_a == "?" ||
          @the_a == "{" || @the_a == "}" || @the_a == ";" ||
          @the_a == "\n"))
        @out.write @the_a
        @out.write @the_b
        while (true)
          @the_a = get_next_character
          if (@the_a == "/")
            break
          elsif (@the_a == "\\")
            @out.write @the_a
            @the_a = get_next_character
          elsif (@the_a <= "\n")
            raise "Unterminated RegExp Literal"
          end
          @out.write @the_a
        end
        @the_b = my_next
      end
    end
  end

  def jsmin
    @the_a = "\n"
    action(3)
    while (@the_a != EOF)
      case @the_a
        when " "
          if (is_alpha_numeric(@the_b))
            action(1)
          else
            action(2)
          end
        when "\n"
          case (@the_b)
            when "{", "[", "(", "+", "-"
              action(1)
            when " "
              action(3)
            else
              if (is_alpha_numeric(@the_b))
                action(1)
              else
                action(2)
              end
          end
        else
          case (@the_b)
            when " "
              if (is_alpha_numeric(@the_a))
                action(1)
              else
                action(3)
              end
            when "\n"
              case (@the_a)
                when "}", "]", ")", "+", "-", "\"", "\\", "'", '"'
                  action(1)
                else
                  if (is_alpha_numeric(@the_a))
                    action(1)
                  else
                    action(3)
                  end
              end
            else
              action(1)
          end
      end
    end
  end
end