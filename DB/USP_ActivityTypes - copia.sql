USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_CATALOGS].[USP_ActivityTypes]
(
    @i_activityTypeId INT = NULL,
    @i_activityTypeName VARCHAR(80) = NULL,
    @i_activityTypeCreationDate DATETIME = NULL,
    @i_activityTypeCreatorId INT = NULL,
    @i_activityTypeModificationDate DATETIME = NULL,
    @i_activityTypeModificatorId INT = NULL,
    @i_activityTypeEnable BIT = NULL,
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

    DECLARE @w_totalRows INT;

    -- Inicializar parametros de salida
    SET @o_Numero = NULL;
    SET @o_MensajeTecnico = NULL;
    SET @o_MensajeUsuario = NULL;

    -- Fecha de creacion predeterminada
    IF @i_activityTypeCreationDate IS NULL
        SET @i_activityTypeCreationDate = GETDATE();

    -- Fecha de modificacion predeterminada
    IF @i_activityTypeModificationDate IS NULL
        SET @i_activityTypeModificationDate = GETDATE();

    -- INSERTAR TIPO DE ACTIVIDAD
    --------------------------------------------------
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_activityTypeName)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_activityTypeCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_ActivityTypes]
            WHERE activityTypeName = @i_activityTypeName
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL TIPO DE ACTIVIDAD YA EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_activityTypeCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO CREADOR NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_INS_ACTIVITYTYPE;

                INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes]
                (
                    activityTypeName,
                    activityTypeCreationDate,
                    activityTypeCreatorId,
                    activityTypeModificationDate,
                    activityTypeModificatorId,
                    activityTypeEnable
                )
                VALUES
                (
                    @i_activityTypeName,
                    @i_activityTypeCreationDate,
                    @i_activityTypeCreatorId,
                    NULL,
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_ACTIVITYTYPE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario =
                    'TIPO DE ACTIVIDAD REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_ACTIVITYTYPE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL REGISTRAR EL TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR TIPO DE ACTIVIDAD',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACTUALIZAR TIPO DE ACTIVIDAD
    --------------------------------------------------
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_activityTypeId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_activityTypeModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_ActivityTypes]
            WHERE activityTypeId = @i_activityTypeId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL TIPO DE ACTIVIDAD NO EXISTE';
        END
        ELSE IF @i_activityTypeName IS NOT NULL
            AND LTRIM(RTRIM(@i_activityTypeName)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DEL TIPO DE ACTIVIDAD NO PUEDE ESTAR VACIO';
        END
        ELSE IF @i_activityTypeName IS NOT NULL
            AND EXISTS
            (
                SELECT 1
                FROM [SQM_CATALOGS].[TBL_ActivityTypes]
                WHERE activityTypeName = @i_activityTypeName
                  AND activityTypeId <> @i_activityTypeId
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL TIPO DE ACTIVIDAD YA EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_activityTypeModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO MODIFICADOR NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_UPD_ACTIVITYTYPE;

                UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
                SET
                    activityTypeName = COALESCE(
                        @i_activityTypeName,
                        activityTypeName
                    ),
                    activityTypeModificationDate =
                        @i_activityTypeModificationDate,
                    activityTypeModificatorId =
                        @i_activityTypeModificatorId,
                    activityTypeEnable = COALESCE(
                        @i_activityTypeEnable,
                        activityTypeEnable
                    )
                WHERE activityTypeId = @i_activityTypeId;

                COMMIT TRANSACTION TRX_UPD_ACTIVITYTYPE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario =
                    'TIPO DE ACTIVIDAD ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_ACTIVITYTYPE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL ACTUALIZAR EL TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL ACTUALIZAR TIPO DE ACTIVIDAD',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- LISTAR TIPOS DE ACTIVIDAD CON PAGINACION
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
                    activityTypeId,
                    activityTypeName,
                    activityTypeCreationDate,
                    activityTypeCreatorId,
                    activityTypeModificationDate,
                    activityTypeModificatorId,
                    activityTypeEnable
                FROM [SQM_CATALOGS].[TBL_ActivityTypes] WITH (NOLOCK)
                ORDER BY activityTypeId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario =
                        'TIPOS DE ACTIVIDAD LISTADOS CORRECTAMENTE';
                END
                ELSE
                BEGIN
                    SET @o_Numero = 204;
                    SET @o_MensajeUsuario =
                        'NO HAY MAS REGISTROS PARA LISTAR';
                END
            END TRY
            BEGIN CATCH
                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL LISTAR LOS TIPOS DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL LISTAR TIPOS DE ACTIVIDAD',
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