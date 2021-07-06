module Tumblr
  module Blog

    # Gets the info about the blog
    def blog_info(blog_name)
      get(blog_path(blog_name, 'info'), :api_key => @consumer_key)
    end

    # Gets the avatar URL of specified size
    def avatar(blog_name, size = nil)
      url = blog_path(blog_name, 'avatar')
      url = "#{url}/#{size}" if size
      get_redirect_url(url)
    end

    # Gets the list of followers for the blog
    def followers(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'followers'), options)
    end

    # Gets the list of blogs the user is following
    def blog_following(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'following'), options)
    end

    # Determines whether own blog (followee_blog) is followed by follower_blog 
    # (if authorized)
    def followed_by(followee_blog, follower_blog=nil, **options)
      validate_options([:query], options)
      options[:query] ||= follower_blog
      get(blog_path(followee_blog, 'followed_by'), options)
    end
    alias_method :blog_followed_by, :followed_by

    # Gets the list of likes for the blog
    def blog_likes(blog_name, options = {})
      validate_options([:limit, :offset, :before, :after], options)
      url = blog_path(blog_name, 'likes')

      params = { :api_key => @consumer_key }
      params.merge! options
      get(url, params)
    end

    # Get public posts from blog
    def posts(blog_name, options = {})
      url = blog_path(blog_name, 'posts')
      if options.has_key?(:type)
        url = "#{url}/#{options[:type]}"
      end

      params = { :api_key => @consumer_key }
      params.merge! options
      get(url, params)
    end

    # Get post of given ID from blog
    def get_post(blog_name, post_id, **options)
      validate_options([:post_format], options)
      get(blog_path(blog_name, "posts/#{post_id}"), options)
    end

    # Get notes for post of given ID
    def notes(blog_name, post_id=nil, options = {})
      validate_options([:id, :before_timestamp, :mode], options)
      options[:id] ||= post_id
      get(blog_path(blog_name, 'notes'), options)
    end

    # Get queued posts from blog (if authorized)
    def queue(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'posts/queue'), options)
    end

    # Reorder blog's queue (if authorized)
    def reorder_queue(blog_name, options = {})
      validate_options([:post_id, :insert_after], options)
      post(blog_path(blog_name, 'posts/queue/reorder'), options)
    end

    # Shuffle blog's queue (if authorized)
    def shuffle_queue(blog_name)
      post(blog_path(blog_name, 'posts/queue/shuffle'))
    end

    # Get drafts posts from blog (if authorized)
    def draft(blog_name, options = {})
      validate_options([:limit, :before_id], options)
      get(blog_path(blog_name, 'posts/draft'), options)
    end
    alias_method :drafts, :draft

    # Get pending submissions posts from blog (if authorized)
    def submissions(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'posts/submission'), options)
    end
    alias_method :submission, :submissions

    # Get notifications for blog (if authorized)
    def notifications(blog_name, options = {})
      validate_options([:before, :types], options)
      get(blog_path(blog_name, 'notifications'), options)
    end

    # Get blogs blocked by blog (if authorized)
    def blocks(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'blocks'), options)
    end
    alias_method :blocked, :blocks

    # Block a blog (blockee_blog) from blocker_blog (if authorized)
    def block(blocker_blog, blockee_blog=nil, **options)
      validate_options([:blocked_tumblelog, :post_id], options)
      options[:blocked_tumblelog] ||= blockee_blog
      post(blog_path(blocker_blog, 'blocks'), options)
    end

    # Unblock a blog (blockee_blog) from blocker_blog (if authorized)
    def unblock(blocker_blog, blockee_blog=nil, **options)
      validate_options([:blocked_tumblelog, :anonymous_only], options)
      options[:blocked_tumblelog] ||= blockee_blog
      delete(blog_path(blocker_blog, 'blocks'), options)
    end

  end
end
