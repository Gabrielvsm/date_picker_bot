from sqlalchemy import Column
from sqlalchemy.sql.sqltypes import Integer, String
from db.init_db import Base

class Chat(Base):
    __tablename__ = 'chats'

    chat_id = Column(Integer, nullable=False, primary_key=True)
    title = Column(String, nullable=True)

    def __init__(self, chat_id, title):
        self.chat_id = chat_id
        self.title = title
