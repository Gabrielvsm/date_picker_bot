from sqlalchemy import Column
from sqlalchemy.sql.schema import ForeignKey
from sqlalchemy.sql.sqltypes import Integer
from db.init_db import Base

class Chat_activity(Base):
    __tablename__ = 'chat_activity'

    id = Column(Integer, nullable=False, autoincrement=True, primary_key=True)
    chat_id = Column(Integer, ForeignKey('chats.chat_id'), nullable=False)
    actv_id = Column(Integer, ForeignKey('activities.id'), nullable=False)

    def __init__(self, chat_id, actv_id):
        self.chat_id = chat_id
        self.actv_id = actv_id