module SafeCookiePatch
  def [](name)
    @parent_jar.secured
    super
  end

  def []=(name, options)
    @parent_jar.secured
    super
  end  
end

module CookiePatch
  def secured
    @secured = true
  end

  def [](name)
    Rails.logger.warn "WARNING: INSECURE READING OF COOKIE FOR VALUE #{name}." unless @secured
    @secured = false
    super
  end

  def []=(name, options)
    Rails.logger.warn "WARNING: INSECURE WRITING OF COOKIE FOR VALUE #{name}." unless @secured
    @secured = false
    super
  end  
end

module ActionDispatch
  class Cookies

    class CookieJar
    	prepend CookiePatch
    end

    class SignedCookieJar
      prepend SafeCookiePatch
    end

    class EncryptedCookieJar
      prepend SafeCookiePatch
    end

  end
end

