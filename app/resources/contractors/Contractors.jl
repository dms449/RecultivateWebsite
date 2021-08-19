module Contractors

using ContractorsValidator
using SHA
using SearchLight
import SearchLight: AbstractModel, DbId, Validation

import Base: @kwdef

export Contractor

@kwdef mutable struct Contractor <: AbstractModel
  id::DbId = DbId()
  person_id::Int = 0
  group_id::Int = 0
  user_id::Int = 0
  pay_rate::Float32 = 0
end

# Validation.validator(u::Type{Contractor}) = ModelValidator([
#   ValidationRule(:username, UsersValidator.not_empty),
#   ValidationRule(:username, UsersValidator.unique),
#   ValidationRule(:password, UsersValidator.not_empty),
#  ])

# function set_password(Person, password)

end
