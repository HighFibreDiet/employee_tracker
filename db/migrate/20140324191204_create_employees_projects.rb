class CreateEmployeesProjects < ActiveRecord::Migration
  def change
    create_table :employees_projects do |t|
      t.belongs_to :project
      t.belongs_to :employee
    end
    remove_column :projects, :employee_id, :integer
  end
end
