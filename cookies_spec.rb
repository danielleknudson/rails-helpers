require 'spec_helper'

describe Cookies, type: :controller do
  controller do
    include Cookies

    def get_cookie_data
      set_cookie('test', { 'group': 'treatment' })
      render json: cookie_data('test')
    end

    def set_cookie_data
      set_cookie('test', { 'group': 'treatment' })
      render nothing: true
    end
  end

  before do
    routes.draw do
      get 'get_cookie_data' => 'anonymous#get_cookie_data'
      post 'set_cookie_data' => 'anonymous#set_cookie_data'
    end
  end

  describe '#set_cookie' do
    it 'sets a cookie key and value' do
      expect(request.cookies).to be_empty
      post :set_cookie_data
      after_cookies = JSON.parse(response.cookies[:your_namespace])
      expect(after_cookies).to be_present
      expect(after_cookies[:your_namespace]['group']).to eq('treatment')
    end
  end

  describe '#cookie_data' do
    it 'sets a cookie key and value' do
      get :get_cookie_data
      json = JSON.parse(response.body)
      expect(json).to be_present
      expect(json['group']).to eq('treatment')
    end
  end
end
