module Groups

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Group

@kwdef mutable struct Group <: AbstractModel
  id::DbId = DbId()
  name::String = ""
  leader_id::Int = 0
end

end
