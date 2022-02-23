require_relative '../db/models/index'

def get_options(message)
    actv_list = Activity.list_from_chatid(message.chat.id)
    return 'no actv' if actv_list.length == 0

    actv_list.map! { |i| i['description'] }
    options_numbers = actv_list.map { |i| (actv_list.find_index(i) + 1).to_s }
    actv_list.shuffle!
    return actv_list, options_numbers if actv_list.length < 5

    middle_index = options_numbers.length % 2 == 0 ? options_numbers.length/2 - 1 : options_numbers.length/2
    return actv_list, [options_numbers[..middle_index], options_numbers[middle_index+1..]]
end

def catv(message)
    description = message.text[6..].downcase
    chat_id = message.chat.id
    unless Activity.exists?(description)
        actv = Activity.new description
        actv_id = actv.save
    else
        actv_id = Activity.find_by_description(description)
    end

    unless ChatActivity.exists?(actv_id, chat_id)
        chat_actv = ChatActivity.new(chat_id, actv_id)
        return chat_actv.save
    else
         return 'exists'
    end
end

def remove(message)
    actv = message.text[4..].downcase
    actv_id = Activity.find_by_description(actv)

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

