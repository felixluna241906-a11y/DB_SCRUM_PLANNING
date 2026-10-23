USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_CATALOGS].[USP_Priorities]
(
    @i_priorityId INT = NULL,
    @i_priorityName VARCHAR(80) = NULL,
    @i_priorityCreationDate DATETIME = NULL,
    @i_priorityCreatorId INT = NULL,
    @i_priorityModificationDate DATETIME = NULL,
    @i_priorityModificatorId INT = NULL,
    @i_priorityEnable BIT = NULL,
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

    -- INICIALIZAR PARAMETROS DE SALIDA
    SET @o_Numero = NULL;
    SET @o_MensajeTecnico = NULL;
    SET @o_MensajeUsuario = NULL;

    -- FECHA DE CREACION POR DEFECTO
    IF @i_priorityCreationDate IS NULL
        SET @i_priorityCreationDate = GETDATE();

    -- FECHA DE MODIFICACION POR DEFECTO
    IF @i_priorityModificationDate IS NULL
        SET @i_priorityModificationDate = GETDATE();


    -- INSERTAR PRIORITY
    -- ACCION: I
    -- ==========================================
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_priorityName)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DE LA PRIORIDAD ES OBLIGATORIO';
        END

        ELSE IF ISNULL(@i_priorityCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL CREADOR ES OBLIGATORIO';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_priorityCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO CREADOR NO EXISTE';
        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_Priorities]
            WHERE priorityName = LTRIM(RTRIM(@i_priorityName))
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DE LA PRIORIDAD YA EXISTE';
        END

        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_INS_PRIORITY;

                INSERT INTO [SQM_CATALOGS].[TBL_Priorities]
                (
                    priorityName,
                    priorityCreationDate,
                    priorityCreatorId,
                    priorityModificationDate,
                    priorityModificatorId,
                    priorityEnable
                )
                VALUES
                (
                    LTRIM(RTRIM(@i_priorityName)),
                    @i_priorityCreationDate,
                    @i_priorityCreatorId,
                    NULL,
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_PRIORITY;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario =
                    'PRIORIDAD REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_INS_PRIORITY;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL REGISTRAR LA PRIORIDAD';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL REGISTRAR PRIORIDAD - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END


    -- ACTUALIZAR PRIORITY
    -- ACCION: U
    -- ==========================================
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_priorityId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DE LA PRIORIDAD ES OBLIGATORIO';
        END

        ELSE IF ISNULL(@i_priorityModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_Priorities]
            WHERE priorityId = @i_priorityId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario =
                'LA PRIORIDAD NO EXISTE';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_priorityModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO MODIFICADOR NO EXISTE';
        END

        ELSE IF @i_priorityName IS NOT NULL
             AND LTRIM(RTRIM(@i_priorityName)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DE LA PRIORIDAD NO PUEDE ESTAR VACIO';
        END

        ELSE IF @i_priorityName IS NOT NULL
             AND EXISTS
             (
                 SELECT 1
                 FROM [SQM_CATALOGS].[TBL_Priorities]
                 WHERE priorityName = LTRIM(RTRIM(@i_priorityName))
                   AND priorityId <> @i_priorityId
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DE LA PRIORIDAD YA EXISTE';
        END

        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_UPD_PRIORITY;

                UPDATE [SQM_CATALOGS].[TBL_Priorities]
                SET
                    priorityName =
                        COALESCE(
                            LTRIM(RTRIM(@i_priorityName)),
                            priorityName
                        ),
                    priorityModificationDate =
                        COALESCE(
                            @i_priorityModificationDate,
                            GETDATE()
                        ),
                    priorityModificatorId =
                        @i_priorityModificatorId,
                    priorityEnable =
                        COALESCE(
                            @i_priorityEnable,
                            priorityEnable
                        )
                WHERE priorityId = @i_priorityId;

                COMMIT TRANSACTION TRX_UPD_PRIORITY;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario =
                    'PRIORIDAD ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_UPD_PRIORITY;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL ACTUALIZAR LA PRIORIDAD';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL ACTUALIZAR PRIORIDAD - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END


    -- LISTAR PRIORITIES CON PAGINACION
    -- ACCION: S
    -- ==========================================
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
                    priorityId,
                    priorityName,
                    priorityCreationDate,
                    priorityCreatorId,
                    priorityModificationDate,
                    priorityModificatorId,
                    priorityEnable
                FROM [SQM_CATALOGS].[TBL_Priorities]
                ORDER BY priorityId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario =
                        'PRIORIDADES LISTADAS CORRECTAMENTE';
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
                    'ERROR AL LISTAR LAS PRIORIDADES';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL LISTAR PRIORIDADES - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END


    -- ACCION NO VALIDA
    -- ==========================================
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico =
            'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA ACCION';
    END
END;
GO