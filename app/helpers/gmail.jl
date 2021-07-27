using HTTP
using JSON
using Base64: base64encode, base64decode

using PyCall

py"""
from googleapiclient.discovery import build
from apiclient import errors
from httplib2 import Http
from email.mime.text import MIMEText
import base64
from google.oauth2 import service_account

# Email variables. Modify this!
EMAIL_FROM = 'noreply@lyfpedia.com'
EMAIL_TO = 'mark.zuckerber@facebook.com'
EMAIL_SUBJECT = 'Hello  from Lyfepedia!'
EMAIL_CONTENT = 'Hello, this is a test\nLyfepedia\nhttps://lyfepedia.com'

service = service_account_login()
# Call the Gmail API
message = create_message(EMAIL_FROM, EMAIL_TO, EMAIL_SUBJECT, EMAIL_CONTENT)
sent = send_message(service,'me', message)

def create_message(sender, to, subject, message_text):
  message = MIMEText(message_text)
  message['to'] = to
  message['from'] = sender
  message['subject'] = subject
  return {'raw': base64.urlsafe_b64encode(message.as_string())}

def send_message(service, user_id, message):
  try:
    message = (service.users().messages().send(userId=user_id, body=message)
               .execute())
    print('Message Id: %s' % message['id'])
    return message
  except errors.HttpError as error:
    print('An error occurred: %s' % error)

def service_account_login():
  SCOPES = ['https://www.googleapis.com/auth/gmail.send']
  SERVICE_ACCOUNT_FILE = 'service-key.json'

  credentials = service_account.Credentials.from_service_account_file(
          SERVICE_ACCOUNT_FILE, scopes=SCOPES)
  delegated_credentials = credentials.with_subject(EMAIL_FROM)
  service = build('gmail', 'v1', credentials=delegated_credentials)
  return service
"""

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

function authenticate()
  global credentials
  r = HTTP.get("https://accounts.google.com/o/oauth2/v2/auth?client_id=$(credentials["client_id"])&redirect_uri=&response_type=code&scope=https://mail.google.com/")

  # https://developers.google.com/identity/protocols/oauth2/web-server#httprest
end


# for testing purposes
test_msg = buildMsg("lawncare@recultivate.net", "testing testig", "hi there,\n this is Daniel \n bye")
