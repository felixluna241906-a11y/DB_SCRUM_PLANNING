from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List


class EpicBase(BaseModel):
    epicId: int
    epicName: str
    epicSummary: str
    epicDescription: str
    epicParentLink: int
    epicOwner: int
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicCreationDate: Optional[datetime] = None
    epicCreatorId: int
    epicModificationDate: Optional[datetime] = None
    epicModificatorId: Optional[int] = None
    epicStatus: int


class LtsEpics(BaseModel):
    epics: List[EpicBase]


class EpicCreate(BaseModel):
    epicName: str
    epicSummary: str
    epicDescription: str
    epicParentLink: int
    epicOwner: int
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicCreatorId: int
    epicStatus: int
    epicCreationDate: Optional[datetime] = None


class EpicUpdate(BaseModel):
    epicId: int
    epicName: Optional[str] = None
    epicSummary: Optional[str] = None
    epicDescription: Optional[str] = None
    epicParentLink: Optional[int] = None
    epicOwner: Optional[int] = None
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicPriority: Optional[int] = None
    epicModificatorId: int
    epicModificationDate: Optional[datetime] = None
    epicStatus: Optional[int] = None