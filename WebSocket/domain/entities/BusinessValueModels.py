from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class BusinessValueBase(BaseModel):
    businessValueId: int
    businessValueName: str
    businessValueCreationDate: Optional[datetime] = None
    businessValueCreatorId: int
    businessValueModificationDate: Optional[datetime] = None
    businessValueModificatorId: Optional[int] = None
    businessValueEnable: bool


class LtsBusinessValues(BaseModel):
    businessValues: List[BusinessValueBase]


class BusinessValueCreate(BaseModel):
    businessValueName: str
    businessValueCreatorId: int
    businessValueCreationDate: Optional[datetime] = None


class BusinessValueUpdate(BaseModel):
    businessValueId: int
    businessValueName: Optional[str] = None
    businessValueModificatorId: int
    businessValueModificationDate: Optional[datetime] = None
    businessValueEnable: Optional[bool] = None