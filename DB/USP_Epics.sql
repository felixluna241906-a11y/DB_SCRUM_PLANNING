USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_GENERAL].[USP_Epics]
(
    @i_epicId INT = NULL,
    @i_epicName VARCHAR(100) = NULL,
    @i_epicSummary VARCHAR(500) = NULL,
    @i_epicDescription VARCHAR(4000) = NULL,
    @i_epicParentLink INT = NULL,
    @i_epicOwner INT = NULL,
    @i_epicStartDate DATE = NULL,
    @i_epicDueDate DATE = NULL,
    @i_epicPriority INT = NULL,
    @i_epicCreationDate DATETIME = NULL,
    @i_epicCreatorId INT = NULL,
    @i_epicModificationDate DATETIME = NULL,
    @i_epicModificatorId INT = NULL,
    @i_epicStatus INT = NULL,
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1),
    @o_Numero INT = NULL OUT,
    @o_MensajeTecnico VARCHAR(500) = NULL OUT,
    @o_MensajeUsuario VARCHAR(500) = NULL OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @w_totalRows INT,
        @w_StartDate DATE,
        @w_DueDate DATE;

    -- Inicializar mensajes de salida
    SET @o_Numero = NULL;
    SET @o_MensajeTecnico = NULL;
    SET @o_MensajeUsuario = NULL;

    -- Fechas predeterminadas
    IF @i_epicCreationDate IS NULL
        SET @i_epicCreationDate = GETDATE();

    IF @i_epicModificationDate IS NULL
        SET @i_epicModificationDate = GETDATE();

    -- INSERTAR EPIC
    --------------------------------------------------
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_epicName)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF ISNULL(LTRIM(RTRIM(@i_epicSummary)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF ISNULL(LTRIM(RTRIM(@i_epicDescription)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DEL EPIC ES OBLIGATORIA';
        END
        ELSE IF ISNULL(@i_epicParentLink, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA ASOCIADA ES OBLIGATORIA';
        END
        ELSE IF ISNULL(@i_epicOwner, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_epicCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL CREADOR DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_epicStatus, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF @i_epicStartDate IS NOT NULL
            AND @i_epicDueDate IS NOT NULL
            AND @i_epicStartDate > @i_epicDueDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA FECHA DE INICIO NO PUEDE SER MAYOR QUE LA FECHA LIMITE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_epicParentLink
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA ASOCIADA NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_epicOwner
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL EPIC NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_epicCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO CREADOR NO EXISTE';
        END
        ELSE IF @i_epicPriority IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Priorities]
                WHERE priorityId = @i_epicPriority
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD INDICADA NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_Status]
            WHERE statusId = @i_epicStatus
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO INDICADO NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                INSERT INTO [SQM_GENERAL].[TBL_Epics]
                (
                    epicName,
                    epicSummary,
                    epicDescription,
                    epicParentLink,
                    epicOwner,
                    epicStartDate,
                    epicDueDate,
                    epicPriority,
                    epicCreationDate,
                    epicCreatorId,
                    epicModificationDate,
                    epicModificatorId,
                    epicStatus
                )
                VALUES
                (
                    @i_epicName,
                    @i_epicSummary,
                    @i_epicDescription,
                    @i_epicParentLink,
                    @i_epicOwner,
                    @i_epicStartDate,
                    @i_epicDueDate,
                    @i_epicPriority,
                    @i_epicCreationDate,
                    @i_epicCreatorId,
                    NULL,
                    NULL,
                    @i_epicStatus
                );

                COMMIT TRANSACTION;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'EPIC REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR EL EPIC';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR EL EPIC',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACTUALIZAR EPIC
    --------------------------------------------------
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_epicId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL EPIC ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_epicModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[TBL_Epics]
            WHERE epicId = @i_epicId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL EPIC NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_epicModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO MODIFICADOR NO EXISTE';
        END
        ELSE IF @i_epicParentLink IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_GENERAL].[TBL_Initiatives]
                WHERE initiativeId = @i_epicParentLink
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA ASOCIADA NO EXISTE';
        END
        ELSE IF @i_epicOwner IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_SECURITY].[TBL_Users]
                WHERE userId = @i_epicOwner
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL EPIC NO EXISTE';
        END
        ELSE IF @i_epicPriority IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Priorities]
                WHERE priorityId = @i_epicPriority
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD INDICADA NO EXISTE';
        END
        ELSE IF @i_epicStatus IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Status]
                WHERE statusId = @i_epicStatus
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO INDICADO NO EXISTE';
        END
        ELSE
        BEGIN
            -- Comprobar las fechas nuevas junto con las existentes
            SELECT
                @w_StartDate = COALESCE(@i_epicStartDate, epicStartDate),
                @w_DueDate = COALESCE(@i_epicDueDate, epicDueDate)
            FROM [SQM_GENERAL].[TBL_Epics]
            WHERE epicId = @i_epicId;

            IF @w_StartDate IS NOT NULL
                AND @w_DueDate IS NOT NULL
                AND @w_StartDate > @w_DueDate
            BEGIN
                SET @o_Numero = 400;
                SET @o_MensajeUsuario =
                    'LA FECHA DE INICIO NO PUEDE SER MAYOR QUE LA FECHA LIMITE';
            END
            ELSE
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION;

                    UPDATE [SQM_GENERAL].[TBL_Epics]
                    SET
                        epicName = COALESCE(@i_epicName, epicName),
                        epicSummary = COALESCE(@i_epicSummary, epicSummary),
                        epicDescription = COALESCE(@i_epicDescription, epicDescription),
                        epicParentLink = COALESCE(@i_epicParentLink, epicParentLink),
                        epicOwner = COALESCE(@i_epicOwner, epicOwner),
                        epicStartDate = COALESCE(@i_epicStartDate, epicStartDate),
                        epicDueDate = COALESCE(@i_epicDueDate, epicDueDate),
                        epicPriority = COALESCE(@i_epicPriority, epicPriority),
                        epicModificationDate = @i_epicModificationDate,
                        epicModificatorId = @i_epicModificatorId,
                        epicStatus = COALESCE(@i_epicStatus, epicStatus)
                    WHERE epicId = @i_epicId;

                    COMMIT TRANSACTION;

                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'EPIC ACTUALIZADO CORRECTAMENTE';
                END TRY
                BEGIN CATCH
                    IF @@TRANCOUNT > 0
                        ROLLBACK TRANSACTION;

                    SET @o_Numero = 500;
                    SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR EL EPIC';
                    SET @o_MensajeTecnico = CONCAT_WS(
                        ' - ',
                        'ERROR AL ACTUALIZAR EL EPIC',
                        ERROR_PROCEDURE(),
                        ERROR_LINE(),
                        ERROR_MESSAGE()
                    );
                END CATCH
            END
        END
    END

    -- LISTAR EPICS CON PAGINACION
    --------------------------------------------------
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber, 0) <= 0
            OR ISNULL(@i_RowsPerPage, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NUMERO DE PAGINA Y LAS FILAS POR PAGINA DEBEN SER MAYORES QUE CERO';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SELECT
                    epicId,
                    epicName,
                    epicSummary,
                    epicDescription,
                    epicParentLink,
                    epicOwner,
                    epicStartDate,
                    epicDueDate,
                    epicPriority,
                    epicCreationDate,
                    epicCreatorId,
                    epicModificationDate,
                    epicModificatorId,
                    epicStatus
                FROM [SQM_GENERAL].[TBL_Epics] WITH (NOLOCK)
                ORDER BY epicId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'EPICS LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR LOS EPICS';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL LISTAR LOS EPICS',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACCION NO HABILITADA
    --------------------------------------------------
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico =
            'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END
END;
GO