

module Menu
	def menu
		" Welcome to the TodoList Program!
		This menu will help you use the Task List System
		1) Add task
		2) Show all tasks
		3) Update task
		4) Delete task
		5) Write to a file
		6) Read from a file
		7) Toggle task status
		Q) Quit "
	end

	def show
		return menu
	end
end

module Promptable
	def prompt(message="What would you like to do?", symbol=":> ")
		puts message
		print symbol
		return gets.chomp
	end
end

class List
	attr_reader :all_tasks

	def initialize
		@all_tasks = []
	end

	def add(task=nil)
		if task == nil
			puts "There's no task to add. Try again."
		elsif !task.is_a? Task
			puts "'#{task}' is not a Task."
		else
			all_tasks.push(task)
		end
	end

	def show
		return all_tasks.map.with_index { |task, i| "#{i.next}) #{task.to_machine}"}
	end

	def get_task(task_number=nil)
		#TODO: check to see if valid integer input
		if task_number == nil
			puts "Can't find a task without a task number. Try again."
		else
			return all_tasks[task_number.to_i - 1]
		end
	end

	def update(task, description=nil)
		if description == nil
			puts "Can't update a task without a description. No changes made."
		else
			task.description = description
			puts "New description: '#{task}'"
		end
	end

	def delete(task)
		description = task.description
		all_tasks.delete(task)
		puts "Deleted task: #{description}"
	end

	def write_to_file(filename=nil)
		if filename == nil
			puts "We need a filename. Try again."
		elsif filename.length < 1
			puts "The filename is too short, as in, a blank line. ''"
		else
			machinified = @all_tasks.map(&:to_machine).join("\n")
			IO.write(filename, machinified)
		end
	end

	def read_from_file(filename=nil)
		if filename == nil
			puts "We need a filename. Try again."
		elsif filename.length < 1
			puts "The filename is too short, as in, a blank line. ''"
		elsif !File.file?(filename)
			puts "'#{filename}' doesn't exist."
		else
			puts "Loading contents of '#{filename}':"
			IO.readlines(filename).each do |line|
				line = line.chomp
				puts line
				line = line.split(":")
				description = line[1]
				status = false
				if line[0] == "[X]"
					status = true
				end
				add(Task.new(description, status))
			end
		end
	end
end

class Task
	attr_accessor :description
	attr_accessor :status

	def initialize(description, status=false)
		@description = description
		@status = status
	end

	def completed?
		return status
	end

	def toggle_status
		@status = !completed?
	end

	private
	def represent_status
		if completed?
			return "[X]"
		else
			return "[ ]"
		end
	end

	public
	def to_machine
		return "#{represent_status}:#{description}"
	end

	public
	def to_s
		return description
	end
end

if __FILE__ == $PROGRAM_NAME
	include Menu
	include Promptable

	my_list = List.new
	puts "Please choose from the following list:"

	until ['q'].include?(user_input = prompt(show).downcase)
		case user_input
			when "1"
				my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
			when "2"
				puts my_list.show
			when "3"
				puts my_list.show
				task_number = prompt("What task number would you like to update?")
				task = my_list.get_task(task_number)
				description = prompt("What is the new description for this task?")
				my_list.update(task, description)
			when "4"
				puts my_list.show
				task_number = prompt("What task number would you like to delete?")
				task = my_list.get_task(task_number)
				my_list.delete(task)
			when "5"
				filename = prompt("What should the filename be?")
				my_list.write_to_file(filename)
			when "6"
				filename = prompt("What file do you want to read?")
				my_list.read_from_file(filename)
			when "7"
				puts my_list.show
				task_number = prompt("For what task number would you like to toggle status?")
				task = my_list.get_task(task_number)
				task.toggle_status
			else
				puts "Sorry, don't recognize that command. Try again."
			prompt('Press enter to continue', '')
		end
	end
	puts "Thanks for using the TodoList Program!"
end
