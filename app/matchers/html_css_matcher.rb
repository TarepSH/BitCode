class HtmlCssMatcher
  attr_reader :regex, :code

  def initialize regex, code, attr_values
    @regex = regex
    @code = code
    @attr_values = attr_values
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
              return [false, I18n.t('tag_does_not_has_id', tag_name: tag_name, id: id)]
            end
          end

          if (classes.length > 0)
            if (!(classes - match_tag["class"].split(' ')).empty?)
              return [false, I18n.t('tag_does_not_has_classes', tag_name: tag_name, classes: classes.join(' '))]
            end
          end
        else
          return [false, I18n.t("messages.tag_not_exsisted", tag_name: tag_name)]
        end
      end
      return [true]
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
              return [false, I18n.t('tag_does_not_has_id', tag_name: tag_name, id: id)]
            end
          end

          if (classes.length > 0)
            if (!(classes - match_tag["class"].split(' ')).empty?)
              return [false, I18n.t('tag_does_not_has_classes', tag_name: tag_name, classes: classes.join(' '))]
            end
          end
        else
          return [false, I18n.t("messages.tag_not_exsisted", tag_name: tag_name)]
        end
      end
      return [true]
    end

    /"(.*)" tag is exsist/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[1])
      if (match_result.length > 0)
        return [true]
      else
        return [false, I18n.t("messages.tag_not_exsisted", tag_name: res[1])]
      end
    end

    /There is "(.*)" tag inside the "(.*)" tag/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[2])
      if (match_result.length > 0)
        match_result = match_result[0].xpath(res[1])
        if (match_result.length > 0)
          return [true]
        else
          return [false, I18n.t("messages.text_not_inside_tag", text: res[1], tag_name: res[2])]
        end
      else
        return [false, I18n.t("messages.tag_not_exsisted", tag_name: res[1])]
      end
    end

    /There is "(.*)" inside the "(.*)" tag/.match(regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[2])
      if (match_result.length > 0)
        if (res[1] == match_result[0].children.text)
          return [true]
        else
          return [false, I18n.t("messages.text_not_inside_tag", text: res[1], tag_name: res[2])]
        end
      else
        return [false, I18n.t("messages.tag_not_exsisted", tag_name: res[2])]
      end
    end

    /"(.*)" tag has "(.*)" value for "(.*)" attribute/.match (regex) do |res|
      html_structure = Nokogiri::HTML(@code)
      match_result = html_structure.css(res[1])
      if (match_result.length > 0)
        arr_val = @attr_values.select { |attr_val| attr_val[res[1]] }[0][res[1]]
        if arr_val
          value = arr_val.select { |val| val[res[3]] }[0][res[3]]
          if (value == res[2])
            return [true]
          else
            return [false, I18n.t("messages.tag_attribute_value_not_match", tag_name: res[1], attribute: I18n.t('css.' + res[3]), value: I18n.t('css_value.' + res[2]))]
          end
        else
          return [false, I18n.t("messages.tag_attribute_value_not_match", tag_name: res[1], attribute: I18n.t('css.' + res[3]), value: I18n.t('css_value.' + res[2]))]
        end
      else
        return [false, I18n.t("messages.tag_not_exsisted", tag_name: res[1])]
      end
    end

    return [false, "No Matcher found."]
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