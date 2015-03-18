class Session

  COOKIE_NAME = '_rails_lite_app'

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies.find { |cookie| cookie.name == COOKIE_NAME }
    @attributes = cookie ? JSON.parse(cookie.value) : {}
  end

  def [](key)
    @attributes[key]
  end

  def []=(key, val)
    @attributes[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = WEBrick::Cookie.new(COOKIE_NAME, @attributes.to_json)
    res.cookies << cookie
  end
end
