SET SERVEROUTPUT ON
DECLARE
    v_new_department_id NUMBER;
    v_department_name VARCHAR2(50) := 'Testing';
    v_manager_id NUMBER;
    v_location_id NUMBER;
    v_city_name VARCHAR2(50);
    
BEGIN
    -- Prompt for a valid city name without any department
    DBMS_OUTPUT.PUT('Please provide the valid city without department: ');
    DBMS_OUTPUT.NEW_LINE;
    v_city_name := UPPER('&v_city_name');

    -- Check if the city is not listed in the Locations table
    BEGIN
        SELECT Location_id INTO v_location_id
        FROM Locations
        WHERE UPPER(City) = v_city_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This city is NOT listed: ' || v_city_name);
            RETURN;
    END;

    -- Check if the city already contains one department
    SELECT COUNT(*) INTO v_manager_id
    FROM Departments
    WHERE Location_id = v_location_id;

    IF v_manager_id = 1 THEN
        DBMS_OUTPUT.PUT_LINE('This city already contains a department: ' || v_city_name);
            
        -- Display department details
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID|DEPARTMENT_NAME|MANAGER_ID|LOCATION_ID');
        FOR dept IN (
            SELECT Department_id, Department_name, Manager_id, Location_id
            FROM Departments
            WHERE Location_id = v_location_id
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(' ' || dept.Department_id || ' ' || dept.Department_name || ' ' || dept.Manager_id || ' ' || dept.Location_id);
        END LOOP;
            
    -- Check if the city contains more than one department
    ELSIF v_manager_id > 1 THEN
        DBMS_OUTPUT.PUT_LINE('This city has MORE THAN ONE department: ' || v_city_name);
    ELSE
        -- Find the manager with the most direct reports
        SELECT e.Manager_id INTO v_manager_id
        FROM Employees e
        JOIN Departments d ON e.Employee_id = d.Manager_id
        WHERE d.Location_id = v_location_id
        GROUP BY e.Manager_id
        HAVING COUNT(*) = (
            SELECT MAX(report_count)
            FROM (
                SELECT COUNT(*) AS report_count
                FROM Employees e2
                JOIN Departments d2 ON e2.Employee_id = d2.Manager_id
                WHERE d2.Location_id = v_location_id
                GROUP BY e2.Manager_id
            )
        );

        -- Get the highest existing Department_id and increase it by 50
        SELECT NVL(MAX(Department_id), 0) + 50 INTO v_new_department_id
        FROM Departments;

        -- Insert the new department
        INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id)
        VALUES (v_new_department_id, v_department_name, v_manager_id, v_location_id);

        -- Display the new row
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID ' || v_new_department_id || ' ' || v_department_name || ' ' || v_manager_id || ' ' || v_location_id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
SET SERVEROUTPUT OFF
