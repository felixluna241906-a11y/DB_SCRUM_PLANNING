from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


class TaskCommentBase(BaseModel):
    taskCommentId: int
    taskCommentParentLink: int
    taskCommentOwner: int
    taskCommentText: str
    taskCommentCreationDate: Optional[datetime] = None
    taskCommentCreatorId: int
    taskCommentModificationDate: Optional[datetime] = None
    taskCommentModificatorId: Optional[int] = None
    taskCommentStatus: bool


class LtsTaskComments(BaseModel):
    taskComments: List[TaskCommentBase]


class TaskCommentCreate(BaseModel):
    taskCommentParentLink: int
    taskCommentOwner: int
    taskCommentText: str
    taskCommentCreationDate: Optional[datetime] = None
    taskCommentCreatorId: int
    taskCommentStatus: Optional[bool] = True


class TaskCommentUpdate(BaseModel):
    taskCommentId: int
    taskCommentParentLink: Optional[int] = None
    taskCommentOwner: Optional[int] = None
    taskCommentText: Optional[str] = None
    taskCommentModificationDate: Optional[datetime] = None
    taskCommentModificatorId: int
    taskCommentStatus: Optional[bool] = None