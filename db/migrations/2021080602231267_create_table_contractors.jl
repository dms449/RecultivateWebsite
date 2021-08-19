module CreateTableContractors

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:contractors) do
    [
      primary_key()
      column(:person_id, :int)
      column(:group_id, :int)
      column(:user_id, :int)
      column(:pay_rate, :float)
    ]
  end

  # add_index(:contractors, :person_id)
  # add_index(:contractors, :user_id)
end

function down()
  drop_table(:contractors)
end

end
