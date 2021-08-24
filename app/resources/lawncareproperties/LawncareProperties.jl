module LawncareProperties

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export LawncareProperty
export PaymentMethods

@enum PaymentMethods card=1 cash=2 check=3

@kwdef mutable struct LawncareProperty <: AbstractModel
  id::DbId = DbId()
  property_id::Int = 0
  active::Bool = true
  weeks_between_visits::Int = 1
  group_id::Int = 0
  cost::Float32 = 0
  payment_method::String = "card"
  deck_height::Float32 = 0.25
  weedeat::Bool = true
  edge::Bool = true
  blow::Bool = true
end

end
