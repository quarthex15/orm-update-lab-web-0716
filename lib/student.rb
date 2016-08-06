require_relative "../config/environment.rb"

class Student

attr_accessor :name, :grade, :id


  def initialize(name, grade)
    @id = nil
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if @id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, @name, @grade)

      sql = <<-SQL
        SELECT last_insert_rowid()
      SQL
      @id = DB[:conn].execute(sql)[0][0]
    end
  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1],row[2])
    new_student.id = row[0]
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL

    new_from_db(DB[:conn].execute(sql,name)[0])
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, @name, @grade, @id)
  end


end






