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
        expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/delete", {
          :id => post_id
        })
      end

      it 'should setup a delete properly' do
        client.delete_post blog_name, post_id
      end

    end

  end

  describe :edit do
    [:photo, :audio, :video].each do |type|
      describe type do
        context 'when passing data as an array of filepaths' do
          before do
            fakefile = OpenStruct.new :read => file_data
            allow(File).to receive(:open).with(file_path + '.jpg').and_return(fakefile)
            expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
              'data[0]' => kind_of(Faraday::UploadIO),
                :id => 123,
                :type => type
            }).and_return('response')
          end

          it 'should be able to pass data as an array of filepaths' do
            r = client.edit blog_name, :data => [file_path + ".jpg"], :id => 123, :type => type
            expect(r).to eq('response')
          end

          it 'should be able to pass data as an array of uploadios' do
            r = client.edit blog_name, :data => [Faraday::UploadIO.new(StringIO.new, 'image/jpeg')], :id => 123, :type => type
            expect(r).to eq('response')
          end

        end

        context 'when passing data different ways' do

          before do
            fakefile = OpenStruct.new :read => file_data
            allow(File).to receive(:open).with(file_path + '.jpg').and_return(fakefile)
            expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
              'data' => kind_of(Faraday::UploadIO),
                :id => 123,
                :type => type
            }).and_return('response')
          end

          it 'should be able to pass data as a single filepath' do
            r = client.edit blog_name, :data => file_path + ".jpg", :id => 123, :type => type
            expect(r).to eq('response')
          end

          it 'should be able to pass data as a single uploadio' do
            r = client.edit blog_name, :data => Faraday::UploadIO.new(StringIO.new, 'image/jpeg'), :id => 123, :type => type
            expect(r).to eq('response')
          end

        end
      end
    end

    it 'should make the correct call' do
      expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
        :id => 123
      }).and_return('response')
      r = client.edit blog_name, :id => 123
      expect(r).to eq('response')
    end
  end

  describe :reblog do

    it 'should make the correct call' do
      expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/reblog", {
        :id => 123
      }).and_return('response')
      r = client.reblog blog_name, :id => 123
      expect(r).to eq('response')
    end

  end

  # Simple post types
  [:quote, :text, :link, :chat].each do |type|

    field = type == :quote ? 'quote' : 'title' # uglay

    describe type do

      context 'when passing an option which is not allowed' do

        it 'should raise an error' do
          expect(lambda {
            client.send type, blog_name, :not => 'an option'
          }).to raise_error ArgumentError
        end

      end

      context 'when passing valid data' do

        before do
          @val = 'hello world'
          expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post", {
            field.to_sym => @val,
            :type => type.to_s
          }).and_return('response')
        end

        it 'should set up the call properly' do
          r = client.send type, blog_name, field.to_sym => @val
          expect(r).to eq('response')
        end

      end

    end

  end

  describe :create_post do

    let(:blog_name) { 'seejohnrun' }
    let(:args) { { :source => 'somesource' } }

    context 'with a valid post type' do

      before do
        expect(client).to receive(:photo).with(blog_name, args).and_return 'hi'
      end

      it 'should call the right method and grab the return' do
        expect(client.create_post(:photo, blog_name, args)).to eq('hi')
      end

    end

    context 'with an invalid post type' do

      it 'should raise an error' do
        expect(lambda do
          client.create_post(:fake, blog_name, args)
        end).to raise_error ArgumentError, '"fake" is not a valid post type'
      end

    end

  end

  # Complex post types
  [:photo, :audio, :video].each do |type|

    describe type do

      context 'when passing an option which is not allowed' do

        it 'should raise an error' do
          expect(lambda {
            client.send type, blog_name, :not => 'an option'
          }).to raise_error ArgumentError
        end

      end

      context 'when passing data as an array of filepaths' do
        before do
          fakefile = OpenStruct.new :read => file_data
          allow(File).to receive(:open).with(file_path + '.jpg').and_return(fakefile)
          expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post", {
            'data[0]' => kind_of(Faraday::UploadIO),
            :type => type.to_s
          }).and_return('post')
        end
        
        it 'should be able to pass data as an array of filepaths' do
          r = client.send type, blog_name, :data => [file_path + ".jpg"]
          expect(r).to eq('post')
        end

        it 'should be able to pass data as an array of uploadios' do
          r = client.send type, blog_name, :data => [Faraday::UploadIO.new(StringIO.new, 'image/jpeg')]
          expect(r).to eq('post')
        end

      end

      context 'when passing data different ways' do

        before do
          fakefile = OpenStruct.new :read => file_data
          allow(File).to receive(:open).with(file_path + '.jpg').and_return(fakefile)
          expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post", {
            'data' => kind_of(Faraday::UploadIO),
            :type => type.to_s
          }).and_return('post')
        end

        it 'should be able to pass data as a single filepath' do
          r = client.send type, blog_name, :data => file_path + ".jpg"
          expect(r).to eq('post')
        end

        it 'should be able to pass data as a single uploadio' do
          r = client.send type, blog_name, :data => Faraday::UploadIO.new(StringIO.new, 'image/jpeg')
          expect(r).to eq('post')
        end

      end

      # Only photos have source
      if type == :photo

        context 'when passing source different ways' do

          it 'should be able to be passed as a string' do
            expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post", {
              :source => source,
              :type => type.to_s
            })
            client.send type, blog_name, :source => source
          end

          it 'should be able to be passed as an array' do
            expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post", {
              'source[0]' => source,
              'source[1]' => source,
              :type => type.to_s
            })
            client.send type, blog_name, :source => [source, source]
          end

          it 'should be able to be passed as an array on edit' do
            expect(client).to receive(:post).once.with("v2/blog/#{blog_name}/post/edit", {
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
          expect(lambda {
            client.send type, blog_name, :data => 'hi', :source => 'bye'
          }).to raise_error ArgumentError
        end

      end

    end

  end

end
