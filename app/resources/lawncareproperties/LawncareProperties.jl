module LawncareProperties

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export LawncareProperty

@kwdef mutable struct LawncareProperty <: AbstractModel
  id::DbId = DbId()
  property_id::Int = 0
  active::Bool = false
  weeks_between_visits::Int = 0
  group_id::Int = 0
  cost::Float32 = 0
  payment_method::String = "card"
  deck_height::Float32 = 0.0
  weedeat::Bool = true
  edge::Bool = true
  blow::Bool = true
end

end
