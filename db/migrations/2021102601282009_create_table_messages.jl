module CreateTableMessages

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:messages) do
    [
      primary_key()
      column(:date, :date)
      column(:person_id, :int)
      column(:first, :string, limit=30)
      column(:last, :string, limit=30)
      column(:mi, :string, limit=1)
      column(:email, :string, limit=30)
      column(:phone, :string, limit=14)
      column(:contact_preference, :string, limit=20)
      column(:message, :string, limit=1000)
      column(:viewed, :bool)
    ]
  end

  add_index(:messages, :date)
  add_index(:messages, :viewed)
  add_index(:messages, :first)
  add_index(:messages, :last)
end

function down()
  drop_table(:messages)
end

end
