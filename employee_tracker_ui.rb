require 'active_record'
require './lib/employee'
require './lib/division'

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
    puts "Press 'n' to add a new employee, or 'v' to view all of your employees"
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
    when 'e'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
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
  puts "#{employee_choice} was added to #{new_division.name}"
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

welcome
