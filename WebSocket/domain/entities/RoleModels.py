from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


class RoleBase(BaseModel):
    rolId: int
    rolName: str
    rolCreationDate: Optional[datetime] = None
    rolCreatorId: int
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: Optional[int] = None
    rolEnable: bool


class LtsRoles(BaseModel):
    roles: List[RoleBase]


class RoleCreate(BaseModel):
    rolName: str
    rolCreatorId: int
    rolCreationDate: Optional[datetime] = None


class RoleUpdate(BaseModel):
    rolId: int
    rolName: Optional[str] = None
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: int
    rolEnable: Optional[bool] = None