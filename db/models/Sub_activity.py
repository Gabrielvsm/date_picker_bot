from typing import Collection
from sqlalchemy import Column
from sqlalchemy.sql.schema import ForeignKey
from sqlalchemy.sql.sqltypes import Integer, String
from db.init_db import Base

class Sub_activity(Base):
    __tablename__ = 'sub_activities'

    id = Column(Integer, nullable=False, autoincrement=True, primary_key=True)
    description = Column(String, nullable=False)
    complement = Column(String, nullable=True)
    activity_id = Column(Integer, ForeignKey('activities.id'), nullable=False)

    def __init__(self, description, act_id):
        self.description = description
        self.activity_id = act_id
