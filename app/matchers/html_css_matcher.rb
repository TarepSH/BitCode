class HtmlCssMatcher
  attr_reader :regex, :code

  def initialize regex, code
    @regex = regex
    @code = code.gsub(/\n|\s/, '')
  end

  def run
    /"(.*)" double tag is exsist/.match(regex) do |res|
      regex_result = Regexp.new("<#{res[1]}>.*<\/#{res[1]}>")
      match_result = @code.match(regex_result)
      if (match_result)
        return true
      else
        raise "#{res[1]} no exsist"
      end
    end

    /"(.*)" single tag is exsisted/.match(regex) do |res|
      regex_result = Regexp.new("<#{res[1]}.*\">")
      match_result = @code.match(regex_result)
      if (match_result)
        return true
      else
        raise "#{res[1]} no exsist"
      end
    end

    /There is "(.*)" double tag inside the "(.*)" tag/.match(regex) do |res|
      regex_result = Regexp.new("<#{res[2]}>.*<#{res[1]}>.*<\/#{res[1]}>.*<\/#{res[2]}>")
      match_result = @code.match(regex_result)
      if (match_result)
        return true
      else
        raise "#{res[1]} not inside #{res[2]}"
      end
    end

    /There is "(.*)" single tag inside the "(.*)" tag/.match(regex) do |res|
      regex_result = Regexp.new("<#{res[2]}>.*<#{res[1]}.*\">.*<\/#{res[2]}>")
      match_result = @code.match(regex_result)
      if (match_result)
        return true
      else
        raise "#{res[1]} not inside #{res[2]}"
      end
    end

    /There is "(.*)" inside the "(.*)" tag/.match(regex) do |res|
      regex_result = Regexp.new("<#{res[2]}>.*#{res[1]}.*<\/#{res[2]}>")
      match_result = @code.match(regex_result)
      if (match_result)
        return true
      else
        raise "There is no #{res[1]} inside #{res[2]}"
      end
    end
  end

end