module CreateTableGroups

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:groups) do
    [
      primary_key()
      column(:column_name, :column_type)
    ]
  end

  add_index(:groups, :column_name)
end

function down()
  drop_table(:groups)
end

end
