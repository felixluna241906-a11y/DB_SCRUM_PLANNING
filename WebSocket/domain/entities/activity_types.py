from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class ActivityTypeBase(BaseModel):
    activityTypeId: int
    activityTypeName: str
    activityTypeCreationDate: Optional[datetime] = None
    activityTypeCreatorId: int
    activityTypeModificationDate: Optional[datetime] = None
    activityTypeModificatorId: Optional[int] = None
    activityTypeEnable: bool


class LtsActivityTypes(BaseModel):
    activityTypes: List[ActivityTypeBase]


class ActivityTypeCreate(BaseModel):
    activityTypeName: str
    activityTypeCreatorId: int
    activityTypeCreationDate: Optional[datetime] = None


class ActivityTypeUpdate(BaseModel):
    activityTypeId: int
    activityTypeName: Optional[str] = None
    activityTypeModificatorId: int
    activityTypeModificationDate: Optional[datetime] = None
    activityTypeEnable: Optional[bool] = None