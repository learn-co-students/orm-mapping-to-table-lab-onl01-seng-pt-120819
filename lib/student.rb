
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

class Student

  attr_accessor :name, :grade
  attr_reader :id #responds to a getter for :id, does not provide a setter for :id
  
  def initialize(name, grade, id = nil) #the name attribute can be accessed, the grade attribute can be accessed
    @name = name 
    @grade = grade
    @id = id
  end

  def self.create_table #creates the students table in the database
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table #drops the students table from the database
    sql = "DROP TABLE students"   # You can write it as a direct string or heredoc
    
    DB[:conn].execute(sql)
  end
  
  def save #saves an instance of the Student class to the database
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #???
  end

  def self.create(name:, grade:) #takes in a hash of attributes and uses metaprogramming to create a new student object.
    student = Student.new(name, grade)
    student.save #uses the #save method to save that student to the database
    student #returns the new object that it instantiated
  end

end