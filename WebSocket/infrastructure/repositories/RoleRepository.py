from domain.entities.RoleModels import (
    RoleCreate,
    RoleUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class RoleRepository(BaseRepository):

    SP_NAME = "[SQM_SECURITY].[USP_Roles]"

    def insert_role(
        self,
        role: RoleCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_rolName = ?,
                @i_rolCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                role.rolName,
                creator_id
            )
        )

    def update_role(
        self,
        role: RoleUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_rolId = ?,
                @i_rolName = ?,
                @i_rolModificatorId = ?,
                @i_rolEnable = ?,
                @w_Accion = 'U'
            """,
            (
                role.rolId,
                role.rolName,
                modificator_id,
                role.rolEnable
            )
        )

    def list_roles(
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