module CreateTableGroups

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:groups) do
    [
      primary_key()
      column(:name, :string, limit=25)
      column(:leader_id, :int)
    ]
  end

  add_index(:groups, :name)
end

function down()
  drop_table(:groups)
end

end
