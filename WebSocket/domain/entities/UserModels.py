from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


class RolesBase(BaseModel):
    rolId: int
    rolName: str
    rolCreationDate: Optional[datetime] = None
    rolCreatorId: int
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: Optional[int] = None
    rolEnable: bool


class LtsRoles(BaseModel):
    roles: List[RolesBase]


class RolesCreate(BaseModel):
    rolName: str
    rolCreatorId: int
    rolCreationDate: Optional[datetime] = None


class RolesUpdate(BaseModel):
    rolId: int
    rolName: Optional[str] = None
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: int
    rolEnable: Optional[bool] = None