USE [DB_SCRUM_PLANNING]
GO

-- ============================================================================
-- 1. ESQUEMA: SQM_CATALOGS - TABLA: TBL_Status
-- ============================================================================

-- INSERTAR STATUS
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Status_Insert
    @statusName VARCHAR(80),
    @statusCreatorId INT,
    @statusEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_CATALOGS.TBL_Status
        (statusName, statusCreationDate, statusCreatorId, statusModificationDate, statusModificatorId, statusEnable)
    VALUES
        (@statusName, GETDATE(), @statusCreatorId, GETDATE(), NULL, @statusEnable);
    
    SELECT SCOPE_IDENTITY() AS NewStatusId;
END;
GO

-- ACTUALIZAR STATUS
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Status_Update
    @statusId INT,
    @statusName VARCHAR(80),
    @statusModificatorId INT,
    @statusEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_CATALOGS.TBL_Status
    SET statusName = @statusName,
        statusModificationDate = GETDATE(),
        statusModificatorId = @statusModificatorId,
        statusEnable = @statusEnable
    WHERE statusId = @statusId;
END;
GO

-- LISTAR STATUS CON PAGINACIÓN
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Status_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT statusId, statusName, statusCreationDate, statusCreatorId, statusModificationDate, statusModificatorId, statusEnable
    FROM SQM_CATALOGS.TBL_Status
    ORDER BY statusId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 2. ESQUEMA: SQM_SECURITY - TABLA: TBL_Roles
-- ============================================================================

-- INSERTAR ROL
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Roles_Insert
    @rolName VARCHAR(80),
    @rolCreatorId INT,
    @rolEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_SECURITY.TBL_Roles
        (rolName, rolCreationDate, rolCreatorId, rolModificationDate, rolModificatorId, rolEnable)
    VALUES
        (@rolName, GETDATE(), @rolCreatorId, GETDATE(), NULL, @rolEnable);

    SELECT SCOPE_IDENTITY() AS NewRolId;
END;
GO

-- ACTUALIZAR ROL
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Roles_Update
    @rolId INT,
    @rolName VARCHAR(80),
    @rolModificatorId INT,
    @rolEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_SECURITY.TBL_Roles
    SET rolName = @rolName,
        rolModificationDate = GETDATE(),
        rolModificatorId = @rolModificatorId,
        rolEnable = @rolEnable
    WHERE rolId = @rolId;
END;
GO

-- LISTAR ROLES CON PAGINACIÓN
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Roles_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT rolId, rolName, rolCreationDate, rolCreatorId, rolModificationDate, rolModificatorId, rolEnable
    FROM SQM_SECURITY.TBL_Roles
    ORDER BY rolId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 3. ESQUEMA: SQM_SECURITY - TABLA: TBL_Users
-- ============================================================================

-- INSERTAR USUARIO
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Users_Insert
    @userFullName VARCHAR(80),
    @userName VARCHAR(80),
    @userEmail VARCHAR(80),
    @userPassword VARBINARY(256),
    @userRolId INT,
    @userCreatorId INT,
    @userEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_SECURITY.TBL_Users
        (userFullName, userName, userEmail, userPassword, userRolId, userCreationDate, userCreatorId, userModificationDate, userModificatorId, userEnable)
    VALUES
        (@userFullName, @userName, @userEmail, @userPassword, @userRolId, GETDATE(), @userCreatorId, GETDATE(), NULL, @userEnable);

    SELECT SCOPE_IDENTITY() AS NewUserId;
END;
GO

-- ACTUALIZAR USUARIO
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Users_Update
    @userId INT,
    @userFullName VARCHAR(80),
    @userName VARCHAR(80),
    @userEmail VARCHAR(80),
    @userPassword VARBINARY(256),
    @userRolId INT,
    @userModificatorId INT,
    @userEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_SECURITY.TBL_Users
    SET userFullName = @userFullName,
        userName = @userName,
        userEmail = @userEmail,
        userPassword = @userPassword,
        userRolId = @userRolId,
        userModificationDate = GETDATE(),
        userModificatorId = @userModificatorId,
        userEnable = @userEnable
    WHERE userId = @userId;
END;
GO

-- LISTAR USUARIOS CON PAGINACIÓN
CREATE PROCEDURE SQM_SECURITY.USP_TBL_Users_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT userId, userFullName, userName, userEmail, userRolId, userCreationDate, userCreatorId, userModificationDate, userModificatorId, userEnable
    FROM SQM_SECURITY.TBL_Users
    ORDER BY userId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 4. ESQUEMA: SQM_CATALOGS - TABLA: TBL_BusinessValues
-- ============================================================================

-- INSERTAR BUSINESS VALUE
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_BusinessValues_Insert
    @businessValueName VARCHAR(80),
    @businessValueCreatorId INT,
    @businessValueEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_CATALOGS.TBL_BusinessValues
        (businessValueName, businessValueCreationDate, businessValueCreatorId, businessValueModificationDate, businessValueModificatorId, businessValueEnable)
    VALUES
        (@businessValueName, GETDATE(), @businessValueCreatorId, NULL, NULL, @businessValueEnable);

    SELECT SCOPE_IDENTITY() AS NewBusinessValueId;
END;
GO

-- ACTUALIZAR BUSINESS VALUE
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_BusinessValues_Update
    @businessValueId INT,
    @businessValueName VARCHAR(80),
    @businessValueModificatorId INT,
    @businessValueEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_CATALOGS.TBL_BusinessValues
    SET businessValueName = @businessValueName,
        businessValueModificationDate = GETDATE(),
        businessValueModificatorId = @businessValueModificatorId,
        businessValueEnable = @businessValueEnable
    WHERE businessValueId = @businessValueId;
END;
GO

-- LISTAR BUSINESS VALUES CON PAGINACIÓN
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_BusinessValues_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT businessValueId, businessValueName, businessValueCreationDate, businessValueCreatorId, businessValueModificationDate, businessValueModificatorId, businessValueEnable
    FROM SQM_CATALOGS.TBL_BusinessValues
    ORDER BY businessValueId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 5. ESQUEMA: SQM_CATALOGS - TABLA: TBL_Priorities
-- ============================================================================

-- INSERTAR PRIORITY
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Priorities_Insert
    @priorityName VARCHAR(80),
    @priorityCreatorId INT,
    @priorityEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_CATALOGS.TBL_Priorities
        (priorityName, priorityCreationDate, priorityCreatorId, priorityModificationDate, priorityModificatorId, priorityEnable)
    VALUES
        (@priorityName, GETDATE(), @priorityCreatorId, NULL, NULL, @priorityEnable);

    SELECT SCOPE_IDENTITY() AS NewPriorityId;
END;
GO

-- ACTUALIZAR PRIORITY
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Priorities_Update
    @priorityId INT,
    @priorityName VARCHAR(80),
    @priorityModificatorId INT,
    @priorityEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_CATALOGS.TBL_Priorities
    SET priorityName = @priorityName,
        priorityModificationDate = GETDATE(),
        priorityModificatorId = @priorityModificatorId,
        priorityEnable = @priorityEnable
    WHERE priorityId = @priorityId;
END;
GO

-- LISTAR PRIORITIES CON PAGINACIÓN
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_Priorities_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT priorityId, priorityName, priorityCreationDate, priorityCreatorId, priorityModificationDate, priorityModificatorId, priorityEnable
    FROM SQM_CATALOGS.TBL_Priorities
    ORDER BY priorityId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 6. ESQUEMA: SQM_CATALOGS - TABLA: TBL_ActivityTypes
-- ============================================================================

-- INSERTAR ACTIVITY TYPE
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_ActivityTypes_Insert
    @activityTypeName VARCHAR(80),
    @activityTypeCreatorId INT,
    @activityTypeEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_CATALOGS.TBL_ActivityTypes
        (activityTypeName, activityTypeCreationDate, activityTypeCreatorId, activityTypeModificationDate, activityTypeModificatorId, activityTypeEnable)
    VALUES
        (@activityTypeName, GETDATE(), @activityTypeCreatorId, NULL, NULL, @activityTypeEnable);

    SELECT SCOPE_IDENTITY() AS NewActivityTypeId;
END;
GO

-- ACTUALIZAR ACTIVITY TYPE
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_ActivityTypes_Update
    @activityTypeId INT,
    @activityTypeName VARCHAR(80),
    @activityTypeModificatorId INT,
    @activityTypeEnable BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_CATALOGS.TBL_ActivityTypes
    SET activityTypeName = @activityTypeName,
        activityTypeModificationDate = GETDATE(),
        activityTypeModificatorId = @activityTypeModificatorId,
        activityTypeEnable = @activityTypeEnable
    WHERE activityTypeId = @activityTypeId;
END;
GO

-- LISTAR ACTIVITY TYPES CON PAGINACIÓN
CREATE PROCEDURE SQM_CATALOGS.USP_TBL_ActivityTypes_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT activityTypeId, activityTypeName, activityTypeCreationDate, activityTypeCreatorId, activityTypeModificationDate, activityTypeModificatorId, activityTypeEnable
    FROM SQM_CATALOGS.TBL_ActivityTypes
    ORDER BY activityTypeId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 7. ESQUEMA: SQM_GENERAL - TABLA: TBL_Initiatives
-- ============================================================================

-- INSERTAR INITIATIVE
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Initiatives_Insert
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255) = NULL,
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE = NULL,
    @initiativeTargetEnd DATE = NULL,
    @initiativeCreatorId INT,
    @initiativeStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_Initiatives
        (initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals, initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, initiativeCreationDate, initiativeCreatorId, initiativeModificationDate, initiativeModificatorId, initiativeStatus)
    VALUES
        (@initiativeSummary, @initiativeDescription, @initiativeOwner, @initiativeGoals, @initiativeBusinessValue, @initiativeTargetStart, @initiativeTargetEnd, GETDATE(), @initiativeCreatorId, NULL, NULL, @initiativeStatus);

    SELECT SCOPE_IDENTITY() AS NewInitiativeId;
END;
GO

-- ACTUALIZAR INITIATIVE
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Initiatives_Update
    @initiativeId INT,
    @initiativeSummary VARCHAR(200),
    @initiativeDescription VARCHAR(2000),
    @initiativeOwner INT,
    @initiativeGoals VARCHAR(255) = NULL,
    @initiativeBusinessValue INT,
    @initiativeTargetStart DATE = NULL,
    @initiativeTargetEnd DATE = NULL,
    @initiativeModificatorId INT,
    @initiativeStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_Initiatives
    SET initiativeSummary = @initiativeSummary,
        initiativeDescription = @initiativeDescription,
        initiativeOwner = @initiativeOwner,
        initiativeGoals = @initiativeGoals,
        initiativeBusinessValue = @initiativeBusinessValue,
        initiativeTargetStart = @initiativeTargetStart,
        initiativeTargetEnd = @initiativeTargetEnd,
        initiativeModificationDate = GETDATE(),
        initiativeModificatorId = @initiativeModificatorId,
        initiativeStatus = @initiativeStatus
    WHERE initiativeId = @initiativeId;
END;
GO

-- LISTAR INITIATIVES CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Initiatives_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT initiativeId, initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals, initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, initiativeCreationDate, initiativeCreatorId, initiativeModificationDate, initiativeModificatorId, initiativeStatus
    FROM SQM_GENERAL.TBL_Initiatives
    ORDER BY initiativeId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 8. ESQUEMA: SQM_GENERAL - TABLA: TBL_Epics
-- ============================================================================

-- INSERTAR EPIC
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Epics_Insert
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE = NULL,
    @epicDueDate DATE = NULL,
    @epicPriority INT = NULL,
    @epicCreatorId INT,
    @epicStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_Epics
        (epicName, epicSummary, epicDescription, epicParentLink, epicOwner, epicStartDate, epicDueDate, epicPriority, epicCreationDate, epicCreatorId, epicModificationDate, epicModificatorId, epicStatus)
    VALUES
        (@epicName, @epicSummary, @epicDescription, @epicParentLink, @epicOwner, @epicStartDate, @epicDueDate, @epicPriority, GETDATE(), @epicCreatorId, NULL, NULL, @epicStatus);

    SELECT SCOPE_IDENTITY() AS NewEpicId;
END;
GO

-- ACTUALIZAR EPIC
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Epics_Update
    @epicId INT,
    @epicName VARCHAR(100),
    @epicSummary VARCHAR(500),
    @epicDescription VARCHAR(4000),
    @epicParentLink INT,
    @epicOwner INT,
    @epicStartDate DATE = NULL,
    @epicDueDate DATE = NULL,
    @epicPriority INT = NULL,
    @epicModificatorId INT,
    @epicStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_Epics
    SET epicName = @epicName,
        epicSummary = @epicSummary,
        epicDescription = @epicDescription,
        epicParentLink = @epicParentLink,
        epicOwner = @epicOwner,
        epicStartDate = @epicStartDate,
        epicDueDate = @epicDueDate,
        epicPriority = @epicPriority,
        epicModificationDate = GETDATE(),
        epicModificatorId = @epicModificatorId,
        epicStatus = @epicStatus
    WHERE epicId = @epicId;
END;
GO

-- LISTAR EPICS CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Epics_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT epicId, epicName, epicSummary, epicDescription, epicParentLink, epicOwner, epicStartDate, epicDueDate, epicPriority, epicCreationDate, epicCreatorId, epicModificationDate, epicModificatorId, epicStatus
    FROM SQM_GENERAL.TBL_Epics
    ORDER BY epicId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 9. ESQUEMA: SQM_GENERAL - TABLA: TBL_Features
-- ============================================================================

-- INSERTAR FEATURE
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Features_Insert
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE = NULL,
    @featureDueDate DATE = NULL,
    @featurePriority INT = NULL,
    @featureCreatorId INT,
    @featureStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_Features
        (featureSummary, featureDescription, featuresAcceptanceCriteria, featureParentLink, featureOwner, featureStartDate, featureDueDate, featurePriority, featureCreationDate, featureCreatorId, featureModificationDate, featureModificatorId, featureStatus)
    VALUES
        (@featureSummary, @featureDescription, @featuresAcceptanceCriteria, @featureParentLink, @featureOwner, @featureStartDate, @featureDueDate, @featurePriority, GETDATE(), @featureCreatorId, NULL, NULL, @featureStatus);

    SELECT SCOPE_IDENTITY() AS NewFeatureId;
END;
GO

-- ACTUALIZAR FEATURE
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Features_Update
    @featureId INT,
    @featureSummary VARCHAR(500),
    @featureDescription VARCHAR(2000),
    @featuresAcceptanceCriteria VARCHAR(4000),
    @featureParentLink INT,
    @featureOwner INT,
    @featureStartDate DATE = NULL,
    @featureDueDate DATE = NULL,
    @featurePriority INT = NULL,
    @featureModificatorId INT,
    @featureStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_Features
    SET featureSummary = @featureSummary,
        featureDescription = @featureDescription,
        featuresAcceptanceCriteria = @featuresAcceptanceCriteria,
        featureParentLink = @featureParentLink,
        featureOwner = @featureOwner,
        featureStartDate = @featureStartDate,
        featureDueDate = @featureDueDate,
        featurePriority = @featurePriority,
        featureModificationDate = GETDATE(),
        featureModificatorId = @featureModificatorId,
        featureStatus = @featureStatus
    WHERE featureId = @featureId;
END;
GO

-- LISTAR FEATURES CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Features_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT featureId, featureSummary, featureDescription, featuresAcceptanceCriteria, featureParentLink, featureOwner, featureStartDate, featureDueDate, featurePriority, featureCreationDate, featureCreatorId, featureModificationDate, featureModificatorId, featureStatus
    FROM SQM_GENERAL.TBL_Features
    ORDER BY featureId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 10. ESQUEMA: SQM_GENERAL - TABLA: TBL_ProductBacklogItems
-- ============================================================================

-- INSERTAR PBI
CREATE PROCEDURE SQM_GENERAL.USP_TBL_ProductBacklogItems_Insert
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT = NULL,
    @PBIStartDate DATE = NULL,
    @PBIDueDate DATE = NULL,
    @PBIPriority INT = NULL,
    @PBICreatorId INT,
    @PBIStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_ProductBacklogItems
        (PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, PBICreationDate, PBICreatorId, PBIModificationDate, PBIModificatorId, PBIStatus)
    VALUES
        (@PBISummary, @PBIDescription, @PBIsAcceptanceCriteria, @PBIOwner, @PBIParentLink, @PBIStoryPoint, @PBIStartDate, @PBIDueDate, @PBIPriority, GETDATE(), @PBICreatorId, NULL, NULL, @PBIStatus);

    SELECT SCOPE_IDENTITY() AS NewPBIId;
END;
GO

-- ACTUALIZAR PBI
CREATE PROCEDURE SQM_GENERAL.USP_TBL_ProductBacklogItems_Update
    @PBIId INT,
    @PBISummary VARCHAR(500),
    @PBIDescription VARCHAR(2000),
    @PBIsAcceptanceCriteria VARCHAR(4000),
    @PBIOwner INT,
    @PBIParentLink INT,
    @PBIStoryPoint INT = NULL,
    @PBIStartDate DATE = NULL,
    @PBIDueDate DATE = NULL,
    @PBIPriority INT = NULL,
    @PBIModificatorId INT,
    @PBIStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_ProductBacklogItems
    SET PBISummary = @PBISummary,
        PBIDescription = @PBIDescription,
        PBIsAcceptanceCriteria = @PBIsAcceptanceCriteria,
        PBIOwner = @PBIOwner,
        PBIParentLink = @PBIParentLink,
        PBIStoryPoint = @PBIStoryPoint,
        PBIStartDate = @PBIStartDate,
        PBIDueDate = @PBIDueDate,
        PBIPriority = @PBIPriority,
        PBIModificationDate = GETDATE(),
        PBIModificatorId = @PBIModificatorId,
        PBIStatus = @PBIStatus
    WHERE PBIId = @PBIId;
END;
GO

-- LISTAR PBIS CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_ProductBacklogItems_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT PBIId, PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, PBICreationDate, PBICreatorId, PBIModificationDate, PBIModificatorId, PBIStatus
    FROM SQM_GENERAL.TBL_ProductBacklogItems
    ORDER BY PBIId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 11. ESQUEMA: SQM_GENERAL - TABLA: TBL_Tasks
-- ============================================================================

-- INSERTAR TASK
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Tasks_Insert
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2) = NULL,
    @taskCompletedWork DECIMAL(4,2) = NULL,
    @taskRemaningWork DECIMAL(4,2) = NULL,
    @taskStartDate DATE = NULL,
    @taskCompletedDate DATE = NULL,
    @taskDueDate DATE = NULL,
    @taskActivityType INT = NULL,
    @taskCreatorId INT,
    @taskStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_Tasks
        (taskSummary, taskDescription, taskOwner, taskParentLink, taskOriginalEstimate, taskCompletedWork, taskRemaningWork, taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, taskCreationDate, taskCreatorId, taskModificationDate, taskModificatorId, taskStatus)
    VALUES
        (@taskSummary, @taskDescription, @taskOwner, @taskParentLink, @taskOriginalEstimate, @taskCompletedWork, @taskRemaningWork, @taskStartDate, @taskCompletedDate, @taskDueDate, @taskActivityType, GETDATE(), @taskCreatorId, NULL, NULL, @taskStatus);

    SELECT SCOPE_IDENTITY() AS NewTaskId;
END;
GO

-- ACTUALIZAR TASK
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Tasks_Update
    @taskId INT,
    @taskSummary VARCHAR(500),
    @taskDescription VARCHAR(2000),
    @taskOwner INT,
    @taskParentLink INT,
    @taskOriginalEstimate DECIMAL(4,2) = NULL,
    @taskCompletedWork DECIMAL(4,2) = NULL,
    @taskRemaningWork DECIMAL(4,2) = NULL,
    @taskStartDate DATE = NULL,
    @taskCompletedDate DATE = NULL,
    @taskDueDate DATE = NULL,
    @taskActivityType INT = NULL,
    @taskModificatorId INT,
    @taskStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_Tasks
    SET taskSummary = @taskSummary,
        taskDescription = @taskDescription,
        taskOwner = @taskOwner,
        taskParentLink = @taskParentLink,
        taskOriginalEstimate = @taskOriginalEstimate,
        taskCompletedWork = @taskCompletedWork,
        taskRemaningWork = @taskRemaningWork,
        taskStartDate = @taskStartDate,
        taskCompletedDate = @taskCompletedDate,
        taskDueDate = @taskDueDate,
        taskActivityType = @taskActivityType,
        taskModificationDate = GETDATE(),
        taskModificatorId = @taskModificatorId,
        taskStatus = @taskStatus
    WHERE taskId = @taskId;
END;
GO

-- LISTAR TASKS CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_Tasks_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT taskId, taskSummary, taskDescription, taskOwner, taskParentLink, taskOriginalEstimate, taskCompletedWork, taskRemaningWork, taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, taskCreationDate, taskCreatorId, taskModificationDate, taskModificatorId, taskStatus
    FROM SQM_GENERAL.TBL_Tasks
    ORDER BY taskId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- ============================================================================
-- 12. ESQUEMA: SQM_GENERAL - TABLA: TBL_TaskComments
-- ============================================================================

-- INSERTAR TASK COMMENT
CREATE PROCEDURE SQM_GENERAL.USP_TBL_TaskComments_Insert
    @taskCommentParentLink INT,
    @taskCommentOwner INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentCreatorId INT,
    @taskCommentStatus BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SQM_GENERAL.TBL_TaskComments
        (taskCommentParentLink, taskCommentOwner, taskCommentText, taskCommentCreationDate, taskCommentCreatorId, taskCommentModificationDate, taskCommentModificatorId, taskCommentStatus)
    VALUES
        (@taskCommentParentLink, @taskCommentOwner, @taskCommentText, GETDATE(), @taskCommentCreatorId, NULL, NULL, @taskCommentStatus);

    SELECT SCOPE_IDENTITY() AS NewTaskCommentId;
END;
GO

-- ACTUALIZAR TASK COMMENT
CREATE PROCEDURE SQM_GENERAL.USP_TBL_TaskComments_Update
    @taskCommentId INT,
    @taskCommentParentLink INT,
    @taskCommentOwner INT,
    @taskCommentText NVARCHAR(4000),
    @taskCommentModificatorId INT,
    @taskCommentStatus BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SQM_GENERAL.TBL_TaskComments
    SET taskCommentParentLink = @taskCommentParentLink,
        taskCommentOwner = @taskCommentOwner,
        taskCommentText = @taskCommentText,
        taskCommentModificationDate = GETDATE(),
        taskCommentModificatorId = @taskCommentModificatorId,
        taskCommentStatus = @taskCommentStatus
    WHERE taskCommentId = @taskCommentId;
END;
GO

-- LISTAR TASK COMMENTS CON PAGINACIÓN
CREATE PROCEDURE SQM_GENERAL.USP_TBL_TaskComments_List
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SELECT taskCommentId, taskCommentParentLink, taskCommentOwner, taskCommentText, taskCommentCreationDate, taskCommentCreatorId, taskCommentModificationDate, taskCommentModificatorId, taskCommentStatus
    FROM SQM_GENERAL.TBL_TaskComments
    ORDER BY taskCommentId ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO