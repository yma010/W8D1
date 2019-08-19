require_relative "questionsDBconnection"

class QuestionLike

    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(target_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ?
        SQL
        QuestionLike.new(data.first)
    end

    def initialize(options)
        @id, @user_id, @question_id = options["id"], options["user_id"], options["question_id"]
    end

    def insert
        raise "#{self} already is in the database" if id
        QuestionsDBConnection.instance.execute(<<-SQL, user_id, question_id)
            INSERT INTO
                question_likes
            VALUES
                user_id = ?, question_id = ?
        SQL
        id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} is not in the database" unless id
        QuestionsDBConnection.instance.execute(<<-SQL, user_id, question_id, id)
            UPDATE
                question_likes
            SET
                user_id = ?, question_id = ?
            WHERE
                id = ?
        SQL
    end
end