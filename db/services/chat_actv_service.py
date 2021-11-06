from db.init_db import engine
from sqlalchemy.orm import sessionmaker
from db.models import Chat_activity

def chat_exists(chat_id):
    with engine.connect() as con:
        rows = con.execute(f'''
            SELECT * FROM chat_activity
            WHERE chat_id={chat_id};
        ''')
        for row in rows:
            return row

def add_chat_actv(chat_id, actv_id):
    session = sessionmaker(bind=engine)()

    try:
        chat_actv = Chat_activity(chat_id, actv_id)
        session.add(chat_actv)
        session.commit()
        session.close()

        return True
    except:
        return False

def listing(chat_id):
    result = []

    with engine.connect() as con:
        rows = con.execute(f'''
            SELECT description FROM activities, chat_activity
            WHERE activities.id=chat_activity.actv_id
        ''')
        for row in rows:
            result.append(row[0])

    return result