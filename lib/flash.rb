class Flash

  COOKIE_NAME = '_rails_lite_flash'

  def initialize(req)
    cookie = req.cookies.find { |cookie| cookie.name == COOKIE_NAME}
    @attributes = cookie ? JSON.parse(cookie.value) : {}
    @next_attr = {}
  end

  def now
    @attributes
  end

  def [](key)
    @next_attr[key]
  end

  def []=(key, value)
    @next_attr[key] = value
  end

  def attributes
    @attributes ||= {}
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new(COOKIE_NAME, @next_attr.to_json)
    res.cookies << cookie
  end

end
