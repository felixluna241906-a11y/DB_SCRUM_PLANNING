from domain.entities.InitiativeModels import (
    InitiativeCreate,
    InitiativeUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class InitiativeRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_Initiatives]"

    def insert_initiative(
        self,
        initiative: InitiativeCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_initiativeSummary = ?,
                @i_initiativeDescription = ?,
                @i_initiativeOwner = ?,
                @i_initiativeGoals = ?,
                @i_initiativeBusinessValue = ?,
                @i_initiativeTargetStart = ?,
                @i_initiativeTargetEnd = ?,
                @i_initiativeCreatorId = ?,
                @i_initiativeStatus = ?,
                @w_Accion = 'I'
            """,
            (
                initiative.initiativeSummary,
                initiative.initiativeDescription,
                initiative.initiativeOwner,
                initiative.initiativeGoals,
                initiative.initiativeBusinessValue,
                initiative.initiativeTargetStart,
                initiative.initiativeTargetEnd,
                creator_id,
                initiative.initiativeStatus
            )
        )

    def update_initiative(
        self,
        initiative: InitiativeUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_initiativeId = ?,
                @i_initiativeSummary = ?,
                @i_initiativeDescription = ?,
                @i_initiativeOwner = ?,
                @i_initiativeGoals = ?,
                @i_initiativeBusinessValue = ?,
                @i_initiativeTargetStart = ?,
                @i_initiativeTargetEnd = ?,
                @i_initiativeModificatorId = ?,
                @i_initiativeStatus = ?,
                @w_Accion = 'U'
            """,
            (
                initiative.initiativeId,
                initiative.initiativeSummary,
                initiative.initiativeDescription,
                initiative.initiativeOwner,
                initiative.initiativeGoals,
                initiative.initiativeBusinessValue,
                initiative.initiativeTargetStart,
                initiative.initiativeTargetEnd,
                modificator_id,
                initiative.initiativeStatus
            )
        )

    def list_initiatives(
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