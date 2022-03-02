CREATE TABLE archive(
  archived_id serial not null,
  archived_name text NOT NULL,
  archived_age int NOT NULL
);

CREATE OR REPLACE FUNCTION insertUser()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO archive (archived_id, archived_name, archived_age)
  VALUES(OLD.user_id, OLD.user_name, OLD.user_age);
  RETURN OLD;
END;
$$;

CREATE TRIGGER handleDelete
BEFORE DELETE
ON users
FOR EACH ROW
EXECUTE PROCEDURE insertUser();

DELETE FROM users WHERE user_id = 2;

--! ----------------------------- BEFORE UPDATE ---------------------------------------------------------


CREATE OR REPLACE FUNCTION updateUser()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN 
  IF
    OLD.user_name <> NEW.user_name
  THEN
    INSERT INTO archive(archived_id, archived_name, archived_age)
    VALUES(OLD.user_id, ('Yangi ism: ' || NEW.user_name || ', Eski ism: ' || OLD.user_name), OLD.user_age);
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER handleUpdate
BEFORE UPDATE
ON users
FOR EACH ROW
EXECUTE PROCEDURE updateUser();

UPDATE users SET user_name = 'Sardor' WHERE user_id = 3;

--! ----------------------------- BEFORE INSERT ---------------------------------------------------------
CREATE OR REPLACE FUNCTION copyUser()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO archive(archived_id, archived_name, archived_age)
  VALUES(NEW.user_id, NEW.user_name, NEW.user_age);
  RETURN NEW;
END;
$$;

CREATE TRIGGER handleCopyUser
BEFORE INSERT
ON users
FOR EACH ROW
EXECUTE PROCEDURE copyUser();


INSERT INTO users(user_name, user_age) VALUES ('Abdumalik', 20);