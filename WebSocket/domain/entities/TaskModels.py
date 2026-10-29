from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List


class TaskBase(BaseModel):
    taskId: int
    taskSummary: str
    taskDescription: str
    taskOwner: int
    taskParentLink: int
    taskOriginalEstimate: Optional[float] = None
    taskCompletedWork: Optional[float] = None
    taskRemaningWork: Optional[float] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskCreationDate: Optional[datetime] = None
    taskCreatorId: int
    taskModificationDate: Optional[datetime] = None
    taskModificatorId: Optional[int] = None
    taskStatus: int


class LtsTasks(BaseModel):
    tasks: List[TaskBase]


class TaskCreate(BaseModel):
    taskSummary: str
    taskDescription: str
    taskOwner: int
    taskParentLink: int
    taskOriginalEstimate: Optional[float] = None
    taskCompletedWork: Optional[float] = None
    taskRemaningWork: Optional[float] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskCreationDate: Optional[datetime] = None
    taskCreatorId: int
    taskStatus: int


class TaskUpdate(BaseModel):
    taskId: int
    taskSummary: Optional[str] = None
    taskDescription: Optional[str] = None
    taskOwner: Optional[int] = None
    taskParentLink: Optional[int] = None
    taskOriginalEstimate: Optional[float] = None
    taskCompletedWork: Optional[float] = None
    taskRemaningWork: Optional[float] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskModificationDate: Optional[datetime] = None
    taskModificatorId: int
    taskStatus: Optional[int] = None