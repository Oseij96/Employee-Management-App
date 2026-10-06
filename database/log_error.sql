-- ============================================================
-- Employee Salary Management System
-- Error Logging Procedure
-- ============================================================

CREATE OR REPLACE PROCEDURE log_error (
    p_error_code    NUMBER,
    p_error_message VARCHAR2,
    p_module        VARCHAR2,
    p_user_name     VARCHAR2
) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO error_log (
        error_code,
        error_message,
        error_date,
        module,
        user_name
    )
    VALUES (
        p_error_code,
        p_error_message,
        SYSDATE,
        p_module,
        p_user_name
    );

    COMMIT;
END log_error;
/