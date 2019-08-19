require_relative 'questionsDBconnection'

class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.title,
        questions.body,
        questions.author_id,
        questions.id
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questions.id)
      LIMIT ?
    SQL
    data.map {|hash| Question.new(hash)}
  end

  def self.followers_for_question_id(target_question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, target_question_id )
        SELECT
            users.id,
            users.fname,
            users.lname
        FROM
            users
        JOIN
            question_follows ON user_id = users.id
        WHERE
            question_id = ?
    SQL
    data.map {|dat| User.new(dat)}
  end

  def self.followed_questions_for_user_id(target_user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, target_user_id)
        SELECT
            questions.title,
            questions.body,
            questions.author_id
        FROM
            questions
        JOIN
            question_follows ON question_id = questions.id
        WHERE
            user_id = ?
    SQL
    data.map {|dat| Question.new(dat)}
  end

  def self.find_by_id(target_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, target_id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            id = ?
    SQL
    QuestionFollow.new(data.first)
  end

  def initialize(options)
    @id, @users_id, @question_id = options["id"], options["user_id"], options["question_id"]
  end

  def insert
    raise "#{self} already in database" if id
    QuestionsDBConnection.instance.execute(<<-SQL, question_id, user_id)
      INSERT INTO
        question_follows(question_id, user_id)
      VALUES
        (?, ?)
    SQL
    id = QuestionsDBConnection.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in Database" unless id
    QuestionsDBConnection.instance.execute(<<-SQL, question_id, user_id, id)
        UPDATE
            question_follows
        SET
            question_id = ?, user_id = ?
        WHERE
            id = ?
    SQL

  end
end
