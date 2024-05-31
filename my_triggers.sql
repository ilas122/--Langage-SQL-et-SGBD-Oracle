--Trigers 
	--Question1 
CREATE OR REPLACE TRIGGER INSERT_WORKER_ALL_WORKERS_ELAPSED
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
DECLARE
    v_factory_id NUMBER;
BEGIN
    SELECT factory_id INTO v_factory_id FROM FACTORIES WHERE id = :NEW.factory_id;
    

    IF v_factory_id = 1 THEN
        INSERT INTO WORKERS_FACTORY_1 (id, first_name, last_name, age, first_day, last_day)
        VALUES (:NEW.id, :NEW.first_name, :NEW.last_name, :NEW.age, :NEW.first_day, :NEW.last_day);
    ELSIF v_factory_id = 2 THEN
        INSERT INTO WORKERS_FACTORY_2 (id, first_name, last_name, age, start_date, end_date)
        VALUES (:NEW.id, :NEW.first_name, :NEW.last_name, :NEW.age, :NEW.first_day, :NEW.last_day);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Factory not found for worker insertion.');
END;

	--Question2 
CREATE OR REPLACE TRIGGER AUDIT_ROBOT_CREATION
AFTER INSERT ON ROBOTS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, created_at)
    VALUES (:NEW.id, SYSDATE);
END;

	--Question3 
CREATE OR REPLACE TRIGGER CHECK_FACTORIES_WORKERS
BEFORE INSERT OR UPDATE OR DELETE ON ROBOTS_FACTORIES
DECLARE
    v_factories_count NUMBER;
    v_workers_tables_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_factories_count FROM FACTORIES;
    
    SELECT COUNT(*) INTO v_workers_tables_count
    FROM user_tables
    WHERE table_name LIKE 'WORKERS_FACTORY\_%' ESCAPE '\';
    
    IF v_factories_count <> v_workers_tables_count THEN
        RAISE_APPLICATION_ERROR(-20001, 'Number of factories is not equal to number of workers tables.');
    END IF;
END;



