from pydantic import BaseModel, ConfigDict, EmailStr
from typing import List, Optional, Any
from datetime import datetime


# Job Schemas
class JobBase(BaseModel):
    name: str
    description: Optional[str] = None
    salary: float


class JobCreate(JobBase):
    pass


class Job(JobBase):
    id: int

    model_config = ConfigDict(from_attributes=True)


# Transaction Schemas
class TransactionBase(BaseModel):
    amount: float
    description: str
    category: str


class TransactionCreate(TransactionBase):
    pass


class Transaction(TransactionBase):
    id: int
    user_id: int
    timestamp: datetime

    model_config = ConfigDict(from_attributes=True)


# Goal Schemas
class GoalBase(BaseModel):
    name: str
    target_amount: float
    current_amount: float = 0.0
    due_date: Optional[datetime] = None


class GoalCreate(GoalBase):
    pass


class Goal(GoalBase):
    id: int
    user_id: int

    model_config = ConfigDict(from_attributes=True)


# Game Schemas
class BudgetPlan(BaseModel):
    rent: float
    food: float
    entertainment: float
    savings: float
    user_id: int


class NextDayRequest(BaseModel):
    user_id: int


# User Schemas
class UserBase(BaseModel):
    username: str
    email: EmailStr


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int
    balance: float
    credit_score: int
    bonus_points: int
    current_game_day: int
    job: Optional[Job] = None
    transactions: List[Transaction] = []
    goals: List[Goal] = []
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# EducationCard Schemas
class EducationCardBase(BaseModel):
    question: str
    options: List[str]
    correct_answer: str
    explanation: str
    difficulty: str


class EducationCardCreate(EducationCardBase):
    pass


class EducationCard(EducationCardBase):
    id: int

    model_config = ConfigDict(from_attributes=True)


# GameEvent Schemas
class GameEventBase(BaseModel):
    name: str
    description: str
    effect: dict[str, Any]
    event_type: str


class GameEventCreate(GameEventBase):
    pass


class GameEvent(GameEventBase):
    id: int

    model_config = ConfigDict(from_attributes=True)


# Merch Schemas
class MerchBase(BaseModel):
    name: str
    description: Optional[str] = None
    price_bonus_points: int
    stock: int


class MerchCreate(MerchBase):
    pass


class Merch(MerchBase):
    id: int

    model_config = ConfigDict(from_attributes=True)


# Token Schemas
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None
