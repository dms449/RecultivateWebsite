module CreateTableLawncareevents

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:lawncareevents) do
    [
      primary_key()
      column(:date, :date)
      column(:lawncare_property_id, :int)
      column(:cost, :float)
      column(:hours, :float)
      column(:group_id, :int)
      column(:transaction_id, :int)
      column(:notes, :string, limit="300")
    ]
  end

  add_index(:lawncareevents, :lawncare_property_id)
end

function down()
  drop_table(:lawncareevents)
end

end
