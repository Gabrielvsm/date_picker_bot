from db.init_db import engine
from sqlalchemy.orm import sessionmaker
from db.models import Activity

def add_activity(description):
    session = sessionmaker(bind=engine)()

    actv = Activity(description)
    session.add(actv)
    session.commit()
    session.close()

    with engine.connect() as con:
        rows = con.execute(f'''
            SELECT id FROM activities
            WHERE description='{description}'
        ''')

        for row in rows:
            return row