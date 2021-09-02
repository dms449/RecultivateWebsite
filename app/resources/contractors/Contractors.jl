module Contractors

using ContractorsValidator
using SHA
using SearchLight
import SearchLight: AbstractModel, DbId, Validation

import Base: @kwdef

export Contractor, contractors_sql

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
#
contractors_sql = "SELECT 
    contractors.id,
    contractors.pay_rate,
    contractors.person_id,
    persons.first,
    persons.last,
    contractors.group_id,
    groups.name AS group_name

  FROM contractors 
    LEFT JOIN  persons
      ON contractors.person_id = persons.id
    LEFT JOIN  groups
      ON contractors.group_id = groups.id
    "

end


