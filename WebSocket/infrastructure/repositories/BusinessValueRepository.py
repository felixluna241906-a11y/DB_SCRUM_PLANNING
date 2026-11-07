from domain.entities.BusinessValueModels import (
    BusinessValueCreate,
    BusinessValueUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class BusinessValueRepository(BaseRepository):

    SP_NAME = "[SQM_CATALOGS].[USP_BusinessValues]"

    def insert_business_value(
        self,
        business_value: BusinessValueCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_businessValueName = ?,
                @i_businessValueCreatorId = ?,
                @w_Accion = 'I'
            """,
            (
                business_value.businessValueName,
                creator_id
            )
        )

    def update_business_value(
        self,
        business_value: BusinessValueUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_businessValueId = ?,
                @i_businessValueName = ?,
                @i_businessValueModificatorId = ?,
                @i_businessValueEnable = ?,
                @w_Accion = 'U'
            """,
            (
                business_value.businessValueId,
                business_value.businessValueName,
                modificator_id,
                business_value.businessValueEnable
            )
        )

    def list_business_values(
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