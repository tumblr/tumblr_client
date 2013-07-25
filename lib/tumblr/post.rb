require 'mime/types'

module Tumblr
  module Post

    STANDARD_POST_OPTIONS = [:state, :tags, :tweet, :date, :markdown, :slug, :format]

    def edit(blog_name, options = {})
      convert_source_array :source, options
      post(blog_path(blog_name, 'post/edit'), options)
    end

    def reblog(blog_name, options = {})
      post(blog_path(blog_name, 'post/reblog'), options)
    end

    def delete(blog_name, id)
      post(blog_path(blog_name, 'post/delete'), :id => id)
    end

    def photo(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:caption, :link, :data, :source, :photoset_layout]
      validate_options(valid_opts, options)
      validate_no_collision options, [:data, :source]
      convert_source_array :source, options

      options[:type] = 'photo'
      extract_data!(options)
      post(post_path(blog_name), options)
    end

    def quote(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:quote, :source]
      validate_options(valid_opts, options)

      options[:type] = 'quote'
      post(post_path(blog_name), options)
    end

    def text(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:title, :body]
      validate_options(valid_opts, options)

      options[:type] = 'text'
      post(post_path(blog_name), options)
    end

    def link(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:title, :url, :description]
      validate_options(valid_opts, options)

      options[:type] = 'link'
      post(post_path(blog_name), options)
    end

    def chat(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:title, :conversation]
      validate_options(valid_opts, options)

      options[:type] = 'chat'
      post(post_path(blog_name), options)
    end

    def audio(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:data, :caption, :external_url]
      validate_options(valid_opts, options)
      validate_no_collision options, [:data, :external_url]

      options[:type] = 'audio'
      extract_data!(options)
      post(post_path(blog_name), options)
    end

    def video(blog_name, options = {})
      valid_opts = STANDARD_POST_OPTIONS + [:data, :embed, :caption]
      validate_options(valid_opts, options)
      validate_no_collision options, [:data, :embed]

      options[:type] = 'video'
      extract_data!(options)
      post(post_path(blog_name), options)
    end

    private

    def post_path(blog_name)
      blog_path(blog_name, 'post')
    end

    # Allow source to be passed as an Array
    def convert_source_array(key, options)
      if options.has_key?(key) && options[key].kind_of?(Array)
        options[key].each.with_index do |src, idx|
          options["#{key.to_s}[#{idx}]"] = src
        end
        options.delete(key)
      end
    end

    # Look for the various ways that data can be passed, and normalize
    # the result in this hash
    def extract_data!(options)
      if options.has_key?(:data)
        data = options.delete :data
        data = [data] unless Array === data
        data.each.with_index do |filepath, idx|
          mime = MIME::Types.type_for(filepath)
          if (!mime.empty?)
            mime_type = MIME::Types.type_for(filepath)[0].content_type
          else
            mime_type = "application/octet-stream"
          end
          options["data[#{idx}]"] = Faraday::UploadIO.new(filepath, mime_type)
        end
      end
    end

  end
end
