class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.column :name, :string
      t.column :employee_id, :integer

      t.timestamps
    end
  end
end
