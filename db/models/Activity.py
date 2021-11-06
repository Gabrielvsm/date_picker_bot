from sqlalchemy import Column
from sqlalchemy.sql.sqltypes import Integer, String
from db.init_db import Base

class Activity(Base):
    __tablename__ = 'activities'

    id = Column(Integer, nullable=False, autoincrement=True, primary_key=True)
    description = Column(String, nullable=False)

    def __init__(self, description):
        self.description = description
