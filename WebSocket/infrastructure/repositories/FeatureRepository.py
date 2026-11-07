from domain.entities.FeatureModels import (
    FeatureCreate,
    FeatureUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class FeatureRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_Features]"

    def insert_feature(
        self,
        feature: FeatureCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_featureSummary = ?,
                @i_featureDescription = ?,
                @i_featuresAcceptanceCriteria = ?,
                @i_featureParentLink = ?,
                @i_featureOwner = ?,
                @i_featureStartDate = ?,
                @i_featureDueDate = ?,
                @i_featurePriority = ?,
                @i_featureCreatorId = ?,
                @i_featureStatus = ?,
                @w_Accion = 'I'
            """,
            (
                feature.featureSummary,
                feature.featureDescription,
                feature.featuresAcceptanceCriteria,
                feature.featureParentLink,
                feature.featureOwner,
                feature.featureStartDate,
                feature.featureDueDate,
                feature.featurePriority,
                creator_id,
                feature.featureStatus
            )
        )

    def update_feature(
        self,
        feature: FeatureUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_featureId = ?,
                @i_featureSummary = ?,
                @i_featureDescription = ?,
                @i_featuresAcceptanceCriteria = ?,
                @i_featureParentLink = ?,
                @i_featureOwner = ?,
                @i_featureStartDate = ?,
                @i_featureDueDate = ?,
                @i_featurePriority = ?,
                @i_featureModificatorId = ?,
                @i_featureStatus = ?,
                @w_Accion = 'U'
            """,
            (
                feature.featureId,
                feature.featureSummary,
                feature.featureDescription,
                feature.featuresAcceptanceCriteria,
                feature.featureParentLink,
                feature.featureOwner,
                feature.featureStartDate,
                feature.featureDueDate,
                feature.featurePriority,
                modificator_id,
                feature.featureStatus
            )
        )

    def list_features(
        self,
        page_number: int = 1,
        rows_per_page: int = 10
    ) -> QueryResult:

        return self.execute_query(
            f"""
            EXEC {self.SP_NAME}
                @i_PageNumber = ?,
                @i_RowsPerPage = ?,
                @w_Accion = 'S'
            """,
            (
                page_number,
                rows_per_page
            )
        )