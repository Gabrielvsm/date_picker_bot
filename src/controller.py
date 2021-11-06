from db.services import chat_service, activity_service, chat_actv_service

# Verifies if its a new chat conversation
def is_new(chat):
    return chat_service.chat_exists(chat.id)

# Registrates a new Chat on the database
def create_new(chat):
    chat_title = chat.username if chat.type == 'private' else chat.title
    return chat_service.add_chat(chat.id, chat_title)

# Creates a new activity and links it to a specific chat
def create_activity(msg):
    actv = msg.text[6:].title()
    actv_id = activity_service.add_activity(actv)
    return chat_actv_service.add_chat_actv(msg.chat.id, actv_id)

# Lists all the Activities linked to an specific Chat
def list_actvs(msg):
    if not chat_actv_service.chat_exists(msg.chat.id):
        return ''
    
    result = 'Lista de atividades ⤵️\n\n'
    actvs = chat_actv_service.listing(msg.chat.id)
    for actv in actvs:
        result += f'▶️ {actv}\n'

    return result

# Removes an Activity based on its description/name
def remove_actv(msg):
    description = msg.text[4:].title()
    actv_id = activity_service.get_id(description)
    chat_actv_service.remove(actv_id)

    return description