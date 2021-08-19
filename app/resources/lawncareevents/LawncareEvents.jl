module LawncareEvents

import SearchLight: AbstractModel, DbId
import Base: @kwdef
import Dates: Date, today

export LawncareEvent

@kwdef mutable struct LawncareEvent <: AbstractModel
  id::DbId = DbId()
  date::Date = today()
  lawncare_property_id::Int = 0
  cost::Float32 = 0
  hours::Float32 = 0
  group_id::Int = 0
  transaction_id::Int = 0
  notes::String = ""
end

end
