module CreateTableProperties

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:properties) do
    [
      primary_key()
      column(:address, :string, limit=100)
      column(:city, :string, limit=50)
      column(:state, :string, limit=2)
      column(:zip, :string, limit=15)
      column(:person_id, :int)
      column(:acres, :float)
    ]
  end

  add_index(:properties, :person_id)
end

function down()
  drop_table(:properties)
end

end
