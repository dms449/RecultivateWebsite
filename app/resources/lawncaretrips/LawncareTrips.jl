module LawncareTrips

import SearchLight: AbstractModel, DbId
import Base: @kwdef
import Dates: Date, today

export LawncareTrip, recent_trips_sql

recent_trips_sql = "
    SELECT * FROM lawncaretrips
    WHERE `date` >= NOW() - INTERVAL 10 DAY
    "
@kwdef mutable struct LawncareTrip <: AbstractModel
  id::DbId = DbId()
  date::Date = today()
  hours::Float32 = 0
  group_id::Int = 0
end

end
