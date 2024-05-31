--Fonctions 
	--Question1
CREATE OR REPLACE FUNCTION GET_NB_WORKERS(p_factory_id NUMBER) 
RETURN NUMBER 
IS
    v_nb_workers NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nb_workers
    FROM (
        SELECT worker_id
        FROM WORKERS_FACTORY_1
        WHERE factory_id = p_factory_id
        UNION ALL
        SELECT worker_id
        FROM WORKERS_FACTORY_2
        WHERE factory_id = p_factory_id
    );
    
    RETURN v_nb_workers;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END;

	--Question2
CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER 
IS
    v_nb_big_robots NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nb_big_robots
    FROM (
        SELECT robot_id
        FROM ROBOTS_HAS_SPARE_PARTS
        GROUP BY robot_id
        HAVING COUNT(*) > 3
    );
    
    RETURN v_nb_big_robots;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END;

	--Question3 
CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 
IS
    v_best_supplier_name VARCHAR2(100);
BEGIN
    SELECT name
    INTO v_best_supplier_name
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1; 
    
    RETURN v_best_supplier_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; 
END;

--Procedures 
CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) 
IS
    v_worker_id NUMBER;
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        SELECT COALESCE(MAX(id), 0) + 1 INTO v_worker_id FROM WORKERS_FACTORY_1;
        
        INSERT INTO WORKERS_FACTORY_1 (id, first_name, last_name, age, first_day)
        VALUES (v_worker_id, 'worker_f_' || v_worker_id, 'worker_l_' || v_worker_id, FLOOR(DBMS_RANDOM.VALUE(20, 60)), 
                TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J'));
    END LOOP;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;



