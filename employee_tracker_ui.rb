require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
require './lib/contribution'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def welcome
  puts "Welcome to your company's employee tracker!"
  menu
end

def menu
  choice = nil
  until choice == 'e'
    puts "Press 'a' to add a division, 'l' to list your divisions"
    puts "Press 'n' to add a new employee, 'v' to view all of your employees, 'ep' to see what projects an employee is working on"
    puts "Press 'p' to add a project, 'lp' to list all the projects"
    puts "Press 'pe' to add or remove an employee from an existing project"
    puts "Press 'e' to exit."
    choice = gets.chomp
    case choice
    when 'a'
      add_division
    when 'l'
      list_divisions
    when 'n'
      add_employee
    when 'v'
      list_employees
    when 'ep'
      employee_projects
    when 'p'
      add_project
    when 'lp'
      list_projects
    when 'pe'
      update_projects
    when 'e'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def list_projects
  puts "Here are all of your projects:"
  Project.all.each do |project|
    puts "\n*Project: #{project.name}\nEmployees: "
    project.employees.each { |employee| puts "\t#{employee.name} - Contribution: #{Contribution.where(:employee_id => employee.id, :project_id => project.id).first.contribution_desc}" }
  end
  puts "\n"
end

def add_division
  print "Enter the name of your new division: "
  new_name = gets.chomp
  puts "\n"

  new_division = Division.create({:name => new_name})
  puts "The #{new_division.name} division has been created."
end

def list_divisions
  divisions = Division.all
  divisions.each { |division| puts " #{division.name }" }
end

def add_employee
  list_divisions
  puts "Please enter the name of the division for this employee: "
  division_choice = gets.chomp
  new_division = Division.where({:name => division_choice}).first
  print "Please enter the name of the employee: "
  employee_choice = gets.chomp
  new_employee = new_division.employees.new({:name => employee_choice})
  new_division.save
  puts "#{new_employee.name} was added to #{new_division.name}"
end

def list_employees
  puts "Would you like to see all of the company's employees or list by division?
  Press 'a' to list all of the employess
  Press 'd' to list by division"
  case gets.chomp
  when 'a'
    puts "Here are all of your employees"
    Employee.all.each { |employee| puts "#{employee.division.name}: #{employee.name}" }
  when 'd'
    list_divisions
    print "Which division's employees would you like to see: "
    division_choice = gets.chomp
    new_division = Division.where({:name => division_choice}).first
    puts "Here are the employees in the #{new_division.name} division"
    new_division.employees.each { |employee| puts employee.name }
  end
end

def add_project
  print "Enter the project name: "
  project_name_choice = gets.chomp
  puts "\n"
  new_project = Project.create({:name => project_name_choice})

  puts "You will need to assign an employee to this project."
  add_employee_to_project(new_project)

  puts "The project #{new_project.name} was successfully created."
end

def add_employee_to_project(project)
  list_employees
  done_adding_employees = false

  until done_adding_employees
    print "Choose the employee you would like to assign or 'x' to finish: "
    employee_name_choice = gets.chomp
    if employee_name_choice == 'x'
      done_adding_employees = true
    else
      employee_choice = Employee.where({:name => employee_name_choice}).first
      puts "\nWhat is the employee's contribution to this project?"
      input_desc = gets.chomp
      project.contributions.create(:contribution_desc => input_desc, :employee_id => employee_choice.id)
    end
  end

  puts "The #{employee_choice.name} has been added to #{project.name}."

end

def employee_projects
  list_employees

  print "Choose an employee to view their projects: "
  choice_name = gets.chomp
  puts "\n"

  choice_employee = Employee.where({:name => choice_name}).first

  puts "The projects that #{choice_employee.name} is working on are: "
  choice_employee.projects.each { |project| puts "\t #{project.name}"}
  puts "\n"
end

def project_employees(project)
  puts "The employees working on #{project.name} are: "
  project.employees.each { |employee| puts "\t #{employee.name} - Contribution: #{Contribution.where(:employee_id => employee.id, :project_id => project.id).first.contribution_desc}"}
  puts "\n"
end

def update_projects
  list_projects
  puts "Enter the name of the project you want to update"
  user_choice = gets.chomp
  choice_project = Project.where(:name => user_choice).first
  project_employees(choice_project)

  puts "Press 'a' to add an employee, or 'r' to remove one"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_employee_to_project(choice_project)
  when 'r'
    puts "Enter the name of the employee you would like to remove from the project"
    employee_choice_name = gets.chomp
    employee_choice = Employee.where(:name => employee_choice_name).first
    choice_project.employees.delete(employee_choice)
  else
    puts "That was not a valid input. Please try again."
    update_projects
  end
  puts "The current employees on #{choice_project.name} are: "
  choice_project.employees.each { |employee| puts employee.name}
end



welcome
