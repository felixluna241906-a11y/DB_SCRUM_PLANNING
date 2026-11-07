from domain.entities.StatusModels import (
    StatusCreate,
    StatusUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class StatusRepository(BaseRepository):

    SP_NAME = "[SQM_CATALOGS].[USP_Status]"

    def insert_status(
        self,
        status: StatusCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_statusName = ?,
                @i_statusCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                status.statusName,
                creator_id
            )
        )

    def update_status(
        self,
        status: StatusUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_statusId = ?,
                @i_statusName = ?,
                @i_statusModificatorId = ?,
                @i_statusEnable = ?,
                @w_Accion = 'U'
            """,
            (
                status.statusId,
                status.statusName,
                modificator_id,
                status.statusEnable
            )
        )

    def list_status(
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