module TimeRecords

import SearchLight: AbstractModel, DbId
import Base: @kwdef
import Dates: Date, today

export TimeRecord

@kwdef mutable struct TimeRecord <: AbstractModel
  id::DbId = DbId()
  type::Int = 0
  project_id::Int = 0
  contractor_id::Int = 0
  hours::Float32 = 0
  date::Date = today()
  notes::String = ""
end

end
