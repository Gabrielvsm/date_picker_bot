from sqlalchemy import exc
from db.init_db import engine
from sqlalchemy.orm import sessionmaker
from db.models import Chat

def __get_session():
    return sessionmaker(bind=engine)()

def add_chat(chat_id, title):
    session = __get_session()

    try:
        chat = Chat(chat_id, title)
        session.add(chat)
        session.commit()
        session.close()

        return True
    except:
        return False

def chat_exists(chat_id):
    with engine.connect() as con:
        chat = con.execute(f'''
            SELECT * FROM chats
            WHERE chat_id = {chat_id};
        ''')
        for row in chat:
            return row