# Controller concern containing helper methods to get and set a cookie with a nested hash
# E.g., you might have an experiments cookie that you store experiment data in for different tests
module Cookies
  include ActiveSupport::Concern

  NAMESPACE = :your_namespace

  def cookie_data(name)
    return nil unless cookies[NAMESPACE].present?

    cookies_hash = JSON.parse(cookies[NAMESPACE])
    cookies_hash[name]
  end

  def set_cookie(name, data)
    create_cookie

    cookies_hash          = JSON.parse(cookies[NAMESPACE])
    cookies_hash[name]    = data

    cookies[NAMESPACE] = {
      value: JSON.generate(cookies_hash)
    }
  end

  private

  def create_cookie
    if cookies[NAMESPACE].nil?
      cookies[NAMESPACE] ||= {
        value: JSON.generate({})
      }
    end
  end
end
