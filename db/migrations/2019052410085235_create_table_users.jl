module CreateTableUsers

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:users) do
    [
      primary_key()
      column(:person_id, :int)
      column(:username, :string, limit = 100)
      column(:password, :string, limit = 100)
      column(:imgpath, :string, limit = 100)
    ]
  end

  add_index(:users, :username)
  add_index(:users, :person_id)
end

function down()
  drop_table(:users)
end

end
