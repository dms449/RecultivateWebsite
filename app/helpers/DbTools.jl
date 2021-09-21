module DbTools 

using MySQL
using Dates
using DataFrames
import YAML

export lawncare_properties_query, last_record_query, properties_query, lawn_events_sql, contractors_query
export format_phone_string

function format_phone_string(phone_string::String)
  rs = r"^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$"
  # rs = r"^\s*((?<country>:\+)(?<area>(\d{1,3})))(?<exchange>[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4}))(?<subscriber>: *x(\d+))(?<ex>\s*)$"
  m = match(rs, phone_string)
  if m
    return "($(m[:2])) $(m[:3])-$(m[:4])"
  else 
    return Missing
  end
end



# ============================== Readers ===================================

lawncare_properties_query = "SELECT 
    lawncareproperties.id AS lawn_id,
    persons.id AS person_id,
    persons.first,
    persons.last,
    properties.id AS property_id,
    properties.address,
    properties.city,
    properties.acres,
    lawncareproperties.active,
    lawncareproperties.weeks_between_visits,
    lawncareproperties.cost,
    lawncareproperties.payment_method,
    lawncareproperties.group_id

  FROM lawncareproperties 
    INNER JOIN properties 
      ON lawncareproperties.property_id = properties.id
    CROSS JOIN persons
      ON properties.person_id = persons.id
  "
lawn_events_query = "SELECT 
    lawncareproperties.id AS lawn_id,
    persons.id AS person_id,
    persons.first,
    persons.last,
    properties.id AS property_id,
    properties.address,
    properties.city,
    properties.acres,
    lawncareproperties.active,
    lawncareproperties.weeks_between_visits,
    lawncareproperties.cost,
    lawncareproperties.payment_method,
    lawncareproperties.group_id,
    x.last_time_spent,
    x.last_visit

  FROM lawncareproperties 
    INNER JOIN properties 
      ON lawncareproperties.property_id = properties.id
    CROSS JOIN persons
      ON properties.person_id = persons.id
    LEFT JOIN 
      (SELECT  
        lawncare_property_id,
        hours AS last_time_spent,
        max(date) AS last_visit
      FROM lawncareevents 
        GROUP BY lawncare_property_id) AS x ON lawncareproperties.id = x.lawncare_property_id 
  "

properties_query = "SELECT 
    properties.id AS property_id,
    properties.address,
    properties.city,
    properties.state,
    properties.zip,
    properties.acres,
    persons.id AS person_id,
    persons.first,
    persons.last

  FROM properties 
    INNER JOIN persons 
      ON properties.person_id = persons.id
  "

last_record_query = "SELECT  
    lawncare_property_id,
    hours AS last_time_spent,
    max(date) AS last_visit
  FROM lawncareevents 
    GROUP BY lawncare_property_id
  "

contractors_query = "SELECT 
    contractors.id,
    contractors.user_id,
    contractors.pay_rate,
    contractors.group_id,
    persons.id as person_id,
    persons.first,
    persons.last,
    persons.email
  FROM contractors
    CROSS JOIN persons
      ON contractors.person_id = persons.id
"

active_lawncare_clients_query = "SELECT 
    persons.first,
    persons.last,
    persons.email
    persons.phone
    persons.contact_preference
    properties.address,
    properties.city,

  FROM lawncareproperties WHERE active=1
    INNER JOIN properties 
      ON lawncareproperties.property_id = properties.id
    CROSS JOIN persons
      ON properties.person_id = persons.id
  "

function db_init(config="db_setup.yml")
  # load the config 
  config = YAML.load_file(config)

  # connect to the database
   DBInterface.connect(MySQL.Connection, config["host"], config["user"], config["psw"], db=config["db"])
end

function lawncare_properties(conn)
  DBInterface.execute(conn, lawncare_properties_query) |> DataFrame
end


function properties_due(conn, group::Int=0)
  td = today()
  week_begin = td - Dates.Day(dayofweek(td)%7)
  week_end = week_begin + Dates.Day(6)

  lawn_prop_df = lawncareproperties(conn)
  lawn_records_df = DBInterface.execute(conn, last_record_query) |> DataFrame
  df = hcat(lawn_prop_df, lawn_records_df)

  df = df[df.active .== 1,:]
  df = df[((week_end.-df.last_visit) .÷ 7) .>= Dates.Day.(df.weeks_between_visits), :]
  return df

end

function send_properties_due(conn)
  contractors = DBInterface.execute(conn, contractors_query) |> DataFrame
  due = properties_due(conn)
  
  groups = Dict()
  for i in unique(df.group_id)
    d = Dict()
    d["msg"] = due[due.group_id .== i, [:first, :last, :address, :city]]
    d["emails"] = contractors[contractors.group_id .== i, :email]
    groups[i] = d
  end
  
end


# =============================== Modifiers ================================
# These functions modify the database


"""
Attempt to add a new client
"""
function add_client(first::String, last::String, phone::String, email::String; mi="NULL")
  formatted_phone = format_phone_string(phone)

  # add a new entry in the persons table
  DBInterface.execute("INSERT INTO persons (first, last, mi, email, phone) VALUES (NULL, '$first', '$last', $(mi=="NULL" ? mi : "'$mi'"), '$email', '$formatted_phone')")
  new_person_id = Int((DBInterface.execute(conn, "SELECT LAST_INSERT_ID() AS last_id") |>DataFrame).last_id[1])

  # add a new entry in the Client table as well
  DBInterface.execute(conn, "INSERT INTO Clients (id, person_id) VALUES (NULL, '$new_person_id')")
  return new_person_id
end

"""

"""
function add_property(person_id::Int, address::String, city::String, state::String, zip::String, acres::Float32)
  DBInterface.execute("INSERT INTO properties (id, person_id, address, city, state, zip, acres) VALUES (NULL, '$person_id', '$address', $city, '$state', '$zip', '$acres')")
  return Int((DBInterface.execute(conn, "SELECT LAST_INSERT_ID() AS last_id") |>DataFrame).last_id[1])
  
end

"""
"""
# function add_lawncare_property(conn, property_id::Int, weeks::Int; active::Int=1, deck_height::Float32=2.25, weedeat::Int=1, edge::Int=1, blow::Int=1)

#   DBInterface.execute("INSERT INTO lawncareproperties (id, property_id, active, weeks_between_visist, first_visit, group_id, deck_height, weedeat, edge, blow) VALUES (NULL, '$propery_id', '$active', '$weeks', '$first_visit', '$group_id', '$deck_height', '$weedeat', '$edge', '$blow')")

#   return Int((DBInterface.execute(conn, "SELECT LAST_INSERT_ID() AS last_id") |>DataFrame).last_id[1])
# end


function add_lawncare_record(conn, date::Date, lawncare_property_id::Int, cost::Float32, hours::Float32, con1_id, con2_id, con3_id)
  
  DBInterface.execute("INSERT INTO lawncareevents (id, date, lawncare_property_id, cost, hours, con1_id, con2_id, con3_id) VALUES (NULL, '$date', '$lawncare_property_id', '$cost', '$hourse', '$con1_id', '$con2_id', '$con3_id')")
end


end
