/* DEPLOYING WEBAPP ENVIRONMENT step2 */

--Creating Table
CREATE TABLE animals (
  name   VARCHAR(10) UNIQUE NOT NULL,
  class  VARCHAR(20) NOT NULL,
  gender VARCHAR(1)  NOT NULL
);

--Inserting Data
INSERT INTO animals (name, class, gender)
     values ('spike', 'dog', 'm'),
            ('skooby', 'dog', 'm'),
            ('sandra', 'dog', 'f'),
            ('luna', 'cat', 'f'),
            ('sugar', 'cat', 'f'),
            ('tom', 'cat', 'm'),
            ('watson', 'cat', 'm'),
            ('jake', 'parrot', 'm'),
            ('mary', 'parrot', 'f');
