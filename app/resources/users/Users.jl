module Users

using SearchLight, SearchLight.Validation, UsersValidator
using SHA

export User

Base.@kwdef mutable struct User <: AbstractModel
  ### FIELDS
  id::DbId = DbId()
  person_id::Int = DbId()
  username::String = ""
  password::String = ""
  imgpath::String = ""
end

Validation.validator(u::Type{User}) = ModelValidator([
  ValidationRule(:username, UsersValidator.not_empty),
  ValidationRule(:username, UsersValidator.unique),
  ValidationRule(:password, UsersValidator.not_empty)
  # ValidationRule(:email,    UsersValidator.not_empty),
  # ValidationRule(:email,    UsersValidator.unique),
  # ValidationRule(:name,     UsersValidator.not_empty)
])

function hash_password(password::String)
  sha256(password) |> bytes2hex
end

end
