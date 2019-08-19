require_relative "questionsDBconnection"

class QuestionLike

    attr_accessor :id, :user_id, :question_id

    def self.most_liked_questions(n)
        data = QuestionsDBConnection.instance.execute(<<-SQL, n)
        SELECT
            questions.id,
            questions.title,
            questions.body,
            questions.author_id
        FROM
            questions
        JOIN
            question_likes
        ON
            questions.id = question_id
        GROUP BY
            questions.id
        ORDER BY
            COUNT(questions.id)
        LIMIT
            ?
        SQL
        data.map {|datum| Question.new(datum)}
    end

    def self.liked_questions_for_user_id(target_user_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_user_id)
            SELECT
                questions.id,
                questions.title,
                questions.body,
                questions.author_id
            FROM
                questions
            JOIN
                question_likes ON questions.id = question_id
            WHERE
                user_id = ?
        SQL
        data.map{|datum| Question.new(datum)}
    end

    def self.likers_for_question_id(target_question_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_question_id)
            SELECT
                users.id,
                users.fname,
                users.lname
            FROM
                users
            JOIN
                question_likes ON users.id = user_id
            WHERE
                question_id = ?
        SQL
        data.map {|hash| User.new(hash)}
    end

    def self.num_likes_for_question_id(target_question_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_question_id)
            SELECT
                COUNT(*) AS total
            FROM
                questions
            JOIN
                question_likes ON questions.id = question_id
            WHERE
                questions.id = ?
        SQL
        data.first['total']
    end

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
                question_likes(user_id, question_id)
            VALUES
                (?,?)
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