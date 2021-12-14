require '../db/models/index'

def catv(message)
    description = message.text[6..].downcase
    chat_id = message.chat.id
    actv = Activity.new description
    res = actv.save
    # 'res' will be 'false' if activity allready exists
    unless res.class == FalseClass
        actv_id = res[0][0]
        chat_actv = ChatActivity.new(chat_id, actv_id)
        return chat_actv.save
    else
         return 'exists'
    end
end

def remove(message)
    actv = message.text[4..].downcase
    actv_id = Activity.find_by_description(actv)
    actv_id = actv_id[0][0] if actv_id

    actv_id ? ChatActivity.remove(message.chat.id, actv_id) : 'not found'
end

def list(message)
    actv_list = Activity.list_from_chatid(message.chat.id)
    resp_string = ""
    actv_list.each do |actv|
        resp_string << "▶️  #{actv['description'].capitalize}\n"
    end

    resp_string
end