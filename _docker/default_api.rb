
dex = MyOIDCProvider::Worker.new(MyConfig::OIDC_PROVIDER_URI,
                                 MyConfig::OIDC_CLIENT_ID,
                                 MyConfig::OIDC_SECRET,
                                 MyConfig::OIDC_REDIRECT_URI)

def protected!(dex, path = "/")
  unless (session.has_key?(:secured) and session[:secured] and session.has_key?(:userinfo) )
    session[:origin] = path
    
    # redirect "/login", 303 ## enable this line if using the /login path,
    
    ## else the following code redirecting directly
    nonce = Kernel::srand.to_s
    session[:nonce] = nonce
    redirect dex.auth_uri(nonce), 303
  end
end

MyApp.add_route('GET', '/callback', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "callback_get", 
  "responseClass" => "void",
  "endpoint" => "/callback", 
  "notes" => "The callback endpoint from an OIDC server. e.g. /callback?code=xxxx&amp;state=xxxx ",
  "parameters" => [
    {
      "name" => "code",
      "description" => "",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "state",
      "description" => "",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  # the guts live here
  code = params[:code]
  nonce = session.delete(:nonce)
  ret =  dex.redirect(code, nonce)
  session[:userinfo] = ret.raw_attributes

  session[:secured] = true
  redirect(session.delete(:origin), 303) if session.has_key?(:origin)
  redirect("/", 303)
end


MyApp.add_route('GET', '/login', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "login_get", 
  "responseClass" => "void",
  "endpoint" => "/login", 
  "notes" => "The OIDC login entrypoint.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  erb :login
end


MyApp.add_route('POST', '/login', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "login_post", 
  "responseClass" => "void",
  "endpoint" => "/login", 
  "notes" => "OIDC login page",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  nonce = Kernel::srand.to_s
  session[:nonce] = nonce
  redirect dex.auth_uri(nonce), 303
end


MyApp.add_route('GET', '/logout', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "logout_get", 
  "responseClass" => "void",
  "endpoint" => "/logout", 
  "notes" => "The OIDC logout endpoint to clear the session object.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  session.clear
  redirect "/", 303
end


MyApp.add_route('GET', '/protected', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "protected_get", 
  "responseClass" => "void",
  "endpoint" => "/protected", 
  "notes" => "Protected contents only authenticated user can view.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  protected!(dex, '/protected')
  erb :protected
end


MyApp.add_route('GET', '/', {
  "resourcePath" => "/Default",
  "summary" => "",
  "nickname" => "root_get", 
  "responseClass" => "void",
  "endpoint" => "/", 
  "notes" => "The landing page.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here
  erb :main
end

