USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_GENERAL].[USP_Features]
(
    @i_featureId INT = NULL,
    @i_featureSummary VARCHAR(500) = NULL,
    @i_featureDescription VARCHAR(2000) = NULL,
    @i_featuresAcceptanceCriteria VARCHAR(4000) = NULL,
    @i_featureParentLink INT = NULL,
    @i_featureOwner INT = NULL,
    @i_featureStartDate DATE = NULL,
    @i_featureDueDate DATE = NULL,
    @i_featurePriority INT = NULL,
    @i_featureCreationDate DATETIME = NULL,
    @i_featureCreatorId INT = NULL,
    @i_featureModificationDate DATETIME = NULL,
    @i_featureModificatorId INT = NULL,
    @i_featureStatus INT = NULL,
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

    -- Inicializar parametros de salida
    SET @o_Numero = NULL;
    SET @o_MensajeTecnico = NULL;
    SET @o_MensajeUsuario = NULL;

    -- Fecha de creacion predeterminada
    IF @i_featureCreationDate IS NULL
        SET @i_featureCreationDate = GETDATE();

    -- Fecha de modificacion predeterminada
    IF @i_featureModificationDate IS NULL
        SET @i_featureModificationDate = GETDATE();

    -- INSERTAR FEATURE
    --------------------------------------------------
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_featureSummary)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DEL FEATURE ES OBLIGATORIO';
        END
        ELSE IF ISNULL(LTRIM(RTRIM(@i_featureDescription)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DEL FEATURE ES OBLIGATORIA';
        END
        ELSE IF ISNULL(LTRIM(RTRIM(@i_featuresAcceptanceCriteria)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION SON OBLIGATORIOS';
        END
        ELSE IF ISNULL(@i_featureParentLink, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL EPIC ASOCIADO ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_featureOwner, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL FEATURE ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_featureCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL CREADOR DEL FEATURE ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_featureStatus, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO DEL FEATURE ES OBLIGATORIO';
        END
        ELSE IF @i_featureStartDate IS NOT NULL
            AND @i_featureDueDate IS NOT NULL
            AND @i_featureStartDate > @i_featureDueDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA FECHA DE INICIO NO PUEDE SER MAYOR QUE LA FECHA LIMITE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[TBL_Epics]
            WHERE epicId = @i_featureParentLink
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL EPIC ASOCIADO NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_featureOwner
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL FEATURE NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_featureCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO CREADOR NO EXISTE';
        END
        ELSE IF @i_featurePriority IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Priorities]
                WHERE priorityId = @i_featurePriority
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD INDICADA NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_Status]
            WHERE statusId = @i_featureStatus
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO INDICADO NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_INS_FEATURE;

                INSERT INTO [SQM_GENERAL].[TBL_Features]
                (
                    featureSummary,
                    featureDescription,
                    featuresAcceptanceCriteria,
                    featureParentLink,
                    featureOwner,
                    featureStartDate,
                    featureDueDate,
                    featurePriority,
                    featureCreationDate,
                    featureCreatorId,
                    featureModificationDate,
                    featureModificatorId,
                    featureStatus
                )
                VALUES
                (
                    @i_featureSummary,
                    @i_featureDescription,
                    @i_featuresAcceptanceCriteria,
                    @i_featureParentLink,
                    @i_featureOwner,
                    @i_featureStartDate,
                    @i_featureDueDate,
                    @i_featurePriority,
                    @i_featureCreationDate,
                    @i_featureCreatorId,
                    NULL,
                    NULL,
                    @i_featureStatus
                );

                COMMIT TRANSACTION TRX_INS_FEATURE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'FEATURE REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_FEATURE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR EL FEATURE';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR FEATURE',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACTUALIZAR FEATURE
    --------------------------------------------------
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_featureId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL FEATURE ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_featureModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[TBL_Features]
            WHERE featureId = @i_featureId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL FEATURE NO EXISTE';
        END
        ELSE IF @i_featureSummary IS NOT NULL
            AND LTRIM(RTRIM(@i_featureSummary)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DEL FEATURE NO PUEDE ESTAR VACIO';
        END
        ELSE IF @i_featureDescription IS NOT NULL
            AND LTRIM(RTRIM(@i_featureDescription)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DEL FEATURE NO PUEDE ESTAR VACIA';
        END
        ELSE IF @i_featuresAcceptanceCriteria IS NOT NULL
            AND LTRIM(RTRIM(@i_featuresAcceptanceCriteria)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION NO PUEDEN ESTAR VACIOS';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_featureModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO MODIFICADOR NO EXISTE';
        END
        ELSE IF @i_featureParentLink IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_GENERAL].[TBL_Epics]
                WHERE epicId = @i_featureParentLink
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL EPIC ASOCIADO NO EXISTE';
        END
        ELSE IF @i_featureOwner IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_SECURITY].[TBL_Users]
                WHERE userId = @i_featureOwner
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DEL FEATURE NO EXISTE';
        END
        ELSE IF @i_featurePriority IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Priorities]
                WHERE priorityId = @i_featurePriority
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD INDICADA NO EXISTE';
        END
        ELSE IF @i_featureStatus IS NOT NULL
            AND NOT EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_Status]
                WHERE statusId = @i_featureStatus
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO INDICADO NO EXISTE';
        END
        ELSE
        BEGIN
            -- Validar fechas nuevas y existentes
            SELECT
                @w_StartDate = COALESCE(
                    @i_featureStartDate, featureStartDate
                ),
                @w_DueDate = COALESCE(
                    @i_featureDueDate, featureDueDate
                )
            FROM [SQM_GENERAL].[TBL_Features]
            WHERE featureId = @i_featureId;

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
                    BEGIN TRANSACTION TRX_UPD_FEATURE;

                    UPDATE [SQM_GENERAL].[TBL_Features]
                    SET
                        featureSummary = COALESCE(
                            @i_featureSummary, featureSummary
                        ),
                        featureDescription = COALESCE(
                            @i_featureDescription, featureDescription
                        ),
                        featuresAcceptanceCriteria = COALESCE(
                            @i_featuresAcceptanceCriteria,
                            featuresAcceptanceCriteria
                        ),
                        featureParentLink = COALESCE(
                            @i_featureParentLink, featureParentLink
                        ),
                        featureOwner = COALESCE(
                            @i_featureOwner, featureOwner
                        ),
                        featureStartDate = COALESCE(
                            @i_featureStartDate, featureStartDate
                        ),
                        featureDueDate = COALESCE(
                            @i_featureDueDate, featureDueDate
                        ),
                        featurePriority = COALESCE(
                            @i_featurePriority, featurePriority
                        ),
                        featureModificationDate = @i_featureModificationDate,
                        featureModificatorId = @i_featureModificatorId,
                        featureStatus = COALESCE(
                            @i_featureStatus, featureStatus
                        )
                    WHERE featureId = @i_featureId;

                    COMMIT TRANSACTION TRX_UPD_FEATURE;

                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'FEATURE ACTUALIZADO CORRECTAMENTE';
                END TRY
                BEGIN CATCH
                    IF @@TRANCOUNT > 0
                        ROLLBACK TRANSACTION TRX_UPD_FEATURE;

                    SET @o_Numero = 500;
                    SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR EL FEATURE';
                    SET @o_MensajeTecnico = CONCAT_WS(
                        ' - ',
                        'ERROR AL ACTUALIZAR FEATURE',
                        ERROR_PROCEDURE(),
                        ERROR_LINE(),
                        ERROR_MESSAGE()
                    );
                END CATCH
            END
        END
    END

    -- LISTAR FEATURES CON PAGINACION
    --------------------------------------------------
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber, 0) <= 0
            OR ISNULL(@i_RowsPerPage, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA PAGINA Y LAS FILAS POR PAGINA DEBEN SER MAYORES QUE CERO';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SELECT
                    featureId,
                    featureSummary,
                    featureDescription,
                    featuresAcceptanceCriteria,
                    featureParentLink,
                    featureOwner,
                    featureStartDate,
                    featureDueDate,
                    featurePriority,
                    featureCreationDate,
                    featureCreatorId,
                    featureModificationDate,
                    featureModificatorId,
                    featureStatus
                FROM [SQM_GENERAL].[TBL_Features] WITH (NOLOCK)
                ORDER BY featureId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario = 'FEATURES LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL LISTAR LOS FEATURES';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL LISTAR FEATURES',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACCION INVALIDA
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