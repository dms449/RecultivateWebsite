module CreateTablePersons

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:persons) do
    [
      primary_key()
      column(:first, :string, limit=30)
      column(:last, :string, limit=30)
      column(:mi, :string, limit=1)
      column(:email, :string, limit=30)
      column(:phone, :string, limit=14)
      column(:contact_preference, :string, limit=20)
    ]
  end

end

function down()
  drop_table(:persons)
end

end
