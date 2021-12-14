require 'sqlite3'
require_relative '../db'

class ChatActivity
    def initialize(chat_id, actv_id)
        @chat_id = chat_id
        @actv_id = actv_id
    end

    def save
        begin
            db.execute <<~SAVE
                INSERT INTO chat_activity(chat_id, actv_id)
                VALUES(#{@chat_id}, #{@actv_id});
            SAVE
            db.close
        rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect
            return false
        end
        return true
    end

    def self.remove(chat_id, actv_id)
        begin
            db.execute <<~DEL
                DELETE FROM chat_activity
                WHERE chat_id=#{chat_id}
                AND actv_id=#{actv_id};
            DEL
            db.close
        rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect
            return false
        end
        return true
    end
end
