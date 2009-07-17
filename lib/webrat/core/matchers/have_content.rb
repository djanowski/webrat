module Webrat
  module Matchers

    class HasContent #:nodoc:
      def initialize(content, scope = nil)
        @content = content
        @scope = scope
      end

      def matches?(stringlike)
        if Webrat.configuration.parse_with_nokogiri?
          @document = Webrat.nokogiri_document(stringlike)
        else
          @document = Webrat.hpricot_document(stringlike)
        end

        @document = @document.at(@scope) if @scope

        @element = Webrat::XML.inner_text(@document)

        case @content
        when String
          @element.include?(@content)
        when Regexp
          @element.match(@content)
        end
      end

      # ==== Returns
      # String:: The failure message.
      def failure_message
        "expected the following element's content to #{content_message}:\n#{squeeze_space(@element)}"
      end

      # ==== Returns
      # String:: The failure message to be displayed in negative matches.
      def negative_failure_message
        "expected the following element's content to not #{content_message}:\n#{squeeze_space(@element)}"
      end

      def squeeze_space(inner_text)
        inner_text.gsub(/^\s*$/, "").squeeze("\n")
      end

      def content_message
        case @content
        when String
          "include \"#{@content}\""
        when Regexp
          "match #{@content.inspect}"
        end
      end
    end

    # Matches the contents of an HTML document with
    # whatever string is supplied.
    # You can pass a selector to scope your expectation
    # to a specific element (defaults to the whole
    # response body).
    def contain(content, scope = nil)
      HasContent.new(content, scope)
    end

    # Asserts that the body of the response contain
    # the supplied string or regexp.
    # You can pass a selector to scope your assertion
    # to a specific element (defaults to the whole
    # response body).
    def assert_contain(content, scope = nil)
      hc = HasContent.new(content, scope)
      assert hc.matches?(response_body), hc.failure_message
    end

    # Asserts that the body of the response
    # does not contain the supplied string or regexp.
    # You can pass a selector to scope your assertion
    # to a specific element (defaults to the whole
    # response body).
    def assert_not_contain(content, scope = nil)
      hc = HasContent.new(content, scope)
      assert !hc.matches?(response_body), hc.negative_failure_message
    end

  end
end
