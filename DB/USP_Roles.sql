USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_SECURITY].[USP_Roles]
(
    @i_rolId INT = NULL,
    @i_rolName VARCHAR(80) = NULL,
    @i_rolCreationDate DATETIME = NULL,
    @i_rolCreatorId INT = NULL,
    @i_rolModificationDate DATETIME = NULL,
    @i_rolModificatorId INT = NULL,
    @i_rolEnable BIT = NULL,
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

    -- Inicializar parametros de salida
    SET @o_Numero = NULL;
    SET @o_MensajeTecnico = NULL;
    SET @o_MensajeUsuario = NULL;

    -- Fechas por defecto
    IF @i_rolCreationDate IS NULL
        SET @i_rolCreationDate = GETDATE();

    IF @i_rolModificationDate IS NULL
        SET @i_rolModificationDate = GETDATE();


    -- INSERTAR ROL
    -- Accion: I
    -- ==========================================
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_rolName)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_rolCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Roles]
            WHERE rolName = LTRIM(RTRIM(@i_rolName))
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL YA EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                INSERT INTO [SQM_SECURITY].[TBL_Roles]
                (
                    rolName,
                    rolCreationDate,
                    rolCreatorId,
                    rolModificationDate,
                    rolModificatorId,
                    rolEnable
                )
                VALUES
                (
                    LTRIM(RTRIM(@i_rolName)),
                    @i_rolCreationDate,
                    @i_rolCreatorId,
                    @i_rolModificationDate,
                    NULL,
                    1
                );

                COMMIT TRANSACTION;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'ROL REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR EL ROL';
                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL REGISTRAR ROL - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END

    -- ACTUALIZAR ROL
    -- Accion: U
    -- ==========================================
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_rolId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL ROL ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_rolModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Roles]
            WHERE rolId = @i_rolId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL ROL NO EXISTE';
        END
        ELSE IF @i_rolName IS NOT NULL
             AND LTRIM(RTRIM(@i_rolName)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL NO PUEDE ESTAR VACIO';
        END
        ELSE IF @i_rolName IS NOT NULL
             AND EXISTS
             (
                 SELECT 1
                 FROM [SQM_SECURITY].[TBL_Roles]
                 WHERE rolName = LTRIM(RTRIM(@i_rolName))
                   AND rolId <> @i_rolId
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL YA EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                UPDATE [SQM_SECURITY].[TBL_Roles]
                SET
                    rolName = COALESCE(
                        LTRIM(RTRIM(@i_rolName)), rolName
                    ),
                    rolModificationDate = @i_rolModificationDate,
                    rolModificatorId = @i_rolModificatorId,
                    rolEnable = COALESCE(
                        @i_rolEnable, rolEnable
                    )
                WHERE rolId = @i_rolId;

                COMMIT TRANSACTION;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ROL ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR EL ROL';
                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL ACTUALIZAR ROL - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END

    -- LISTAR ROLES CON PAGINACION
    -- Accion: S
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
                    rolId,
                    rolName,
                    rolCreationDate,
                    rolCreatorId,
                    rolModificationDate,
                    rolModificatorId,
                    rolEnable
                FROM [SQM_SECURITY].[TBL_Roles]
                ORDER BY rolId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                IF @@ROWCOUNT > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario =
                        'ROLES LISTADOS CORRECTAMENTE';
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
                SET @o_MensajeUsuario = 'ERROR AL LISTAR LOS ROLES';
                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL LISTAR ROLES - ',
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
            'EL PROCEDIMIENTO NO TIENE HABILITADA ESA ACCION';
    END
END;
GO