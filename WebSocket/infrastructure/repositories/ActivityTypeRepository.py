from domain.entities.ActivityTypeModels import (
    ActivityTypeCreate,
    ActivityTypeUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class ActivityTypeRepository(BaseRepository):

    SP_NAME = "[SQM_CATALOGS].[USP_ActivityTypes]"

    def insert_activity_type(
        self,
        activity_type: ActivityTypeCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_activityTypeName = ?,
                @i_activityTypeCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                activity_type.activityTypeName,
                creator_id
            )
        )

    def update_activity_type(
        self,
        activity_type: ActivityTypeUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_activityTypeId = ?,
                @i_activityTypeName = ?,
                @i_activityTypeModificatorId = ?,
                @i_activityTypeEnable = ?,
                @w_Accion = 'U'
            """,
            (
                activity_type.activityTypeId,
                activity_type.activityTypeName,
                modificator_id,
                activity_type.activityTypeEnable
            )
        )

    def list_activity_types(
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