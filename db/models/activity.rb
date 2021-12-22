require 'sqlite3'
require_relative '../db'

class Activity
    def initialize(description)
        @description = description
    end

    def save()
        # Checks if activity allready exists
        row_id = Activity.find_by_description(@description)
        unless row_id
            begin
                db.execute 'INSERT INTO activity VALUES(?)', @description
                db.close

                return Activity.find_by_description(@description)
            rescue Exception => e  
                puts e.message  
                puts e.backtrace.inspect
            end
        else
            return false
        end
    end

    def self.find_by_description(description)
        row_id = db.execute "SELECT rowid FROM activity WHERE description='#{description}'"
        db.close
        row_id.empty? ? false : row_id[0]['rowid']
    end

    def self.list_from_chatid(chat_id)
        resp_id = db.execute <<~LIST_FCI
            SELECT activity.description
            FROM chat_activity
            JOIN activity
            ON chat_activity.actv_id=activity.rowid
            WHERE chat_activity.chat_id=#{chat_id};
        LIST_FCI
    end

    def self.exists?(description)
        id = db.execute "SELECT rowid, description FROM activity WHERE description='#{description}';"
        db.close
        
        not id.empty? and id[0]['description'] == description
    end
end
