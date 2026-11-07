from domain.entities.TaskCommentModels import (
    TaskCommentCreate,
    TaskCommentUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class TaskCommentRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_TaskComments]"

    def insert_task_comment(
        self,
        task_comment: TaskCommentCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_taskCommentParentLink = ?,
                @i_taskCommentOwner = ?,
                @i_taskCommentText = ?,
                @i_taskCommentCreatorId = ?,
                @i_taskCommentStatus = ?,
                @w_Accion = 'I'
            """,
            (
                task_comment.taskCommentParentLink,
                task_comment.taskCommentOwner,
                task_comment.taskCommentText,
                creator_id,
                task_comment.taskCommentStatus
            )
        )

    def update_task_comment(
        self,
        task_comment: TaskCommentUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_taskCommentId = ?,
                @i_taskCommentParentLink = ?,
                @i_taskCommentOwner = ?,
                @i_taskCommentText = ?,
                @i_taskCommentModificatorId = ?,
                @i_taskCommentStatus = ?,
                @w_Accion = 'U'
            """,
            (
                task_comment.taskCommentId,
                task_comment.taskCommentParentLink,
                task_comment.taskCommentOwner,
                task_comment.taskCommentText,
                modificator_id,
                task_comment.taskCommentStatus
            )
        )

    def list_task_comments(
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