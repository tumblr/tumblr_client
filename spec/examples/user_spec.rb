require 'spec_helper'

describe Tumblr::User do

  let(:client) { Tumblr::Client.new }


  describe :info do

    it 'should make the request properly' do
      expect(client).to receive(:get).with('v2/user/info').and_return('response')
      r = client.info
      expect(r).to eq('response')
    end

  end

  describe :dashboard do

    context 'when using options that are not allowed' do

      it 'should raise an error' do
        expect(lambda {
          client.dashboard :not => 'an option'
        }).to raise_error ArgumentError
      end

    end

    context 'when using valid options' do

      it 'should make the correct call' do
        expect(client).to receive(:get).with('v2/user/dashboard', {
          :limit => 25
        }).and_return('response')
        r = client.dashboard :limit => 25
        expect(r).to eq('response')
      end

    end

  end

  # These two are very similar
  [:following, :likes].each do |type|

    describe type do

      context 'with defaults' do

         it 'should make the reqest properly' do
           expect(client).to receive(:get).with("v2/user/#{type}", {}).
           and_return('response')
           r = client.send type
           expect(r).to eq('response')
         end

      end

      context 'with custom limit & offset' do

         it 'should make the reqest properly' do
           expect(client).to receive(:get).with("v2/user/#{type}", {
             :limit => 10,
             :offset => 5
           }).and_return('response')
           r = client.send type, :offset => 5, :limit => 10
           expect(r).to eq('response')
         end

      end

    end

  end

  # Like and unlike are similar
  [:like, :unlike].each do |type|

    describe type do

      it 'should make the request properly' do
        id = 123
        reblog_key = 'hello'
        expect(client).to receive(:post).with("v2/user/#{type}", {
          :id => id,
          :reblog_key => reblog_key
        }).and_return('response')
        r = client.send type, id, reblog_key
        expect(r).to eq('response')
      end

    end

  end

  # Follow and unfollow are similar
  [:follow, :unfollow].each do |type|

    describe type do

      it 'should make the request properly' do
        url = 'some url'
        expect(client).to receive(:post).with("v2/user/#{type}", {
          :url => url
        }).and_return('response')
        r = client.send type, url
        expect(r).to eq('response')
      end

    end

  end  

  describe :filtered_content do
    it 'should make the reqest properly' do
      expect(client).to receive(:get).with("v2/user/filtered_content").and_return('response')
      r = client.filtered_content
      expect(r).to eq('response')
    end
  end

  describe :add_filtered_content do
    it 'should make the reqest properly' do
      expect(client).to receive(:post).with("v2/user/filtered_content", filtered_content: ['str']).and_return('response')
      r = client.add_filtered_content ['str']
      expect(r).to eq('response')
    end
  end

  describe :delete_filtered_content do
    it 'should make the reqest properly' do
      expect(client).to receive(:delete).with("v2/user/filtered_content", filtered_content: ['str']).and_return('response')
      r = client.delete_filtered_content ['str']
      expect(r).to eq('response')
    end
  end

end
