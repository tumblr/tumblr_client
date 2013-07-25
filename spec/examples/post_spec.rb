require 'spec_helper'

describe Tumblr::Post do

  let(:client) { Tumblr::Client.new }
  let(:blog_name) { 'blog.name' }
  let(:file_path) { '/path/to/the/file' }
  let(:file_data) { 'lol cats' }
  let(:source)    { 'the source' }
  let(:post_id)   { 42 }

  describe :delete do

    context 'when deleting a post' do

      before do
        client.should_receive(:post).once.with("v2/blog/#{blog_name}/post/delete", {
          :id => post_id
        })
      end

      it 'should setup a delete properly' do
        client.delete blog_name, post_id
      end

    end

  end

  describe :edit do

    it 'should make the correct call' do
      client.should_receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
        :id => 123
      }).and_return('response')
      r = client.edit blog_name, :id => 123
      r.should == 'response'
    end

  end

  describe :reblog do

    it 'should make the correct call' do
      client.should_receive(:post).once.with("v2/blog/#{blog_name}/post/reblog", {
        :id => 123
      }).and_return('response')
      r = client.reblog blog_name, :id => 123
      r.should == 'response'
    end

  end

  # Simple post types
  [:quote, :text, :link, :chat].each do |type|

    field = type == :quote ? 'quote' : 'title' # uglay

    describe type do

      context 'when passing an option which is not allowed' do

        it 'should raise an error' do
          lambda {
            client.send type, blog_name, :not => 'an option'
          }.should raise_error ArgumentError
        end

      end

      context 'when passing valid data' do

        before do
          @val = 'hello world'
          client.should_receive(:post).once.with("v2/blog/#{blog_name}/post", {
            field.to_sym => @val,
            :type => type.to_s
          }).and_return('response')
        end

        it 'should set up the call properly' do
          r = client.send type, blog_name, field.to_sym => @val
          r.should == 'response'
        end

      end

    end

  end

  # Complex post types
  [:photo, :audio, :video].each do |type|

    describe type do

      context 'when passing an option which is not allowed' do

        it 'should raise an error' do
          lambda {
            client.send type, blog_name, :not => 'an option'
          }.should raise_error ArgumentError
        end

      end

      context 'when passing data different ways' do

        before do
          fakefile = OpenStruct.new :read => file_data
          File.stub(:open).with(file_path + '.jpg').and_return(fakefile)
          client.should_receive(:post).once.with("v2/blog/#{blog_name}/post", {
            'data[0]' => kind_of(Faraday::UploadIO),
            :type => type.to_s
          }).and_return('post')
        end

        it 'should be able to pass data as an array of filepaths' do
          r = client.send type, blog_name, :data => [file_path + ".jpg"]
          r.should == 'post'
        end

        it 'should be able to pass data as a single filepath' do
          r = client.send type, blog_name, :data => file_path + ".jpg"
          r.should == 'post'
        end

      end

      # Only photos have source
      if type == :photo

        context 'when passing source different ways' do

          it 'should be able to be passed as a string' do
            client.should_receive(:post).once.with("v2/blog/#{blog_name}/post", {
              :source => source,
              :type => type.to_s
            })
            client.send type, blog_name, :source => source
          end

          it 'should be able to be passed as an array' do
            client.should_receive(:post).once.with("v2/blog/#{blog_name}/post", {
              'source[0]' => source,
              'source[1]' => source,
              :type => type.to_s
            })
            client.send type, blog_name, :source => [source, source]
          end

          it 'should be able to be passed as an array on edit' do
            client.should_receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
              :id => post_id,
              'source[0]' => source,
              'source[1]' => source
            })
            client.edit blog_name, :id => post_id, :source => [source, source]
          end

        end

      end

      context 'when passing colliding options' do

        it 'should get an error when passing data & source' do
          lambda {
            client.send type, blog_name, :data => 'hi', :source => 'bye'
          }.should raise_error ArgumentError
        end

      end

    end

  end

end
