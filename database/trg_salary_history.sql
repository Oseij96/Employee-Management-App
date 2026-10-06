-- ============================================================
-- Employee Salary Management System
-- Salary History Trigger
-- ============================================================

CREATE OR REPLACE TRIGGER trg_salary_history
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :OLD.salary != :NEW.salary THEN
        INSERT INTO salary_history (
            employee_id,
            old_salary,
            new_salary,
            change_date
        )
        VALUES (
            :OLD.employee_id,
            :OLD.salary,
            :NEW.salary,
            SYSDATE
        );
    END IF;
END;
/