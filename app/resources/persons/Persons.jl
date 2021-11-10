module Persons

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Person

@kwdef mutable struct Person <: AbstractModel
  id::DbId = DbId()
  first::String = ""
  last::String = ""
  mi::String = ""
  email::String = ""
  phone::String = ""
  contact_preference::String = "email"
end

end
