USE [DB_SCRUM_PLANNING];
GO

CREATE OR ALTER PROC [SQM_GENERAL].[USP_Initiatives]
(
    @i_initiativeId INT = NULL,
    @i_initiativeSummary VARCHAR(200) = NULL,
    @i_initiativeDescription VARCHAR(2000) = NULL,
    @i_initiativeOwner INT = NULL,
    @i_initiativeGoals VARCHAR(255) = NULL,
    @i_initiativeBusinessValue INT = NULL,
    @i_initiativeTargetStart DATE = NULL,
    @i_initiativeTargetEnd DATE = NULL,
    @i_initiativeCreationDate DATETIME = NULL,
    @i_initiativeCreatorId INT = NULL,
    @i_initiativeModificationDate DATETIME = NULL,
    @i_initiativeModificatorId INT = NULL,
    @i_initiativeStatus INT = NULL,
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

    -- Fecha de creacion por defecto
    IF @i_initiativeCreationDate IS NULL
        SET @i_initiativeCreationDate = GETDATE();


    -- INSERTAR INITIATIVE
    -- ACCION: I
    -- ==========================================
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(LTRIM(RTRIM(@i_initiativeSummary)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL RESUMEN DE LA INICIATIVA ES OBLIGATORIO';
        END
        ELSE IF ISNULL(LTRIM(RTRIM(@i_initiativeDescription)), '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA DESCRIPCION DE LA INICIATIVA ES OBLIGATORIA';
        END
        ELSE IF ISNULL(@i_initiativeOwner, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL RESPONSABLE DE LA INICIATIVA ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_initiativeBusinessValue, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_initiativeCreatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL CREADOR DE LA INICIATIVA ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_initiativeStatus, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ESTADO DE LA INICIATIVA ES OBLIGATORIO';
        END
        ELSE IF @i_initiativeTargetStart IS NOT NULL
            AND @i_initiativeTargetEnd IS NOT NULL
            AND @i_initiativeTargetEnd < @i_initiativeTargetStart
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_initiativeOwner
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL RESPONSABLE DE LA INICIATIVA NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_initiativeCreatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO CREADOR NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_BusinessValues]
            WHERE businessValueId = @i_initiativeBusinessValue
              AND businessValueEnable = 1
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO NO EXISTE O ESTA DESHABILITADO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[TBL_Status]
            WHERE statusId = @i_initiativeStatus
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ESTADO DE LA INICIATIVA NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_INS_INITIATIVE;

                INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
                (
                    initiativeSummary,
                    initiativeDescription,
                    initiativeOwner,
                    initiativeGoals,
                    initiativeBusinessValue,
                    initiativeTargetStart,
                    initiativeTargetEnd,
                    initiativeCreationDate,
                    initiativeCreatorId,
                    initiativeModificationDate,
                    initiativeModificatorId,
                    initiativeStatus
                )
                VALUES
                (
                    LTRIM(RTRIM(@i_initiativeSummary)),
                    @i_initiativeDescription,
                    @i_initiativeOwner,
                    @i_initiativeGoals,
                    @i_initiativeBusinessValue,
                    @i_initiativeTargetStart,
                    @i_initiativeTargetEnd,
                    @i_initiativeCreationDate,
                    @i_initiativeCreatorId,
                    NULL,
                    NULL,
                    @i_initiativeStatus
                );

                COMMIT TRANSACTION TRX_INS_INITIATIVE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario =
                    'INICIATIVA REGISTRADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_INS_INITIATIVE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL REGISTRAR LA INICIATIVA';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL REGISTRAR INICIATIVA - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END


    -- ACTUALIZAR INITIATIVE
    -- ACCION: U
    -- ==========================================
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_initiativeId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DE LA INICIATIVA ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_initiativeModificatorId, 0) <= 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_initiativeId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario =
                'LA INICIATIVA NO EXISTE';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_SECURITY].[TBL_Users]
            WHERE userId = @i_initiativeModificatorId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL USUARIO MODIFICADOR NO EXISTE';
        END
        ELSE IF @i_initiativeSummary IS NOT NULL
             AND LTRIM(RTRIM(@i_initiativeSummary)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL RESUMEN NO PUEDE ESTAR VACIO';
        END
        ELSE IF @i_initiativeDescription IS NOT NULL
             AND LTRIM(RTRIM(@i_initiativeDescription)) = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA DESCRIPCION NO PUEDE ESTAR VACIA';
        END
        ELSE IF @i_initiativeOwner IS NOT NULL
             AND NOT EXISTS
             (
                 SELECT 1
                 FROM [SQM_SECURITY].[TBL_Users]
                 WHERE userId = @i_initiativeOwner
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL RESPONSABLE DE LA INICIATIVA NO EXISTE';
        END
        ELSE IF @i_initiativeBusinessValue IS NOT NULL
             AND NOT EXISTS
             (
                 SELECT 1
                 FROM [SQM_CATALOGS].[TBL_BusinessValues]
                 WHERE businessValueId = @i_initiativeBusinessValue
                   AND businessValueEnable = 1
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL VALOR DE NEGOCIO NO EXISTE O ESTA DESHABILITADO';
        END
        ELSE IF @i_initiativeStatus IS NOT NULL
             AND NOT EXISTS
             (
                 SELECT 1
                 FROM [SQM_CATALOGS].[TBL_Status]
                 WHERE statusId = @i_initiativeStatus
             )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'EL ESTADO DE LA INICIATIVA NO EXISTE';
        END
        ELSE IF
        (
            @i_initiativeTargetStart IS NOT NULL
            OR @i_initiativeTargetEnd IS NOT NULL
        )
        AND
        (
            SELECT COALESCE(
                @i_initiativeTargetStart,
                initiativeTargetStart
            )
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_initiativeId
        ) IS NOT NULL
        AND
        (
            SELECT COALESCE(
                @i_initiativeTargetEnd,
                initiativeTargetEnd
            )
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_initiativeId
        ) IS NOT NULL
        AND
        (
            SELECT COALESCE(
                @i_initiativeTargetEnd,
                initiativeTargetEnd
            )
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_initiativeId
        )
        <
        (
            SELECT COALESCE(
                @i_initiativeTargetStart,
                initiativeTargetStart
            )
            FROM [SQM_GENERAL].[TBL_Initiatives]
            WHERE initiativeId = @i_initiativeId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario =
                'LA FECHA FINAL NO PUEDE SER MENOR QUE LA FECHA INICIAL';
        END
        ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION TRX_UPD_INITIATIVE;

                UPDATE [SQM_GENERAL].[TBL_Initiatives]
                SET
                    initiativeSummary =
                        COALESCE(
                            LTRIM(RTRIM(@i_initiativeSummary)),
                            initiativeSummary
                        ),
                    initiativeDescription =
                        COALESCE(
                            @i_initiativeDescription,
                            initiativeDescription
                        ),
                    initiativeOwner =
                        COALESCE(
                            @i_initiativeOwner,
                            initiativeOwner
                        ),
                    initiativeGoals =
                        COALESCE(
                            @i_initiativeGoals,
                            initiativeGoals
                        ),
                    initiativeBusinessValue =
                        COALESCE(
                            @i_initiativeBusinessValue,
                            initiativeBusinessValue
                        ),
                    initiativeTargetStart =
                        COALESCE(
                            @i_initiativeTargetStart,
                            initiativeTargetStart
                        ),
                    initiativeTargetEnd =
                        COALESCE(
                            @i_initiativeTargetEnd,
                            initiativeTargetEnd
                        ),
                    initiativeStatus =
                        COALESCE(
                            @i_initiativeStatus,
                            initiativeStatus
                        ),
                    initiativeModificationDate =
                        COALESCE(
                            @i_initiativeModificationDate,
                            GETDATE()
                        ),
                    initiativeModificatorId =
                        @i_initiativeModificatorId
                WHERE initiativeId = @i_initiativeId;

                COMMIT TRANSACTION TRX_UPD_INITIATIVE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario =
                    'INICIATIVA ACTUALIZADA CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF XACT_STATE() <> 0
                    ROLLBACK TRANSACTION TRX_UPD_INITIATIVE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario =
                    'ERROR AL ACTUALIZAR LA INICIATIVA';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL ACTUALIZAR INICIATIVA - ',
                        ERROR_PROCEDURE(), ' - ',
                        ERROR_LINE(), ' - ',
                        ERROR_MESSAGE()
                    ), 500);
            END CATCH
        END
    END

    -- LISTAR INITIATIVES CON PAGINACION
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
                    initiativeId,
                    initiativeSummary,
                    initiativeDescription,
                    initiativeOwner,
                    initiativeGoals,
                    initiativeBusinessValue,
                    initiativeTargetStart,
                    initiativeTargetEnd,
                    initiativeCreationDate,
                    initiativeCreatorId,
                    initiativeModificationDate,
                    initiativeModificatorId,
                    initiativeStatus
                FROM [SQM_GENERAL].[TBL_Initiatives]
                ORDER BY initiativeId
                OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
                FETCH NEXT @i_RowsPerPage ROWS ONLY;

                SET @w_totalRows = @@ROWCOUNT;

                IF @w_totalRows > 0
                BEGIN
                    SET @o_Numero = 200;
                    SET @o_MensajeUsuario =
                        'INICIATIVAS LISTADAS CORRECTAMENTE';
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
                    'ERROR AL LISTAR LAS INICIATIVAS';

                SET @o_MensajeTecnico =
                    LEFT(CONCAT(
                        'ERROR AL LISTAR INICIATIVAS - ',
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