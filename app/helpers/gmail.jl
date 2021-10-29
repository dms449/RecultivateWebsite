using HTTP
using JSON
using Base64: base64encode, base64decode
using SHA
using JWTs
using MbedTLS
using Dates


jwt_combine(x::Dict...) = join(map(base64encode ∘ JSON.json, x), ".")

function authenticate(scope, service_account_file)

  service_account = JSON.parsefile(service_account_file)

  jwt_header = Dict("alg"=>"RS256","typ"=>"JWT")

  iat = Int(floor(Dates.value(now())/1000))
  exp = iat + 3600
  jwt_claims = Dict(
                    "iss"=>service_account["client_email"],
                    "scope"=>scope,
                    "aud"=>service_account["auth_uri"],
                    "exp"=>exp,
                    "iat"=>iat
  )

  jwt_signature = sha256(jwt_combine(jwt_header, jwt_claims))

  jwt = jwt_combine(jwt_header, jwt_claims, jwt_signature)

  # r = HTTP.request(:POST, "https://oauth2.googleapis.com/token", body=) 
  r = HTTP.post("https://accounts.google.com/o/oauth2/v2/auth?client_id=$(credentials["client_id"])&redirect_uri=&response_type=code&scope=https://mail.google.com/")


end

"""
Build a Gmail message
"""
function buildMsg(to::String, subject::String, msg::String)

  # build the payload dict
  payload = Dict()
  payload["mimeType"] = "application/json"
  payload["headers"] = [Dict("name"=>"To", "value"=>to),
                        Dict("name"=>"From", "value"=>"lawncare@recultivate.net"),
                        Dict("name"=>"Subject", "value"=>subject)
                      ]

  payload["body"] = Dict()
  payload["body"]["data"] = base64encode(msg)
  payload["body"]["size"] = length(base64decode(payload["body"]["data"]))
  payload["parts"] = []

  # build the message
  msg = Dict()
  msg["payload"] = payload
  msg["raw"] = base64encode(JSON.json(payload))
  msg["sizeEstimate"] = length(base64decode(msg["raw"]))


  return msg
end

"""
Send a message 
"""
function sendMsg(msg::Dict)
  return HTTP.post("https://gmail.googleapis.com/upload/gmail/v1/users/me/messages/send", ["Content-Type" => "application/json"], JSON.json(msg))
end

# function authenticate()
#   global credentials
#   r = HTTP.get("https://accounts.google.com/o/oauth2/v2/auth?client_id=$(credentials["client_id"])&redirect_uri=&response_type=code&scope=https://mail.google.com/")

#   # https://developers.google.com/identity/protocols/oauth2/web-server#httprest
# end


function buildJWT(scope="https://mail.google.com", service_account_file="./config/service_account.json")

  service_account = JSON.parsefile(service_account_file)

  n1 = Dates.datetime2unix(now(Dates.UTC))
  n2 = n1 + 3599
  jwt_claims = Dict(
                    "iss"=>service_account["client_email"],
                    "scope"=>scope,
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

  # r = HTTP.request(:POST, "https://oauth2.googleapis.com/token", body="$jwt") 

  # return r

end

buildBody(jwt) = Dict(
                      "grant_type"=>"urn:ietf:params:oauth:grant-type:jwt-bearer",
                      "assertion"=>"$jwt"
                     )

function getToken(jwt::JWT) 
  body = Dict(
              "grant_type"=>"urn:ietf:params:oauth:grant-type:jwt-bearer",
              "assertion"=>"$jwt"
             )

  r = HTTP.post("https://oauth2.googleapis.com/token", [], JSON.json(body))
  
  if r.status_code != 200
    @warn "failed to get access token"
  end
  return 
end

all() = buildJWT ∘ buildBody ∘ requestToken









# test_msg = buildMsg("lawncare@recultivate.net", "testing testig", "hi there,\n this is Daniel \n bye")






