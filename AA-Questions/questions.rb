require_relative "questionsDBconnection"

class Question
    attr_accessor :title, :body, :author_id, :id

    def self.find_by_author_id(author_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        Question.new(data.first)
    end

    def self.find_by_id(target_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, target_id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        Question.new(data.first)
    end

    def initialize(options)
        @id, @title, @body, @author_id = options["id"], options["title"], options["body"], options["author_id"]
    end
    
    def insert
        raise "#{self} already in database" if id
        QuestionsDBConnection.instance.execute(<<-SQL, title, body, author_id)
            INSERT INTO
                questions(title, body, author_id)
            VALUES
                (?, ?, ?)
        SQL
        id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} not in database" unless id
        QuestionsDBConnection.instance.execute(<<-SQL, title, body, author_id, id)
            UPDATE
                questions
            SET
                title = ?, body = ?, author_id = ?
            WHERE
                id = ?
        SQL
    end

end