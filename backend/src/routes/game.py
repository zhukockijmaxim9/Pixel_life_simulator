from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import schemas, models
from ..database import get_db

router = APIRouter(
    prefix="/game",
    tags=["Game"],
    responses={404: {"description": "Not found"}},
)


@router.post("/budget", status_code=201)
async def create_monthly_budget(
    budget_plan: schemas.BudgetPlan, db: Session = Depends(get_db)
):
    """
    Sets the monthly budget plan for a user.
    This is the first step a player should take at the beginning of a game month.
    """
    # For now, we just accept the budget plan.
    # In a real scenario, we would save this to the database,
    # probably in a new 'budgets' table or attached to the user model.
    print(f"Received budget for user {budget_plan.user_id}: {budget_plan.model_dump_json()}")

    user = db.query(models.User).filter(models.User.id == budget_plan.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with id {budget_plan.user_id} not found")

    return {
        "message": "Budget plan received successfully",
        "user_id": budget_plan.user_id,
        "plan": {
            "rent": budget_plan.rent,
            "food": budget_plan.food,
            "entertainment": budget_plan.entertainment,
            "savings": budget_plan.savings,
        },
    }


@router.post("/next-day", response_model=schemas.User)
async def next_day(
    request: schemas.NextDayRequest, db: Session = Depends(get_db)
):
    """
    Advances the game by one day for the specified user.
    """
    user = db.query(models.User).filter(models.User.id == request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with id {request.user_id} not found")

    # --- CORE GAME LOGIC WILL GO HERE ---
    # 1. Increment day
    user.current_game_day += 1

    # 2. Daily income/expenses can be processed here.
    # 3. Random events can be triggered.
    # 4. Check for month-end (e.g., if user.current_game_day % 30 == 0)

    db.commit()
    db.refresh(user)

    return user
