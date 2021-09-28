module Clients

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Client

@kwdef mutable struct Client <: AbstractModel
  id::DbId = DbId()
  person_id::Int = 0
end

clients_query = "SELECT 
    clients.id,
    persons.id AS person_id,
    persons.first,
    persons.last,

  FROM clients 
    LEFT JOIN  persons
      ON clients.person_id = persons.id
    "

end
