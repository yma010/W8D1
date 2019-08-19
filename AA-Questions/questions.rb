require_relative "questionsDBconnection"

class Question
    attr_accessor :title, :body, :author_id

    def initialize(options)
        @title, @body, @author_id = options["title"], options["body"], options["author_id"]
    end
    




end