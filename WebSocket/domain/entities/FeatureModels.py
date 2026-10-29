from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List


class FeatureBase(BaseModel):
    featureId: int
    featureSummary: str
    featureDescription: str
    featuresAcceptanceCriteria: str
    featureParentLink: int
    featureOwner: int
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featurePriority: Optional[int] = None
    featureCreationDate: Optional[datetime] = None
    featureCreatorId: int
    featureModificationDate: Optional[datetime] = None
    featureModificatorId: Optional[int] = None
    featureStatus: int


class LtsFeatures(BaseModel):
    features: List[FeatureBase]


class FeatureCreate(BaseModel):
    featureSummary: str
    featureDescription: str
    featuresAcceptanceCriteria: str
    featureParentLink: int
    featureOwner: int
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featurePriority: Optional[int] = None
    featureCreationDate: Optional[datetime] = None
    featureCreatorId: int
    featureStatus: int


class FeatureUpdate(BaseModel):
    featureId: int
    featureSummary: Optional[str] = None
    featureDescription: Optional[str] = None
    featuresAcceptanceCriteria: Optional[str] = None
    featureParentLink: Optional[int] = None
    featureOwner: Optional[int] = None
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featurePriority: Optional[int] = None
    featureModificationDate: Optional[datetime] = None
    featureModificatorId: int
    featureStatus: Optional[int] = None