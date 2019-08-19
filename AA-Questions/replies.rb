require_relative "questionsDBconnection"

class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def self.find_by_id(target_id)
      data = QuestionsDBConnection.instance.execute(<<-SQL, target_id)
        SELECT
          *
        FROM
          replies
        WHERE
          id = ?
      SQL
      Reply.new(data.first)
    end

    def initialize(options)
        @id, @question_id, @parent_reply_id, @user_id, @body = options["id"], options["question_id"], options["parent_reply_id"], options["user_id"], options["body"]
    end

    def insert
      raise "#{self} is already in the database}" if id
      QuestionsDBConnection.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body)
        INSERT INTO
          replies
        VALUES
          (?, ?, ?, ?)
      SQL
      id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
      raise "#{self} is not in the database" unless id
      QuestionsDBConnection.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body, id)
        UPDATE
          replies
        SET
          question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
        WHERE
          id = ?
      SQL
    end

end