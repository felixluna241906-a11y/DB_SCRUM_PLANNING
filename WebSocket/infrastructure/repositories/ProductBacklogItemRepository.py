from domain.entities.ProductBacklogItemModels import (
    ProductBacklogItemCreate,
    ProductBacklogItemUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class ProductBacklogItemRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_ProductBacklogItems]"

    def insert_product_backlog_item(
        self,
        pbi: ProductBacklogItemCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_PBISummary = ?,
                @i_PBIDescription = ?,
                @i_PBIsAcceptanceCriteria = ?,
                @i_PBIOwner = ?,
                @i_PBIParentLink = ?,
                @i_PBIStoryPoint = ?,
                @i_PBIStartDate = ?,
                @i_PBIDueDate = ?,
                @i_PBIPriority = ?,
                @i_PBICreatorId = ?,
                @i_PBIStatus = ?,
                @w_Accion = 'I'
            """,
            (
                pbi.PBISummary,
                pbi.PBIDescription,
                pbi.PBIsAcceptanceCriteria,
                pbi.PBIOwner,
                pbi.PBIParentLink,
                pbi.PBIStoryPoint,
                pbi.PBIStartDate,
                pbi.PBIDueDate,
                pbi.PBIPriority,
                creator_id,
                pbi.PBIStatus
            )
        )

    def update_product_backlog_item(
        self,
        pbi: ProductBacklogItemUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_PBIId = ?,
                @i_PBISummary = ?,
                @i_PBIDescription = ?,
                @i_PBIsAcceptanceCriteria = ?,
                @i_PBIOwner = ?,
                @i_PBIParentLink = ?,
                @i_PBIStoryPoint = ?,
                @i_PBIStartDate = ?,
                @i_PBIDueDate = ?,
                @i_PBIPriority = ?,
                @i_PBIModificatorId = ?,
                @i_PBIStatus = ?,
                @w_Accion = 'U'
            """,
            (
                pbi.PBIId,
                pbi.PBISummary,
                pbi.PBIDescription,
                pbi.PBIsAcceptanceCriteria,
                pbi.PBIOwner,
                pbi.PBIParentLink,
                pbi.PBIStoryPoint,
                pbi.PBIStartDate,
                pbi.PBIDueDate,
                pbi.PBIPriority,
                modificator_id,
                pbi.PBIStatus
            )
        )

    def list_product_backlog_items(
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