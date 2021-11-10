module CreateTableLawncaretrips

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:lawncaretrips) do
    [
      primary_key()
      column(:date, :date)
      column(:hours, :float)
      column(:group_id, :int)
    ]
  end

  add_index(:lawncaretrips, :id)
  add_index(:lawncaretrips, :date)
end

function down()
  drop_table(:lawncaretrips)
end

end
