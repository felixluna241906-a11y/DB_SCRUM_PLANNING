USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_CATALOGS].[USP_BusinessValues]
(
    @i_businessValueId INT = NULL,
    @i_businessValueName VARCHAR(80) = NULL,
    @i_businessValueCreationDate DATETIME = NULL,
    @i_businessValueCreatorId INT = NULL,
    @i_businessValueModificationDate DATETIME = NULL,
    @i_businessValueModificatorId INT = NULL,
    @i_businessValueEnable BIT = NULL,
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

    -- Fechas por defecto
    IF @i_businessValueCreationDate IS NULL
        SET @i_businessValueCreationDate = GETDATE();

    IF @i_businessValueModificationDate IS NULL
        SET @i_businessValueModificationDate = GETDATE();


    -- INSERTAR BUSINESS VALUE
    -- ACCION: I
    -- ==========================================
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_businessValueName)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DEL VALOR DE NEGOCIO ES OBLIGATORIO';
        END

        ELSE IF ISNULL(@i_businessValueCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL CREADOR ES OBLIGATORIO';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_businessValueCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO CREADOR NO EXISTE';
        END

        ELSE IF EXISTS
(
    SELECT 1
    FROM [SQM_CATALOGS].[TBL_BusinessValues] (NOLOCK)
    WHERE UPPER(LTRIM(RTRIM(businessValueName))) =
          UPPER(LTRIM(RTRIM(@i_businessValueName)))
)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO YA EXISTE';
        END

        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_INS_BUSINESS_VALUE;

                INSERT INTO [SQM_CATALOGS].[TBL_BusinessValues]
                (
                    businessValueName,
                    businessValueCreationDate,
                    businessValueCreatorId,
                    businessValueModificationDate,
                    businessValueModificatorId,
                    businessValueEnable
                )
                VALUES
                (
                    LTRIM(RTRIM(@i_businessValueName)),
                    @i_businessValueCreationDate,
                    @i_businessValueCreatorId,
                    NULL,
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_BUSINESS_VALUE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario =
                    'VALOR DE NEGOCIO REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_INS_BUSINESS_VALUE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL REGISTRAR EL VALOR DE NEGOCIO';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL REGISTRAR BUSINESS VALUE - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END


    -- ==========================================
    -- ACTUALIZAR BUSINESS VALUE
    -- ACCION: U
    -- ==========================================
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_businessValueId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL VALOR DE NEGOCIO ES OBLIGATORIO';
        END

        ELSE IF ISNULL(@i_businessValueModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_BusinessValues]
            WHERE businessValueId = @i_businessValueId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO NO EXISTE';
        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_businessValueModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO MODIFICADOR NO EXISTE';
        END

        ELSE IF @i_businessValueName IS NOT NULL
             AND LTRIM(RTRIM(@i_businessValueName)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL NOMBRE DEL VALOR DE NEGOCIO NO PUEDE ESTAR VACIO';
        END

        ELSE IF @i_businessValueName IS NOT NULL
             AND EXISTS
             (
                 SELECT 1
                 FROM [SQM_CATALOGS].[TBL_BusinessValues]
                 WHERE businessValueName =
                       LTRIM(RTRIM(@i_businessValueName))
                   AND businessValueId <> @i_businessValueId
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO YA EXISTE';
        END

        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_UPD_BUSINESS_VALUE;

                UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
                SET
                    businessValueName =
                        COALESCE(
                            LTRIM(RTRIM(@i_businessValueName)),
                            businessValueName
                        ),
                    businessValueModificationDate =
                        @i_businessValueModificationDate,
                    businessValueModificatorId =
                        @i_businessValueModificatorId,
                    businessValueEnable =
                        COALESCE(
                            @i_businessValueEnable,
                            businessValueEnable
                        )
                WHERE businessValueId = @i_businessValueId;

                COMMIT TRANSACTION TRX_UPD_BUSINESS_VALUE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario =
                    'VALOR DE NEGOCIO ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_UPD_BUSINESS_VALUE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL ACTUALIZAR EL VALOR DE NEGOCIO';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL ACTUALIZAR BUSINESS VALUE - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END

    -- LISTAR BUSINESS VALUES CON PAGINACION
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
                    businessValueId,
                    businessValueName,
                    businessValueCreationDate,
                    businessValueCreatorId,
                    businessValueModificationDate,
                    businessValueModificatorId,
                    businessValueEnable
                FROM [SQM_CATALOGS].[TBL_BusinessValues]
                ORDER BY businessValueId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario =
                        'VALORES DE NEGOCIO LISTADOS CORRECTAMENTE';
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
                    'ERROR AL LISTAR LOS VALORES DE NEGOCIO';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL LISTAR BUSINESS VALUES - ',
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