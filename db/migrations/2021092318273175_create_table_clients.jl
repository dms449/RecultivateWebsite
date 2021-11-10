module CreateTableClients

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:clients) do
    [
      primary_key()
      column(:person_id, :int)
    ]
  end

  # add_index(:clients, :column_name)
end

function down()
  drop_table(:clients)
end

end
