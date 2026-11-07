from domain.entities.TaskModels import (
    TaskCreate,
    TaskUpdate
)

from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

from infrastructure.database.base_repository import BaseRepository


class TaskRepository(BaseRepository):

    SP_NAME = "[SQM_PLANNING].[USP_Tasks]"

    def insert_task(
        self,
        task: TaskCreate,
        creator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_taskSummary = ?,
                @i_taskDescription = ?,
                @i_taskOwner = ?,
                @i_taskParentLink = ?,
                @i_taskOriginalEstimate = ?,
                @i_taskCompletedWork = ?,
                @i_taskRemaningWork = ?,
                @i_taskStartDate = ?,
                @i_taskCompletedDate = ?,
                @i_taskDueDate = ?,
                @i_taskActivityType = ?,
                @i_taskCreatorId = ?,
                @i_taskStatus = ?,
                @w_Accion = 'I'
            """,
            (
                task.taskSummary,
                task.taskDescription,
                task.taskOwner,
                task.taskParentLink,
                task.taskOriginalEstimate,
                task.taskCompletedWork,
                task.taskRemaningWork,
                task.taskStartDate,
                task.taskCompletedDate,
                task.taskDueDate,
                task.taskActivityType,
                creator_id,
                task.taskStatus
            )
        )

    def update_task(
        self,
        task: TaskUpdate,
        modificator_id: int
    ) -> OperationResult:

        return self.execute_operation(
            f"""
            EXEC {self.SP_NAME}
                @i_taskId = ?,
                @i_taskSummary = ?,
                @i_taskDescription = ?,
                @i_taskOwner = ?,
                @i_taskParentLink = ?,
                @i_taskOriginalEstimate = ?,
                @i_taskCompletedWork = ?,
                @i_taskRemaningWork = ?,
                @i_taskStartDate = ?,
                @i_taskCompletedDate = ?,
                @i_taskDueDate = ?,
                @i_taskActivityType = ?,
                @i_taskModificatorId = ?,
                @i_taskStatus = ?,
                @w_Accion = 'U'
            """,
            (
                task.taskId,
                task.taskSummary,
                task.taskDescription,
                task.taskOwner,
                task.taskParentLink,
                task.taskOriginalEstimate,
                task.taskCompletedWork,
                task.taskRemaningWork,
                task.taskStartDate,
                task.taskCompletedDate,
                task.taskDueDate,
                task.taskActivityType,
                modificator_id,
                task.taskStatus
            )
        )

    def list_tasks(
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