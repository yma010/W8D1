require_relative 'questionsDBconnection'

class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(target_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, target_id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
    SQL
    QuestionFollow.new(data.first)
  end

  def initialize(options)
    @id, @user_id, @question_id = options["id"], options["user_id"], options["question_id"]
  end

  def insert
    raise "#{self} already in database" if id
    QuestionDBConnection.instance.execute(<<-SQL, question_id, user_id)
      INSERT INTO
        question_follows
      VALUES
        (?, ?)
    SQL
    id = QuestionsDBConnection.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in Database" unless id
    QuestionDBConnection.instance.execute(<<-SQL, question_id, user_id, id)
        UPDATE
            question_follows
        SET
            question_id = ?, user_id = ?
        WHERE
            id = ?
    SQL

  end
end
