require_relative "questionsDBconnection"

class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def self.find_by_user_id(target_user_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        data.map { |hash| Reply.new(hash) }
    end

    def self.find_by_question_id(target_question_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        data.map {|hash| Reply.new(hash)}
    end

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
          replies(question_id, parent_reply_id, user_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL
      id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
      raise "#{self} is not in the database" unless id
      QuestionsDBConnection.instance.execute(<<-SQL, question_id, parent_reply_id, user_id, body, id)
          replies
        SET
          question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
        WHERE
          id = ?
      SQL
    end

    def author
      data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          users
        WHERE
          id = ?
      SQL
      User.new(data.first)
    end

    def question
      data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
        SELECT
          *
        FROM
          questions
        WHERE
          id = ?
      SQL
      Question.new(data.first)
    end

    def parent_reply
      data = QuestionsDBConnection.instance.execute(<<-SQL, parent_reply_id)
        SELECT
          *
        FROM
          replies
        WHERE
          id = ?
      SQL
      Reply.new(data.first)
    end

    def child_replies
      data = QuestionsDBConnection.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          replies
        WHERE
          parent_reply_id = ?
      SQL
      data.map {|hash| Reply.new(hash)}
    end

end