module CreateTableLawncareproperties

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:lawncareproperties) do
    [
      primary_key()
      column(:property_id, :int)
      column(:active, :bool)
      column(:weeks_between_visits, :int)
      column(:group_id, :int)
      column(:cost, :float)
      column(:payment_method, :string, limit=15)
      column(:deck_height, :float)
      column(:weedeat, :bool)
      column(:edge, :bool)
      column(:blow, :bool)
    ]
  end

  add_index(:lawncareproperties, :property_id)
end

function down()
  drop_table(:lawncareproperties)
end

end
