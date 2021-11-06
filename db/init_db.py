from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from db.config import DB_URI

engine = create_engine(DB_URI)

Base = declarative_base()
