require 'set'

# Convertible provides methods for converting a pagelike item
# from a certain type of markup into actual content
#
# Requires
#   self.site -> Jekyll::Site
#   self.content
#   self.content=
#   self.data=
#   self.ext=
#   self.output=
module Jekyll
  module Convertible
    # Returns the contents as a String.
    def to_s
      self.content || ''
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      self.content = File.read(File.join(base, name))

      #This doesn't seem to work
      #self.content.encode!("UTF-8", :undef => :replace, :invalid => :replace)

      # this breaks the --- --- yaml loading
      # self.content.force_encoding("ASCII-8BIT")   # if not already
      # self.content.gsub!(/[^\\x20-\\x7e]/,'')
      # self.content.force_encoding("UTF-8")

      begin
        if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH

          self.data = YAML.load($1)
        end
      rescue ArgumentError
        STDERR.puts "The contents of post #{name} are causing some problems. Most likely it has characters that are invalid UTF-8. Please correct this and try again."
        exit(1)
      rescue => e
        puts "YAML Exception reading #{name}: #{e.message}"
      end

      self.data ||= {}
    end

    # Transform the contents based on the content type.
    #
    # Returns nothing.
    def transform
      self.content = converter.convert(self.content)
    end

    # Determine the extension depending on content_type.
    #
    # Returns the String extension for the output file.
    #   e.g. ".html" for an HTML output file.
    def output_ext
      converter.output_ext(self.ext)
    end

    # Determine which converter to use based on this convertible's
    # extension.
    #
    # Returns the Converter instance.
    def converter
      @converter ||= self.site.converters.find { |c| c.matches(self.ext) }
    end

    # Add any necessary layouts to this convertible document.
    #
    # payload - The site payload Hash.
    # layouts - A Hash of {"name" => "layout"}.
    #
    # Returns nothing.
    def do_layout(payload, layouts)
      info = { :filters => [Jekyll::Filters], :registers => { :site => self.site, :page => payload['page']} }

      # render and transform content (this becomes the final content of the object)
      payload["pygments_prefix"] = converter.pygments_prefix
      payload["pygments_suffix"] = converter.pygments_suffix

      begin
        self.content = Liquid::Template.parse(self.content).render(payload, info)
      rescue => e
        puts "Liquid Exception: #{e.message}"
      end

      self.transform

      # output keeps track of what will finally be written
      self.output = self.content

      # recursively render layouts
      layout = layouts[self.data["layout"]]
      used = Set.new([layout])

      while layout
        payload = payload.deep_merge({"content" => self.output, "page" => layout.data})

        begin
          self.output = Liquid::Template.parse(layout.content).render(payload, info)
        rescue => e
          puts "Liquid Exception: #{e.message} in #{self.data["layout"]}"
        end

        if layout = layouts[layout.data["layout"]]
          if used.include?(layout)
            layout = nil # avoid recursive chain
          else
            used << layout
          end
        end
      end
    end
  end
end
