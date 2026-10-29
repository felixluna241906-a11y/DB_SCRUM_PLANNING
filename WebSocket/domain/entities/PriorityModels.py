from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


class PriorityBase(BaseModel):
    priorityId: int
    priorityName: str
    priorityCreationDate: Optional[datetime] = None
    priorityCreatorId: int
    priorityModificationDate: Optional[datetime] = None
    priorityModificatorId: Optional[int] = None
    priorityEnable: bool


class LtsPriorities(BaseModel):
    priorities: List[PriorityBase]


class PriorityCreate(BaseModel):
    priorityName: str
    priorityCreatorId: int
    priorityCreationDate: Optional[datetime] = None


class PriorityUpdate(BaseModel):
    priorityId: int
    priorityName: Optional[str] = None
    priorityModificatorId: int
    priorityModificationDate: Optional[datetime] = None
    priorityEnable: Optional[bool] = None