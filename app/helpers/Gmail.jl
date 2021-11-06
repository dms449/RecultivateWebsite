module Gmail
  using HTTP
  using JSON
  using Base64: base64encode, base64decode
  using SHA
  using JWTs
  using MbedTLS
  using Dates

  export buildEmail, sendEmail

  const API_ROOT = "https://www.googleapis.com"
  const SCOPE_ROOT = "$API_ROOT/auth"
  const AUD_ROOT = "$API_ROOT/oauth2/v4/token" 


  """
  """
  mutable struct GoogleSession
      credentials::String
      scopes::Vector{String}
      authorization::Dict{Symbol, Any}
      expiration::DateTime
      """
          GoogleSession(credentials, scopes)
      Set up session with credentials and OAuth scopes.
      """
      GoogleSession(credentials::String, scopes::AbstractVector{<: AbstractString}) = new(credentials, scopes, Dict{Symbol, Any}(), DateTime(1))
      
  end

  """

  """
  const GOOGLE_SESSION = GoogleSession("./config/service_account.json", ["https://mail.google.com"])

  function refresh!(session::GoogleSession)
    jwt = buildJWT(session.scopes, session.credentials)

    r = authorize(jwt) 
    if r.status != 200
      @warn "failed to get authorization for jwt"
      return
    end

    session.authorization = JSON.parse(HTTP.payload(r, String); dicttype=Dict{Symbol, Any})
    session.expiration = now() + Second(session.authorization[:expires_in] - 30)
  end

  function getAccessToken(session::GoogleSession)

    if session.expiration <= now() || isempty(session.authorization)
      refresh!(session)
    end

    return session.authorization[:access_token]
  end


  #jwt_combine(x::Dict...) = join(map(base64encode ∘ JSON.json, x), ".")

  #function authenticate(scope, service_account_file)

  #  service_account = JSON.parsefile(service_account_file)

  #  jwt_header = Dict("alg"=>"RS256","typ"=>"JWT")
  #iat = Int(floor(Dates.value(now())/1000))
  #  exp = iat + 3600
  #  jwt_claims = Dict(
  #                    "iss"=>service_account["client_email"],
  #                    "scope"=>scope,
  #                    "aud"=>service_account["auth_uri"],
  #                    "exp"=>exp,
  #                    "iat"=>iat
  #  )

  #  jwt_signature = sha256(jwt_combine(jwt_header, jwt_claims))

  #  jwt = jwt_combine(jwt_header, jwt_claims, jwt_signature)

  #  # r = HTTP.request(:POST, "https://oauth2.googleapis.com/token", body=) 
  #  #
  #  r = HTTP.post("https://accounts.google.com/o/oauth2/v2/auth?client_id=$(credentials["client_id"])&redirect_uri=&response_type=code&scope=https://mail.google.com/")


  #end


  # """
  # Build a Gmail message
  # """
  # function buildMsgDict(to::String, msg::String; subject::String="", from::String="lawncare@recultivate.net")

  #   # return "Content-Type: text/plain; charset=\"UTF-8\"\nFrom: $(from)\nTo: $(to)\nSubject: $(subject)\n\n$(msg)" 
  #   # # build the payload dict
  #   payload = Dict()
  #   payload["mimeType"] = "text/plain"
  #   payload["headers"] = [Dict("name"=>"To", "value"=>to),
  #                         Dict("name"=>"From", "value"=>from),
  #                         Dict("name"=>"Subject", "value"=>subject)
  #                       ]

  #   payload["body"] = Dict()
  #   payload["body"]["data"] = base64encode(msg)
  #   payload["body"]["size"] = length(base64decode(payload["body"]["data"]))
  #   payload["parts"] = []

  #   # # build the message
  #   msg = Dict()
  #   msg["payload"] = payload
  #   msg["raw"] = base64encode(HTTP.URIs.escapeuri(JSON.json(payload)))
  #   # msg["sizeEstimate"] = length(base64decode(msg["raw"]))


  #   return msg
  # end

  function buildEmail(to::String, msg::String; subject::String="", from::String="lawncare@recultivate.net")
    return "Content-Type: text/plain; charset=us-ascii\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nTo: $(to)\nFrom: $(from)\nSubject: $(subject)\n\n$(msg)" 
  end


  """
  Send a message 
  """
  function sendEmail(msg::String, access_token::String)

    headers = Dict{String, String}("Content-Type" => "application/json", "Authorization" => "Bearer $(access_token)")
    return HTTP.post("https://www.googleapis.com/gmail/v1/users/me/messages/send", headers, JSON.json(Dict("raw"=>base64encode(msg))))
  end

  """
  Send a message using the cached google session
  """
  function sendEmail(msg::String)
    println(GOOGLE_SESSION)
    sendEmail(msg, getAccessToken(GOOGLE_SESSION))
  end


  function buildJWT(scopes::Vector{String}, credentials="./config/service_account.json")

    service_account = JSON.parsefile(credentials)


    # trunc(Int, datetime2unix(x))
    n1 = Dates.datetime2unix(now(Dates.UTC))
    n2 = n1 + 3599
    jwt_claims = Dict(
                      "iss"=>service_account["client_email"],
                      "scope"=> join(scopes, " "),
                      "sub"=>"lawncare@recultivate.net",
                      "aud"=>service_account["token_uri"],
                      "exp"=>n2,
                      "iat"=>n1
    )
    jwt = JWT(; payload=jwt_claims)

    ctx = MbedTLS.PKContext()
    MbedTLS.parse_key!(ctx, service_account["private_key"])
    key = JWKRSA(MbedTLS.MD_SHA256, ctx)

    sign!(jwt, key)

    if !issigned(jwt)
      @warn "jwt failed to sign"
    end

    return jwt

  end


  function authorize(jwt::JWT)
    data = HTTP.URIs.escapeuri(Dict{Symbol, String}(
          :grant_type => "urn:ietf:params:oauth:grant-type:jwt-bearer",
          :assertion => "$jwt"
      ))
    headers = Dict{String, String}("Content-Type" => "application/x-www-form-urlencoded")

    r = HTTP.post("$AUD_ROOT", headers, data)
    return r
  end



end
