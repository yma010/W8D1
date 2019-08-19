require_relative "questionsDBconnection"
# require_relative 'users'
require_relative 'question_follows'
require_relative 'question_likes'
# require_relative 'replies'

class Question
    attr_accessor :title, :body, :author_id, :id

    def self.most_liked(n)
        QuestionLike.most_liked_questions(n)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

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

    def replies
        data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        data.map {|hash| Reply.new(hash)}
    end

    def author
        data = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        data.map {|hash| User.new(hash)}
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end

    def likers
        QuestionLike.likers_for_question_id(id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(id)
    end

  def save
    if id
      update
    else
      insert
    end
  end
end
