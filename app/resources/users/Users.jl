module Users

using SearchLight, SearchLight.Validation, UsersValidator
using SHA

export User

Base.@kwdef mutable struct User <: AbstractModel
  ### FIELDS
  id::DbId = DbId()
  username::String = ""
  password::String = ""
  account_type::Int = 0
  person_id::Int = 0
end

Validation.validator(u::Type{User}) = ModelValidator([
  ValidationRule(:username, UsersValidator.not_empty),
  ValidationRule(:username, UsersValidator.unique),
  ValidationRule(:password, UsersValidator.not_empty)
  # ValidationRule(:user_type,UsersValidator.valid_type)
])

function hash_password(password::String)
  sha256(password) |> bytes2hex
end

end
