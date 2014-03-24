require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'

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
    when 'e'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def list_projects
  puts "Here are all of your projects:"
  Project.all.each { |project| puts "\n*Project: #{project.name}"}
  puts "\nChoose a project to drill for further information, or press enter to return to the menu"
  user_choice = gets.chomp

  if user_choice != ""
    choice_project = Project.where({:name => user_choice}).first
    puts "\nProject: #{choice_project.name} \n => Employees: "
    choice_project.employees.each{ |employee| puts "\t#{employee.name}" }
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
  puts "You will need to assign an employee to this project."
  list_employees
  print "Choose the employee you would like to assign: "
  employee_name_choice = gets.chomp
  employee_choice = Employee.where({:name => employee_name_choice}).first
  puts "\n"
  new_project = employee_choice.projects.new({:name => project_name_choice})
  employee_choice.save
  puts "The project #{new_project.name} assigned to #{employee_choice.name} was successfully created."

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

welcome
