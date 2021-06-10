module Tumblr
  module User

    def info
      get('v2/user/info')
    end

    def dashboard(options = {})
      valid_opts = [:limit, :offset, :type, :since_id, :reblog_info, :notes_info]
      validate_options(valid_opts, options)
      get('v2/user/dashboard', options)
    end

    def likes(options = {})
      validate_options([:limit, :offset, :before, :after], options)
      get('v2/user/likes', options)
    end

    def following(options = {})
      validate_options([:limit, :offset], options)
      get('v2/user/following', options)
    end

    def follow(url)
      post('v2/user/follow', :url => url)
    end

    def unfollow(url)
      post('v2/user/unfollow', :url => url)
    end

    def like(id, reblog_key)
      post('v2/user/like', :id => id, :reblog_key => reblog_key)
    end

    def unlike(id, reblog_key)
      post('v2/user/unlike', :id => id, :reblog_key => reblog_key)
    end

    def filtered_content
      get('v2/user/filtered_content')
    end
    alias_method :get_filtered_content, :filtered_content

    def add_filtered_content(filtered_strings=nil, options={})
      validate_options([:filtered_content], options)
      options[:filtered_content] ||= filtered_strings
      post('v2/user/filtered_content', options)
    end

    def delete_filtered_content(filtered_strings, options={})
      validate_options([:filtered_content], options)
      options[:filtered_content] ||= filtered_strings
      delete('v2/user/filtered_content', options)
    end

  end
end
