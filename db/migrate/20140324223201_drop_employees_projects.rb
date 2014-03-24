class DropEmployeesProjects < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.belongs_to :project
      t.belongs_to :employee
      t.column :contribution_desc, :string
      t.timestamps
    end
    drop_table :employees_projects
  end
end

