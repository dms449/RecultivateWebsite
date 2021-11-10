module CreateTableTimerecords

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:timerecords) do
    [
      primary_key()
      column(:type, :int)
      column(:project_id, :int)
      column(:contractor_id, :int)
      column(:hours, :float)
      column(:date, :date)
      column(:notes, :string, limit=300)
    ]
  end

end

function down()
  drop_table(:timerecords)
end

end
