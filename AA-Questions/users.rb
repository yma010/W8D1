require_relative 'questionsDBconnection'

class User
  attr_accessor :fname, :lname, :id

  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND
        lname = ?
    SQL
    User.new(data.first)
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(data.first)
  end

  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end

  def insert
    raise "#{self} already in database" if @id
    QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
    INSERT INTO
        users(fname, lname)
    VALUES
        (?, ?)
    SQL
    id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless id
    QuestionsDBConnection.instance.execute(<<-SQL, fname, lname, id)
    UPDATE
        users
    SET
        fname = ?, lname = ?
    WHERE
        id = ?
    SQL
  end


  def authored_questions
  end


end