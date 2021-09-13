
class MyConfig
  def MyConfig.getenv(e = "", default = "")
    ret = default
    ret = ENV[e] if ENV.has_key?(e)
    return ret
  end
  
  OIDC_PROVIDER_URI = getenv("OIDC_PROVIDER_URI", "https://example.com/dex")
  OIDC_CLIENT_ID = getenv("OIDC_CLIENT_ID", "oidc-client-id")
  OIDC_SECRET = getenv("OIDC_SECRET", "be452b955ccaa16d4ec9633b73295a97")
  OIDC_REDIRECT_URI = getenv("OIDC_REDIRECT_URI", "http://localhost:8080/callback")
  REDIS_URI = getenv("REDIS_URI", "redis://localhost:6379/0")
end
