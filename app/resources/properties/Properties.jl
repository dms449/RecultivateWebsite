module Properties

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Property

@kwdef mutable struct Property <: AbstractModel
  id::DbId = DbId()
  address::String = ""
  city::String = ""
  state::String = ""
  zip::String = ""
  person_id::Int = 0
  acres::Float32 = 0.0
end

end
