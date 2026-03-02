import datetime
from sqlalchemy import (
    create_engine,
    Column,
    Integer,
    String,
    Float,
    DateTime,
    ForeignKey,
    JSON,
    Text,
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

Base = declarative_base()


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)

    balance = Column(Float, default=5000.0)
    credit_score = Column(Integer, default=500)
    bonus_points = Column(Integer, default=0)
    current_game_day = Column(Integer, default=1)

    job_id = Column(Integer, ForeignKey("jobs.id"), nullable=True)
    job = relationship("Job")

    transactions = relationship("Transaction", back_populates="user")
    goals = relationship("Goal", back_populates="user")

    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )


class Job(Base):
    __tablename__ = "jobs"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    description = Column(Text, nullable=True)
    salary = Column(Float, nullable=False)


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    user = relationship("User", back_populates="transactions")

    amount = Column(Float, nullable=False)
    description = Column(String, nullable=False)
    category = Column(String, index=True)
    timestamp = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )


class Goal(Base):
    __tablename__ = "goals"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    user = relationship("User", back_populates="goals")

    name = Column(String, nullable=False)
    target_amount = Column(Float, nullable=False)
    current_amount = Column(Float, default=0.0)
    due_date = Column(DateTime(timezone=True), nullable=True)


class EducationCard(Base):
    __tablename__ = "education_cards"

    id = Column(Integer, primary_key=True, index=True)
    question = Column(Text, nullable=False)
    options = Column(JSON, nullable=False)  # List of strings
    correct_answer = Column(String, nullable=False)
    explanation = Column(Text, nullable=False)
    difficulty = Column(String, default="medium")


class GameEvent(Base):
    __tablename__ = "game_events"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    # Example: {"type": "expense", "amount": 500} or {"type": "income", "amount": 100}
    effect = Column(JSON, nullable=False)
    event_type = Column(String, nullable=False)  # 'positive', 'negative', 'neutral'


class Merch(Base):
    __tablename__ = "merch_items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    price_bonus_points = Column(Integer, nullable=False)
    stock = Column(Integer, default=0)

