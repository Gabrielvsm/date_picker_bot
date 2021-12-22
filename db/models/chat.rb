require 'sqlite3'
require_relative '../db'

class Chat
    def initialize(chat_id, title=nil)
        @chat_id = chat_id
        @title = title
    end

    def save()
        db.execute <<~SAVE
            INSERT INTO chat(chat_id, title)
            VALUES(#{@chat_id}, '#{@title}');
        SAVE
        db.close
    end

    def self.exists?(chat_id)
        id = db.execute "SELECT chat_id FROM chat WHERE chat_id=#{chat_id};"
        db.close

        not id.empty? and id[0]['chat_id'] == chat_id
    end
end
