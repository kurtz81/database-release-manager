BEGIN TRANSACTION;

CREATE TABLE ScriptTypes (
   code            TEXT PRIMARY KEY UNIQUE,
   descr           TEXT NOT NULL
);

CREATE TABLE DatabaseAdapters (
   adapter         TEXT PRIMARY KEY UNIQUE,
   descr           TEXT NOT NULL
);

CREATE TABLE Releases (
   id_release      INTEGER PRIMARY KEY AUTOINCREMENT,
   name            TEXT NOT NULL,
   version         TEXT NOT NULL,
   release_date    DATE NOT NULL,
   creation_date   DATE NOT NULL,
   update_date     DATE NOT NULL,
   id_order        INTEGER NOT NULL,
   db_adapter      TEXT NOT NULL,
   id_branch       INTEGER NOT NULL DEFAULT 1,
   directory       TEXT NOT NULL DEFAULT '.',
   flag_dev        INTEGER NOT NULL DEFAULT 0,
   CONSTRAINT uc_name_version UNIQUE(name, version),
   CONSTRAINT uc_idorder_idbranch UNIQUE(id_order,id_branch),
   FOREIGN KEY(db_adapter) REFERENCES DatabaseAdapters(adapter),
   FOREIGN KEY(id_branch) REFERENCES Branches(id_branch)
);

CREATE TABLE Branches (
   id_branch       INTEGER PRIMARY KEY AUTOINCREMENT,
   name            TEXT UNIQUE NOT NULL,
   creation_date   DATE NOT NULL,
   update_date     DATE NOT NULL
);

-- ReleasesDependencies table
-- contains for every release
-- one record for every release dependency.
-- Example: from r. 0.1.0 -> 0.3.0
-- There are these record:
-- 0.3.0 (id_release) - 0.1.0 (id_release_dep)
-- 0.3.0 (id_release) - 0.2.0 (id_release_dep)
CREATE TABLE ReleasesDependencies (
   id_release     INTEGER NOT NULL,
   id_release_dep INTEGER NOT NULL,
   creation_date  DATE NOT NULL,
   PRIMARY KEY(id_release, id_release_dep),
   FOREIGN KEY(id_release_dep) REFERENCES Releases(id_release),
   FOREIGN KEY(id_release) REFERENCES Releases(id_release)
);

CREATE TABLE Scripts (
   id_script       INTEGER PRIMARY KEY AUTOINCREMENT,
   filename        TEXT NOT NULL,
   type            TEXT NOT NULL,
   active          INTEGER NOT NULL,
   directory       TEXT NOT NULL,
   id_release      INTEGER NOT NULL,
   id_order        INTEGER NOT NULL,
   creation_date   DATE NOT NULL,
   update_date     DATE NOT NULL,
   FOREIGN KEY(id_release) REFERENCES Releases(id_release),
   FOREIGN KEY(type)       REFERENCES ScriptTypes(code)
);

CREATE TABLE ScriptRelInhibitions (
  id_script        INTEGER NOT NULL,
  id_release_from  INTEGER NOT NULL,
  id_release_to    INTEGER NOT NULL,
  creation_date    DATE    NOT NULL,
  PRIMARY KEY(id_script, id_release_from, id_release_to),
  FOREIGN KEY(id_script)       REFERENCES Scripts(id_script),
  FOREIGN KEY(id_release_from) REFERENCES Releases(id_release),
  FOREIGN KEY(id_release_to)   REFERENCES Releases(id_release)
);

CREATE TABLE ScriptRelDedicated (
  id_script        INTEGER NOT NULL,
  id_release_from  INTEGER NOT NULL,
  id_release_to    INTEGER NOT NULL,
  creation_date    DATE    NOT NULL,
  PRIMARY KEY(id_script, id_release_from, id_release_to),
  FOREIGN KEY(id_script)       REFERENCES Scripts(id_script),
  FOREIGN KEY(id_release_from) REFERENCES Releases(id_release),
  FOREIGN KEY(id_release_to)   REFERENCES Releases(id_release)
);

INSERT INTO DatabaseAdapters (adapter, descr) VALUES('oracle', 'Oracle Database Adapter');
INSERT INTO DatabaseAdapters (adapter, descr) VALUES('mariadb', 'MySQL/MariaDb Database Adapter');
INSERT INTO DatabaseAdapters (adapter, descr) VALUES('sqlite', 'SQLite Database Adapter');

INSERT INTO ScriptTypes (code, descr) VALUES('initial_ddl', 'Initial DDL Script');
INSERT INTO ScriptTypes (code, descr) VALUES('update_script', 'Update Script');
INSERT INTO ScriptTypes (code, descr) VALUES('sequence', 'Sequences Script');
INSERT INTO ScriptTypes (code, descr) VALUES('foreign_key', 'Foreign Key Script');
INSERT INTO ScriptTypes (code, descr) VALUES('trigger', 'Trigger Script');
INSERT INTO ScriptTypes (code, descr) VALUES('type', 'Types Script (For example for a TYPE definition on Oracle)');
INSERT INTO ScriptTypes (code, descr) VALUES('insert', 'Insert on table script');
INSERT INTO ScriptTypes (code, descr) VALUES('function', 'Function definition script');
INSERT INTO ScriptTypes (code, descr) VALUES('procedure', 'Procedure definition script');
INSERT INTO ScriptTypes (code, descr) VALUES('view', 'View definition script');
INSERT INTO ScriptTypes (code, descr) VALUES('package', 'Package definition script');

INSERT INTO Branches (name, creation_date, update_date) VALUES ('master', DATETIME('now'), DATETIME('now'));

COMMIT;
