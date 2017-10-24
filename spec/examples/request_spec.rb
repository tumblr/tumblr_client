require 'spec_helper'

describe Tumblr::Request do

  let(:client) { Tumblr::Client.new }

  describe :respond do

    [200, 201].each do |rcode|

      context "with a #{rcode} response" do

        it 'should return the meta object' do
          data = { :message => 'ohyes' }
          response = OpenStruct.new(:status => rcode, :body => { 'response' => data })
          expect(client.respond(response)).to eq(data)
        end

      end

    end

    context 'with an error response' do

      it 'should return the meta object (merged with response)' do
        meta = { :message => 'ohno' }
        response = OpenStruct.new(:status => 401, :body => { 'meta' => meta, 'response' => { :also => 'hi' } })
        expect(client.respond(response)).to eq({ :message => 'ohno', :also => 'hi' })
      end

      it 'should return the meta object even when response is nil' do
        meta = { :message => 'ohno' }
        response = OpenStruct.new(:status => 401, :body => { 'meta' => meta, 'response' => nil })
        expect(client.respond(response)).to eq(meta)
      end

    end

  end

  describe :get do

    before do
      @path = '/the/path'
      @params = { :hello => 'world' }
      expect(client).to receive(:get_response).once.with(@path, @params).
      and_return(OpenStruct.new({
        :status => 200,
        :body => { 'response' => 'result' }
      }))
    end

    it 'should get the response directly' do
      expect(client.get(@path, @params)).to eq('result')
    end

  end

  describe :get_redirect_url do

    [301, 302].each do |status|

      context "when redirect is found with #{status} code" do

        before do
          @path = '/the/path'
          @params = { :hello => 'world' }
          @redirect_url = 'redirect-to-here'
          expect(client).to receive(:get_response).once.with(@path, @params).
          and_return(OpenStruct.new({
            :status => status,
            :headers => { 'Location' => @redirect_url }
          }))
        end

        it 'should return the redirect url' do
          expect(client.get_redirect_url(@path, @params)).to eq(@redirect_url)
        end

      end

    end

    context 'when error is encountered' do

      before do
        @path = '/the/path'
        @params = { :hello => 'world' }
        @meta = { :message => 'ohno' }
        expect(client).to receive(:get_response).once.with(@path, @params).
        and_return(OpenStruct.new({
          :status => 401,
          :body => { 'meta' => @meta }
        }))
      end

      it 'should return the error meta' do
        expect(client.get_redirect_url(@path, @params)).to eq(@meta)
      end

    end

  end

end
