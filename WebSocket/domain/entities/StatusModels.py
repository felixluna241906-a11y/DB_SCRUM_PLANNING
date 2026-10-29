from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class StatusBase(BaseModel):
    statusId: int
    statusName: str
    statusCreationDate: Optional[datetime] = None
    statusCreatorId: int
    statusModificationDate: Optional[datetime] = None
    statusModificatorId: Optional[int] = None
    statusEnable: bool
    
class LtsStatus(BaseModel):
    status: List[StatusBase]
    
class StatusCreate(BaseModel):
    statusName: str
    statusCreatorId: int
    statusCreationDate: Optional[datetime] = None
    
class StatusUpdate(BaseModel):
    statusId: int
    statusName: Optional[str] = None
    statusModificatorId: int
    statusModificationDate: Optional[datetime] = None
    statusEnable: Optional[bool] = None