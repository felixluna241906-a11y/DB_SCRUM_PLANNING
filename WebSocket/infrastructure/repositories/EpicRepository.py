from domain.entities.EpicModels import (
    EpicCreate,
    EpicUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class EpicRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_Epics]"

    def insert_epic(
        self,
        epic: EpicCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicParentLink = ?,
                @i_epicOwner = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicPriority = ?,
                @i_epicCreatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'I'
            """,
            (
                epic.epicName,
                epic.epicSummary,
                epic.epicDescription,
                epic.epicParentLink,
                epic.epicOwner,
                epic.epicStartDate,
                epic.epicDueDate,
                epic.epicPriority,
                creator_id,
                epic.epicStatus
            )
        )

    def update_epic(
        self,
        epic: EpicUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_epicId = ?,
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicParentLink = ?,
                @i_epicOwner = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicPriority = ?,
                @i_epicModificatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'U'
            """,
            (
                epic.epicId,
                epic.epicName,
                epic.epicSummary,
                epic.epicDescription,
                epic.epicParentLink,
                epic.epicOwner,
                epic.epicStartDate,
                epic.epicDueDate,
                epic.epicPriority,
                modificator_id,
                epic.epicStatus
            )
        )

    def list_epics(
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