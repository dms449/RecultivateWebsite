module Messages

import SearchLight: AbstractModel, DbId
import Base: @kwdef
import Dates: Date, today

export Message

@kwdef mutable struct Message <: AbstractModel
  id::DbId = DbId()
  person_id=0
  date::Date = today()
  first::String = ""
  mi::String = ""
  last::String = ""
  email::String = ""
  phone::String = ""
  contact_preference::String = "email"
  message::String = ""
  viewed::Bool = false

end

end
