class Flash

  COOKIE_NAME = '_rails_lite_flash'

  def initialize(req)
    cookie = req.cookies.find { |cookie| cookie.name == COOKIE_NAME}
    @attributes = if cookie
      Hash[JSON.parse(cookie.value).map{ |k, v| [k.to_sym, v] }]
    else
      {}
    end
    @next_attr = {}
  end

  def now
    @attributes
  end

  def [](key)
    @attributes[key.to_sym]
  end

  def []=(key, value)
    @next_attr[key.to_sym] = value
  end

  def attributes
    @attributes ||= {}
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new(COOKIE_NAME, @next_attr.to_json)
    res.cookies << cookie
  end

end
