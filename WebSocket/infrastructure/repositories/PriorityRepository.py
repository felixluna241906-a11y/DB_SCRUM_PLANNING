from domain.entities.PriorityModels import (
    PriorityCreate,
    PriorityUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class PriorityRepository(BaseRepository):

    SP_NAME = "[SQM_CATALOGS].[USP_Priorities]"

    def insert_priority(
        self,
        priority: PriorityCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_priorityName = ?,
                @i_priorityCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                priority.priorityName,
                creator_id
            )
        )

    def update_priority(
        self,
        priority: PriorityUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_priorityId = ?,
                @i_priorityName = ?,
                @i_priorityModificatorId = ?,
                @i_priorityEnable = ?,
                @w_Accion = 'U'
            """,
            (
                priority.priorityId,
                priority.priorityName,
                modificator_id,
                priority.priorityEnable
            )
        )

    def list_priorities(
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