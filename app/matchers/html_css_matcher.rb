class HtmlCssMatcher
  attr_reader :regex, :code

  def initialize regex, code
    @regex = regex
    @code = code
  end

  def run
    /There is "(.*)" root hierarchy/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      tags_array = res[1].split('>')

      match_result = html_structure
      tags_array.each do |tag|
        tag_name, id, classes = tag_attribute(tag)
        match_result = match_result.xpath(tag_name)

        if (match_result.length > 0)
          match_tag = match_result[0]
          if (!id.nil?)
            if (match_tag["id"] != id)
              raise "#{tag_name} doesn't has id #{id}"
            end
          end

          if (classes.length > 0)
            if (!(classes - match_tag["class"].split(' ')).empty?)
              raise "#{tag_name} doesn't has classes #{classes.join(' ')}"
            end
          end
        else
          raise "#{tag_name} not exsisted"
        end
      end
      return true
    end

    /There is "(.*)" hierarchy/.match(regex) do |res|
      first = true
      html_structure = Nokogiri::HTML(@code)
      tags_array = res[1].split('>')

      match_result = html_structure
      tags_array.each do |tag|
        tag_name, id, classes = tag_attribute(tag)
        if (first)
          match_result = match_result.css(tag_name)
        else
          match_result = match_result.xpath(tag_name)
        end

        if (match_result.length > 0)
          match_tag = match_result[0]
          if (!id.nil?)
            if (match_tag["id"] != id)
              raise "#{tag_name} doesn't has id #{id}"
            end
          end

          if (classes.length > 0)
            if (!(classes - match_tag["class"].split(' ')).empty?)
              raise "#{tag_name} doesn't has classes #{classes.join(' ')}"
            end
          end
        else
          raise "#{tag_name} not exsisted"
        end
      end
      return true
    end

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

  private

    def build_path text
      tags = []
      path = ""
      i = 1
      tags_array = text.split('>')
      tags_array.each do |tag_with_property|
        tag = tag_with_property.split('.')[0]
        tags << tag
        path += tag
        if (i < tags_array.length)
          path += '//'
        end
        i += 1
      end
      [path, tags]
    end

    def tag_attribute tag
      classes = []
      id = ""

      ch = tag.split('#')
      classes_tmp = ch[0].split('.')
      tag_name = classes_tmp[0]

      classes_tmp = classes_tmp.slice(1, classes_tmp.length)
      classes << classes_tmp

      if (ch[1].nil?)
        id = nil
      else
        classes_tmp = ch[1].split('.')
        id = classes_tmp[0]

        classes_tmp = classes_tmp.slice(1, classes_tmp.length)
        classes << classes_tmp
      end

      [tag_name, id, classes.flatten!]
    end

end