-- ============================================================
-- Employee Salary Management System
-- Employee Package
-- ============================================================

CREATE OR REPLACE PACKAGE emp_pkg AS

    PROCEDURE update_employee_salary (
        p_employee_id NUMBER
    );

    FUNCTION validate_salary (
        p_salary NUMBER
    ) RETURN VARCHAR2;

    FUNCTION validate_hire_date (
        p_hire_date DATE
    ) RETURN BOOLEAN;

END emp_pkg;
/

CREATE OR REPLACE PACKAGE BODY emp_pkg AS

    PROCEDURE update_employee_salary (
        p_employee_id NUMBER
    ) IS
        v_salary     employees.salary%TYPE;
        v_new_salary employees.salary%TYPE;
    BEGIN
        SELECT salary
        INTO v_salary
        FROM employees
        WHERE employee_id = p_employee_id;

        IF v_salary < 0 THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Salary cannot be negative'
            );
        END IF;

        IF v_salary < 3000 THEN
            v_new_salary := v_salary + 500;
        ELSE
            v_new_salary := v_salary + 200;
        END IF;

        UPDATE employees
        SET salary = v_new_salary
        WHERE employee_id = p_employee_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error(
                SQLCODE,
                SQLERRM,
                'update_employee_salary',
                APEX_APPLICATION.G_USER
            );

            RAISE_APPLICATION_ERROR(
                -20002,
                'Employee not found'
            );

        WHEN OTHERS THEN
            log_error(
                SQLCODE,
                SQLERRM,
                'update_employee_salary',
                APEX_APPLICATION.G_USER
            );
            RAISE;
    END update_employee_salary;


    FUNCTION validate_salary (
        p_salary NUMBER
    ) RETURN VARCHAR2
    IS
    BEGIN
        IF p_salary IS NULL THEN
            RETURN 'Salary is required';
        ELSIF p_salary < 0 THEN
            RETURN 'Salary cannot be negative';
        END IF;

        RETURN NULL;
    END validate_salary;


    FUNCTION validate_hire_date (
        p_hire_date DATE
    ) RETURN BOOLEAN
    IS
    BEGIN
        IF p_hire_date <= ADD_MONTHS(SYSDATE, 12)
           OR p_hire_date IS NULL THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END validate_hire_date;

END emp_pkg;
/