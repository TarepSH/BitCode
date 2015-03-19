class HtmlCssMatcher
  attr_reader :regex, :code

  def initialize regex, code
    @regex = regex
    @code = code
  end

  def run
    /"(.*)" tag is exsist/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.xpath(res[1])
      if (match_result.length > 0)
        return true
      else
        raise "#{res[1]} not exsisted"
      end
    end

    /There is "(.*)" tag inside the "(.*)" tag/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[2])
      if (match_result.length > 0)
        match_result = match_result[0].xpath(res[1])
        if (match_result.length > 0)
          return true
        else
          raise "#{res[1]} not inside #{res[2]}"
        end
      else
        raise "#{res[1]} not exsisted"
      end
    end

    /There is "(.*)" inside the "(.*)" tag/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[2])
      if (match_result.length > 0)
        if (res[1] == match_result[0].children.text)
          return true
        else
          raise "There is no #{res[1]} inside #{res[2]}"
        end
      else
        raise "#{res[2]} not exsisted"
      end
    end

    raise "No Matcher found."
  end

end