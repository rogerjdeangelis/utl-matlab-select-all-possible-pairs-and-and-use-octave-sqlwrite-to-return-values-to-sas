%let pgm=utl-matlab-select-all-possible-pairs-and-and-use-octave-sqlwrite-to-return-values-to-sas;

%stop-submission;

MATLAB select all possible pairs and and use octave sqlwrite to return values to sas;

   TWO SOLUTIONS (note you can subsitute Python for R?)

        1 matlab sql  (code works in Matlab. octave, R, Python, SAS, and indirectly excel)
        2 matlab base

github
https://tinyurl.com/5b65ty7w
https://github.com/rogerjdeangelis/utl-matlab-select-all-possible-pairs-and-and-use-octave-sqlwrite-to-return-values-to-sas

stack overflow matlab
https://tinyurl.com/mz8v4j9f
https://stackoverflow.com/questions/7446946/how-to-generate-all-pairs-from-two-vectors-in-matlab-using-vectorised-code

PROBLEM FORM THE CATESIAN JOIN OF THE TWO OBJECTS
=================================================

      INPUT         OUTPUT
      =====         ======

     Table VEC1   Table All PAIRS

     vec  vec     pair1 pair

      1    1        1     1
      2    2        1     2
      3    3        1     3
      4             2     1
                    2     2
                    2     3
                    3     1
                    3     2
                    3     3
                    4     1
                    4     2
                    4     3

SOAPBOX ON

  The diffuculty with matlab, like Python and a little less with R is the
  dozen of data structures. When you have multiple data structures you need
  many functions, not to mention element access using "{[(:'", to read and convert one structure to another.
  I tried to concentrate on dbtable aand table structures in octave/matlab, which
  seem to be addon structures, you need two packaages to use them.
  Tables and dbtables are the easiest structures to connect with sqllite.
  In the code below vec1, vec2 and pairs are dbtables, however I had to convert vec1 and vec2 to a matrix
  and create two another vector like structures, doubles', pair and pair2 to get the loop to work?

SOAPBOX OFF

/**************************************************************************************************************************/
/*    INPUT                           |      PROCESS                                      |       OUTPUT                  */
/*    =====                           |     =======                                       |       ======                  */
/* sd1.vec1 sd1.vec2                  | 1 JUST OCTAVE SQLITE                              |                               */
/*                                    | ====================                              | SQLITE PAIRSQL TABLE          */
/* vec     vec                        |                                                   |                               */
/*                                    | STEPS                                             | cid  name   type  null  pk    */
/*  1       1                         |                                                   | ___  _____  ____  ____  ___   */
/*  2       2                         |   a done entirely in octave sqlite                |                               */
/*  3       3                         |   b octave can do further processing              | 0    pair1  REAL  0      0    */
/*  4                                 |     or send result R, SAS, Python Excel           | 1    pair2  REAL  0      0    */
/*                                    |                                                   |                               */
/* SQLITE TABLES (vec1,vec2)          | %utl_mbegin;                                      |                               */
/*                                    | parmcards4;                                       | SAS DATASET WANT              */
/* TABLE VEC1, VEC2 is the same       | pkg load database                                 |                               */
/*                                    | pkg load sqlite                                   |                               */
/* +  ,"SELECT                        | pkg load io                                       | Obs rownames  pair1 pair2     */
/* +      *                           | pkg load tablicious                               |                               */
/* +    FROM                          | db = sqlite("d:/sqlite/have.db");                 |   1     1       1     1       */
/* +      vec1")                      | execute(db, 'drop table if exists pairsql')       |   2     2       1     2       */
/*   vec                              | execute(db                      ...               |   3     3       1     3       */
/* 1   1                              |  ,["  create                  " ...               |   4     4       2     1       */
/* 2   2                              |    "    table pairsql as      " ...               |   5     5       2     2       */
/* 3   3                              |    "  select                  " ...               |   6     6       2     3       */
/* 4   4                              |    "    vec1.vec as pair1     " ...               |   7     7       3     1       */
/*                                    |    "   ,vec2.vec as pair2     " ...               |   8     8       3     2       */
/* > dbGetQuery(con                   |    "  from                    " ...               |   9     9       3     3       */
/* +  ,"SELECT                        |    "    vec1 inner join vec2  " ...               |  10    10       4     1       */
/* +      *                           |    "  on                      " ...               |  11    11       4     2       */
/* +  FROM                            |    "    1=1                   " ...               |  12    12       4     3       */
/* +    pragma_table_info('vec1')")   | ]);                                               |                               */
/*   Table VEC1                       | % check sqlite result                             |                               */
/*              not                   | dic=fetch(db,"PRAGMA table_info('pairsql');")     |                               */
/*   name type null dflt pk           | chk=fetch(db,"select * from pairsql")             |                               */
/* 1  vec REAL    0  NA  0            | close(db)                                         |                               */
/*                                    | ;;;;                                              |                               */
/* > dbDisconnect(con)                | %utl_mend;                                        |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/* options                            | BACK TO SAS                                       |                               */
/*   validvarname=v7;                 | ===========                                       |                               */
/* libname sd1 "d:/sd1";              |                                                   |                               */
/* data sd1.vec1 sd1.vec2;            | %utl_rbeginx;                                     |                               */
/*  do vec=1 to 4;                    | parmcards4;                                       |                               */
/*   output sd1.vec1;                 | library(haven)                                    |                               */
/*   if vec ne 4 then output sd1.vec2;| library(DBI)                                      |                               */
/*  end;                              | library(RSQLite)                                  |                               */
/* run;quit;                          | library(sqldf)                                    |                               */
/*                                    |                                                   |                               */
/* %utl_rbeginx;                      | source("c:/oto/fn_tosas9x.R")                     |                               */
/* parmcards4;                        | con <- dbConnect(                                 |                               */
/* library(haven)                     |     RSQLite::SQLite()                             |                               */
/* library(DBI)                       |    ,"d:/sqlite/have.db")                          |                               */
/* library(RSQLite)                   | dbListTables(con)                                 |                               */
/* vec1<-read_sas(                    | df <- dbReadTable(con, "pairsql")                 |                               */
/*  "d:/sd1/vec1.sas7bdat")           | df                                                |                               */
/* vec2<-read_sas(                    | fn_tosas9x(                                       |                               */
/*  "d:/sd1/vec2.sas7bdat")           |       inp    = df                                 |                               */
/* vec1                               |      ,outlib ="d:/sd1/"                           |                               */
/* con <- dbConnect(                  |      ,outdsn ="want"                              |                               */
/*     RSQLite::SQLite()              |      )                                            |                               */
/*    ,"d:/sqlite/have.db")           | ;;;;                                              |                               */
/* dbRemoveTable(db, "vec1")          | %utl_rendx;                                       |                               */
/* dbRemoveTable(db, "vec2")          |                                                   |                               */
/* dbWriteTable(                      | libname sd1 "d:/sd1";                             |                               */
/*     con                            | proc print data=sd1.want;                         |                               */
/*   ,"vec1"                          | run;quit;                                         |                               */
/*   ,vec1)                           |                                                   |                               */
/* dbWriteTable(                      | --------------------------------------------------|-------------------------------*/
/*     con                            |                                                   |                               */
/*   ,"vec2"                          | 2 BASE MATLAB AND SQLITE                          | SQLITE PAIRS TABLE            */
/*   ,vec2)                           | ========================                          |                               */
/* dbListTables(con)                  |                                                   | cid  name   type  null  pk    */
/* dbGetQuery(                        | Steps                                             | ___  _____  ____  ____  ___   */
/*    con                             |                                                   |                               */
/*  ,"SELECT                          |   a octave: get sqlite tables vec1 vec2           | 0    pair1  REAL  0      0    */
/*      *                             |   b Octave: octave cartesian loop                 | 1    pair2  REAL  0      0    */
/*    FROM                            |   c Octave: output table to sqlite                |                               */
/*      vec1")                        |   d R read: sqlite octave table                   |                               */
/* dbGetQuery(con                     |   e R: convert to sas datset                      | SAS DATASET WANT              */
/*  ,"SELECT                          |                                                   |                               */
/*     *                              |                                                   |                               */
/*   FROM                             | * this works;                                     | Obs rownames  pair1 pair2     */
/*    pragma_table_info('vec1')")     |                                                   |                               */
/* dbDisconnect(con)                  | %utl_mbegin;                                      |   1     1       1     1       */
/* ;;;;                               | parmcards4;                                       |   2     2       1     2       */
/* %utl_rendx;                        | pkg load database                                 |   3     3       1     3       */
/*                                    | pkg load sqlite                                   |   4     4       2     1       */
/*                                    | pkg load io                                       |   5     5       2     2       */
/*                                    | pkg load tablicious                               |   6     6       2     3       */
/*                                    |                                                   |   7     7       3     1       */
/*                                    | db = sqlite("d:/sqlite/have.db");                 |   8     8       3     2       */
/*                                    | vec1 = fetch(db, 'select * from vec1');           |   9     9       3     3       */
/*                                    | vec2 = fetch(db, 'select * from vec2');           |  10    10       4     1       */
/*                                    |                                                   |  11    11       4     2       */
/*                                    | pair1 = zeros(12,1);                              |  12    12       4     3       */
/*                                    | pair2 = zeros(12,1);                              |                               */
/*                                    | i = 0;                                            |                               */
/*                                    | for val1 = 1:4                                    |                               */
/*                                    |   for val2 = 1:3                                  |                               */
/*                                    |     i = i + 1;                                    |                               */
/*                                    |     pair1(i) = cell2mat(vec1.vec(val1));          |                               */
/*                                    |     pair2(i) = cell2mat(vec2.vec(val2));          |                               */
/*                                    |   end                                             |                               */
/*                                    | end                                               |                               */
/*                                    | pairs = table(pair1, pair2);                      |                               */
/*                                    | disp(pairs)                                       |                               */
/*                                    | execute(db, 'drop table if exists pairs');        |                               */
/*                                    | sqlwrite(db                                       |                               */
/*                                    |    ,"pairs"                                       |                               */
/*                                    |    ,pairs                                         |                               */
/*                                    |    ,'ColumnType'                                  |                               */
/*                                    |    ,{'numeric', 'numeric'});                      |                               */
/*                                    | chk=vec1 = fetch(db, 'select * from pairs')       |                               */
/*                                    | disp(chk)                                         |                               */
/*                                    | dic=fetch(db,"PRAGMA table_info('pairsql');")     |                               */
/*                                    | disp(dic)                                         |                               */
/*                                    | close(db)                                         |                               */
/*                                    | ;;;;                                              |                               */
/*                                    | %utl_mend;                                        |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    | %utl_rbeginx;                                     |                               */
/*                                    | parmcards4;                                       |                               */
/*                                    | library(haven)                                    |                               */
/*                                    | library(DBI)                                      |                               */
/*                                    | library(RSQLite)                                  |                               */
/*                                    | library(sqldf)                                    |                               */
/*                                    |                                                   |                               */
/*                                    | source("c:/oto/fn_tosas9x.R")                     |                               */
/*                                    | con <- dbConnect(                                 |                               */
/*                                    |     RSQLite::SQLite()                             |                               */
/*                                    |    ,"d:/sqlite/have.db")                          |                               */
/*                                    | dbListTables(con)                                 |                               */
/*                                    | df <- dbReadTable(con, "pairs")                   |                               */
/*                                    | df                                                |                               */
/*                                    | fn_tosas9x(                                       |                               */
/*                                    |       inp    = df                                 |                               */
/*                                    |      ,outlib ="d:/sd1/"                           |                               */
/*                                    |      ,outdsn ="want"                              |                               */
/*                                    |      )                                            |                               */
/*                                    | ;;;;                                              |                               */
/*                                    | %utl_rendx;                                       |                               */
/*                                    |                                                   |                               */
/*                                    | libname sd1 "d:/sd1";                             |                               */
/*                                    | proc print data=sd1.want;                         |                               */
/*                                    | run;quit;                                         |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/*                                    |                                                   |                               */
/******************************************|*******************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options
  validvarname=v7;
libname sd1 "d:/sd1";
data sd1.vec1 sd1.vec2;
 do vec=1 to 4;
  output sd1.vec1;
  if vec ne 4 then output sd1.vec2;
 end;
run;quit;

%utlfkil(d:/sqlite/have.db);

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
vec1<-read_sas(
 "d:/sd1/vec1.sas7bdat")
vec2<-read_sas(
 "d:/sd1/vec2.sas7bdat")
vec1
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbWriteTable(
    con
  ,"vec1"
  ,vec1)
dbWriteTable(
    con
  ,"vec2"
  ,vec2)
dbListTables(con)
dbGetQuery(
   con
 ,"SELECT
     *
   FROM
     vec1")
dbGetQuery(con
 ,"SELECT
    *
  FROM
   pragma_table_info('vec1')")
dbDisconnect(con)
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/*  Input SAS tables  (same in SQLITE)                                                                                    */
/*                                                                                                                        */
/*  sd1.vec1 |  sd1.vec2                                                                                                  */
/*  ======== |  ========                                                                                                  */
/*  vec      |   vec                                                                                                      */
/*           |                                                                                                            */
/*   1       |   1                                                                                                        */
/*   2       |   2                                                                                                        */
/*   3       |   3                                                                                                        */
/*   4       |                                                                                                            */
/*                                                                                                                        */
/*  INPUT SQLITE TABLES                                                                                                   */
/*                                                                                                                        */
/*  Table VEC1                                                                                                            */
/*               not                                                                                                      */
/*    name type null dflt pk                                                                                              */
/*  1  vec REAL    0  NA  0                                                                                               */
/*                                                                                                                        */
/*  Table VEC2                                                                                                            */
/*               not                                                                                                      */
/*    name type null dflt pk                                                                                              */
/*  1  vec REAL    0  NA  0                                                                                               */
/**************************************************************************************************************************/

/*                   _   _       _                 _
/ |  _ __ ___   __ _| |_| | __ _| |__    ___  __ _| |
| | | `_ ` _ \ / _` | __| |/ _` | `_ \  / __|/ _` | |
| | | | | | | | (_| | |_| | (_| | |_) | \__ \ (_| | |
|_| |_| |_| |_|\__,_|\__|_|\__,_|_.__/  |___/\__, |_|
                                                |_|
*/

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("d:/sqlite/have.db");
execute(db, 'drop table if exists pairsql')
execute(db                      ...
 ,["  create                  " ...
   "    table pairsql as      " ...
   "  select                  " ...
   "    vec1.vec as pair1     " ...
   "   ,vec2.vec as pair2     " ...
   "  from                    " ...
   "    vec1 inner join vec2  " ...
   "  on                      " ...
   "    1=1                   " ...
]);
% check sqlite result
dic=fetch(db,"PRAGMA table_info('pairsql');")
chk=fetch(db,"select * from pairsql")
close(db)
;;;;
%utl_mend;


BACK TO SAS
===========

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
library(sqldf)

source("c:/oto/fn_tosas9x.R")
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbListTables(con)
df <- dbReadTable(con, "pairsql")
df
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*  SQLITE PAIRS TABLE                                                                                                    */
/*                                                                                                                        */
/*  cid  name   type  null  pk                                                                                            */
/*  ___  _____  ____  ____  ___                                                                                           */
/*                                                                                                                        */
/*  0    pair1  REAL  0      0                                                                                            */
/*  1    pair2  REAL  0      0                                                                                            */
/*                                                                                                                        */
/*                                                                                                                        */
/*  SAS DATASET WANT                                                                                                      */
/*                                                                                                                        */
/*  Obs rownames  pair1 pair2                                                                                             */
/*                                                                                                                        */
/*    1     1       1     1                                                                                               */
/*    2     2       1     2                                                                                               */
/*    3     3       1     3                                                                                               */
/*    4     4       2     1                                                                                               */
/*    5     5       2     2                                                                                               */
/*    6     6       2     3                                                                                               */
/*    7     7       3     1                                                                                               */
/*    8     8       3     2                                                                                               */
/*    9     9       3     3                                                                                               */
/*   10    10       4     1                                                                                               */
/*   11    11       4     2                                                                                               */
/*   12    12       4     3                                                                                               */
/**************************************************************************************************************************/

/*___                    _   _       _       _
|___ \   _ __ ___   __ _| |_| | __ _| |__   | |__   __ _ ___  ___
  __) | | `_ ` _ \ / _` | __| |/ _` | `_ \  | `_ \ / _` / __|/ _ \
 / __/  | | | | | | (_| | |_| | (_| | |_) | | |_) | (_| \__ \  __/
|_____| |_| |_| |_|\__,_|\__|_|\__,_|_.__/  |_.__/ \__,_|___/\___|

*/

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious

db = sqlite("d:/sqlite/have.db");
vec1 = fetch(db, 'select * from vec1');
vec2 = fetch(db, 'select * from vec2');

pair1 = zeros(12,1);
pair2 = zeros(12,1);
i = 0;
for val1 = 1:4
  for val2 = 1:3
    i = i + 1;
    pair1(i) = cell2mat(vec1.vec(val1));
    pair2(i) = cell2mat(vec2.vec(val2));
  end
end
pairs = table(pair1, pair2);
disp(pairs)
execute(db, 'drop table if exists pairs');
sqlwrite(db
   ,"pairs"
   ,pairs
   ,'ColumnType'
   ,{'numeric', 'numeric'});
chk=vec1 = fetch(db, 'select * from pairs')
disp(chk)
dic=fetch(db,"PRAGMA table_info('pairsql');")
disp(dic)
close(db)
;;;;
%utl_mend;

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
library(sqldf)

source("c:/oto/fn_tosas9x.R")
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbListTables(con)
df <- dbReadTable(con, "pairs")
df
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SQLITE PAIRS TABLE                                                                                                     */
/*                                                                                                                        */
/* cid  name   type  null  pk                                                                                             */
/* ___  _____  ____  ____  ___                                                                                            */
/*                                                                                                                        */
/* 0    pair1  REAL  0      0                                                                                             */
/* 1    pair2  REAL  0      0                                                                                             */
/*                                                                                                                        */
/*                                                                                                                        */
/* SAS DATASET WANT                                                                                                       */
/*                                                                                                                        */
/*                                                                                                                        */
/* Obs rownames  pair1 pair2                                                                                              */
/*                                                                                                                        */
/*   1     1       1     1                                                                                                */
/*   2     2       1     2                                                                                                */
/*   3     3       1     3                                                                                                */
/*   4     4       2     1                                                                                                */
/*   5     5       2     2                                                                                                */
/*   6     6       2     3                                                                                                */
/*   7     7       3     1                                                                                                */
/*   8     8       3     2                                                                                                */
/*   9     9       3     3                                                                                                */
/*  10    10       4     1                                                                                                */
/*  11    11       4     2                                                                                                */
/*  12    12       4     3                                                                                                */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/


















































Input SAS tables

sd1.vec1 |  sd1.vec2
======== |  ========
vec      |   vec
         |
 1       |   1
 2       |   2
 3       |   3
 4       |

INPUT SQLITE TABLES

Table VEC1
             not
  name type null dflt pk
1  vec REAL    0  NA  0

Table VEC2
             not
  name type null dflt pk
1  vec REAL    0  NA  0






SQLITE TABLES (vec1,vec2)

TABLE VEC1, VEC2 is the same

+  ,"SELECT
+      *
+    FROM
+      vec1")
  vec
1   1
2   2
3   3
4   4

> dbGetQuery(con
+  ,"SELECT
+      *
+  FROM
+    pragma_table_info('vec1')")
  Table VEC1
             not
  name type null dflt pk
1  vec REAL    0  NA  0


   INPUT                                      PROCESS                                                    OUTPUT
   =====                                     =======                                                     ======
sd1.vec1 sd1.vec2                        1 JUST OCTAVE SQLITE
                                         ====================                                      SQLITE PAIRSQL TABLE
vec     vec
                                         STEPS                                                     cid  name   type  null  pk
 1       1                                                                                         ___  _____  ____  ____  ___
 2       2                                 a done entirely in octave sqlite
 3       3                                 b octave can do further processing                      0    pair1  REAL  0      0
 4                                           or send result R, SAS, Python Excel                   1    pair2  REAL  0      0

SQLITE TABLES (vec1,vec2)                %utl_mbegin;
                                         parmcards4;                                               SAS DATASET WANT
TABLE VEC1, VEC2 is the same             pkg load database
                                         pkg load sqlite
+  ,"SELECT                              pkg load io                                               Obs rownames  pair1 pair2
+      *                                 pkg load tablicious
+    FROM                                db = sqlite("d:/sqlite/have.db");                           1     1       1     1
+      vec1")                            execute(db, 'drop table if exists pairsql')                 2     2       1     2
  vec                                    execute(db                      ...                         3     3       1     3
1   1                                     ,["  create                  " ...                         4     4       2     1
2   2                                       "    table pairsql as      " ...                         5     5       2     2
3   3                                       "  select                  " ...                         6     6       2     3
4   4                                       "    vec1.vec as pair1     " ...                         7     7       3     1
                                            "   ,vec2.vec as pair2     " ...                         8     8       3     2
> dbGetQuery(con                            "  from                    " ...                         9     9       3     3
+  ,"SELECT                                 "    vec1 inner join vec2  " ...                        10    10       4     1
+      *                                    "  on                      " ...                        11    11       4     2
+  FROM                                     "    1=1                   " ...                        12    12       4     3
+    pragma_table_info('vec1')")         ]);
  Table VEC1                             % check sqlite result
             not                         dic=fetch(db,"PRAGMA table_info('pairsql');")
  name type null dflt pk                 chk=fetch(db,"select * from pairsql")
1  vec REAL    0  NA  0                  close(db)
                                         ;;;;
> dbDisconnect(con)                      %utl_mend;


options                                  BACK TO SAS
  validvarname=v7;                       ===========
libname sd1 "d:/sd1";
data sd1.vec1 sd1.vec2;                  %utl_rbeginx;
 do vec=1 to 4;                          parmcards4;
  output sd1.vec1;                       library(haven)
  if vec ne 4 then output sd1.vec2;      library(DBI)
 end;                                    library(RSQLite)
run;quit;                                library(sqldf)

%utl_rbeginx;                            source("c:/oto/fn_tosas9x.R")
parmcards4;                              con <- dbConnect(
library(haven)                               RSQLite::SQLite()
library(DBI)                                ,"d:/sqlite/have.db")
library(RSQLite)                         dbListTables(con)
vec1<-read_sas(                          df <- dbReadTable(con, "pairsql")
 "d:/sd1/vec1.sas7bdat")                 df
vec2<-read_sas(                          fn_tosas9x(
 "d:/sd1/vec2.sas7bdat")                       inp    = df
vec1                                          ,outlib ="d:/sd1/"
con <- dbConnect(                             ,outdsn ="want"
    RSQLite::SQLite()                         )
   ,"d:/sqlite/have.db")                 ;;;;
dbRemoveTable(db, "vec1")                %utl_rendx;
dbRemoveTable(db, "vec2")
dbWriteTable(                            libname sd1 "d:/sd1";
    con                                  proc print data=sd1.want;
  ,"vec1"                                run;quit;
  ,vec1)
dbWriteTable(                            ----------------------------------------------------------------------------------------------------------------------
    con
  ,"vec2"                                2 BASE MATLAB AND SQLITE                                  SQLITE PAIRS TABLE
  ,vec2)                                 ========================
dbListTables(con)                                                                                  cid  name   type  null  pk
dbGetQuery(                              Steps                                                     ___  _____  ____  ____  ___
   con
 ,"SELECT                                  a octave: get sqlite tables vec1 vec2                   0    pair1  REAL  0      0
     *                                     b Octave: octave cartesian loop                         1    pair2  REAL  0      0
   FROM                                    c Octave: output table to sqlite
     vec1")                                d R read: sqlite octave table
dbGetQuery(con                             e R: convert to sas datset                              SAS DATASET WANT
 ,"SELECT
    *
  FROM                                   * this works;                                             Obs rownames  pair1 pair2
   pragma_table_info('vec1')")
dbDisconnect(con)                        %utl_mbegin;                                                1     1       1     1
;;;;                                     parmcards4;                                                 2     2       1     2
%utl_rendx;                              pkg load database                                           3     3       1     3
                                         pkg load sqlite                                             4     4       2     1
                                         pkg load io                                                 5     5       2     2
                                         pkg load tablicious                                         6     6       2     3
                                                                                                     7     7       3     1
                                         db = sqlite("d:/sqlite/have.db");                           8     8       3     2
                                         vec1 = fetch(db, 'select * from vec1');                     9     9       3     3
                                         vec2 = fetch(db, 'select * from vec2');                    10    10       4     1
                                                                                                    11    11       4     2
                                         pair1 = zeros(12,1);                                       12    12       4     3
                                         pair2 = zeros(12,1);
                                         i = 0;
                                         for val1 = 1:4
                                           for val2 = 1:3
                                             i = i + 1;
                                             pair1(i) = cell2mat(vec1.vec(val1));
                                             pair2(i) = cell2mat(vec2.vec(val2));
                                           end
                                         end
                                         pairs = table(pair1, pair2);
                                         disp(pairs)
                                         execute(db, 'drop table if exists pairs');
                                         sqlwrite(db
                                            ,"pairs"
                                            ,pairs
                                            ,'ColumnType'
                                            ,{'numeric', 'numeric'});
                                         chk=vec1 = fetch(db, 'select * from pairs')
                                         disp(chk)
                                         dic=fetch(db,"PRAGMA table_info('pairsql');")
                                         disp(dic)
                                         close(db)
                                         ;;;;
                                         %utl_mend;



                                         %utl_rbeginx;
                                         parmcards4;
                                         library(haven)
                                         library(DBI)
                                         library(RSQLite)
                                         library(sqldf)

                                         source("c:/oto/fn_tosas9x.R")
                                         con <- dbConnect(
                                             RSQLite::SQLite()
                                            ,"d:/sqlite/have.db")
                                         dbListTables(con)
                                         df <- dbReadTable(con, "pairs")
                                         df
                                         fn_tosas9x(
                                               inp    = df
                                              ,outlib ="d:/sd1/"
                                              ,outdsn ="want"
                                              )
                                         ;;;;
                                         %utl_rendx;

                                         libname sd1 "d:/sd1";
                                         proc print data=sd1.want;
                                         run;quit;





 pair1  pair2
 _____  _____

 1      1
 1      2
 1      3
 2      1
 2      2
 2      3
 3      1
 3      2
 3      3
 4      1
 4      2
 4      3





















               PROCESS
               =======


2 BASE MATLAB AND SQLITE
========================

Steps

  a octave: get sqlite tables vec1 vec2
  b Octave: octave cartesian loop
  c Octave: output table to sqlite
  d R read: sqlite octave table
  e R: convert to sas datset


* this works;

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious

db = sqlite("d:/sqlite/have.db");
vec1 = fetch(db, 'select * from vec1');
vec2 = fetch(db, 'select * from vec2');

pair1 = zeros(12,1);
pair2 = zeros(12,1);
i = 0;
for val1 = 1:4
  for val2 = 1:3
    i = i + 1;
    pair1(i) = cell2mat(vec1.vec(val1));
    pair2(i) = cell2mat(vec2.vec(val2));
  end
end
pairs = table(pair1, pair2);
disp(pairs)
execute(db, 'drop table if exists pairs');
sqlwrite(db
   ,"pairs"
   ,pairs
   ,'ColumnType'
   ,{'numeric', 'numeric'});
chk=vec1 = fetch(db, 'select * from pairs')
disp(chk)
close(db)
;;;;
%utl_mend;



%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
library(sqldf)

source("c:/oto/fn_tosas9x.R")
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbListTables(con)
df <- dbReadTable(con, "pairs")
df
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;




1 just octave sqlite
====================

STEPS

  a done entirely in octave sqlite
  b octave can do further processing
    or send result R, SAS, Python Excel

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("d:/sqlite/have.db");
execute(db, 'drop table if exists pairsql');
execute(db                       ...
 ,["  create                  " ...
   "    table pairsql as      " ...
   "  select                  " ...
   "    vec1.vec as pair1     " ...
   "   ,vec2.vec as pair2     " ...
   "  from                    " ...
   "    vec1 inner join vec2  " ...
   "  on                      " ...
   "    1=1                   "]);
% check sqlite result
chk=fetch(db,"select * from pairsql")
disp(chk)
close(db)
;;;;
%utl_mend;

Back to sas


%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
library(sqldf)

source("c:/oto/fn_tosas9x.R")
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbListTables(con)
df <- dbReadTable(con, "pairsql")
df
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;




























%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("d:/sqlite/have.db");
clear chk
execute(db, 'drop table if exists pairsql');
execute(db,
     "select
       vec1.vec as pair1
      ,vec2.vec as pair2
     from
       vec1 inner join vec2
     on
       1=1");
% check sqlite result
chk=fetch(db,"select * from pairsql")
disp(chk)
close(db)
;;;;
%utl_mend;





sqlquery=
"select vec1.vec as pair1 ,vec2.vec as pair2" ...
"from vec1 inner join vec2 on 1=1";











  "select
     vec1.vec as pair1
    ,vec2.vec as pair2
   from
     vec1 inner join vec2
   on
     1=1
   ");
disp(pairsql)
close(db)
;;;;
%utl_mend;




 sqlquery =
    ["select " ...
         "vec1.vec as pair1 " ...
        ",vec2.vec as pair2 " ...
     "from " ...
        "vec1 inner join vec2 " ...
     "on " ...
        "1=1"];




























          ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;



dicvec=fetch(db ,"SELECT * FROM pragma_table_info('vec1')")
execute(db ,"SELECT * FROM pragma_table_info('vec1')")

How do i convert this octave sqlite query

sqlquery=
  "select
     vec1.vec as pair1
    ,vec2.vec as pair2
   from
     vec1 inner join vec2
   on
     1=1";

into a single string

sqlquery= "select vec1.vec as pair1 ,vec2.vec as pair2 from vec1 inner join vec2 on 1=1";

using octave









  12x2 table

  pair1  pair2
  _____  _____

  1      1
  1      2
  1      3
  2      1
  2      2
  2      3
  3      1
  3      2
  3      3
  4      1
  4      2
  4      3




octave:213> class(vec2)
ans = dbtable


octave:214> class(pairs)
ans = dbtable





























addvar = dbtable([1], 'VariableNames', {'beta'});


addvar = dbtable(data, 'VariableNames', {'beta'});
disp(addvar)

pair1 = (zeros(12,1));
pair2 = (zeros(12,1));
pairs = dbtable(pair1,pair2, 'VariableNames', {'pair1','pair2'});
disp(pairs)


%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious

db = sqlite("d:/sqlite/have.db");
vec1 = fetch(db, 'select * from vec1');
vec2 = fetch(db, 'select * from vec2');

pair1 = (zeros(12,1));
pair2 = (zeros(12,1));
pairs = dbtable(pair1,pair2,'VariableNames', {'pair1','pair2'});

i = 0;

for val1 = 1:4
    for val2 = 1:3
      i = i + 1;
      pairs(i,1) = cell2mat(vec1.vec(val1));
      pairs(i,2) = cell2mat(vec2.vec(val2));
    end
end

disp(pairs)
;;;;
%utl_mend;


%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious

db = sqlite("d:/sqlite/have.db");
vec1 = fetch(db, 'select * from vec1');
vec2 = fetch(db, 'select * from vec2');

pair1 = zeros(12,1);
pair2 = zeros(12,1);
i = 0;
for val1 = 1:4
    for val2 = 1:3
        i = i + 1;
        pair1(i) = cell2mat(vec1.vec(val1));
        pair2(i) = cell2mat(vec2.vec(val2));
    end
end
pairs = table(pair1, pair2);
disp(pairs)
;;;;
%utl_mend;



  12x2 table

  pair1  pair2
  _____  _____

  1      1
  1      2
  1      3
  2      1
  2      2
  2      3
  3      1
  3      2
  3      3
  4      1
  4      2
  4      3












class(vec1)
disp(vec1)

pair1 = (zeros(12,1));
pair2 = (zeros(12,1));
pairs = dbtable(pair1,pair2,'VariableNames', {'pair1','pair2'});
class(pairs)

i = 0;

for val1 = 1:4
    for val2 = 1:3
      i = i + 1;
      pairs.pair1(i) = cell2mat(vec1.vec(val1));
      pairs.pair2(i) = cell2mat(vec2.vec(val2));
    end
end

disp(pairs)
;;;;
%utl_mend;



vars = table(pairs(:,1), pairs(:,2) ,'VariableNames', {'Col1', 'Col2'});

execute(db, 'drop table if exists matout');
sqlwrite(db, "matout", vars, 'ColumnType', {'numeric', 'numeric'});
data = fetch(db, "PRAGMA table_info('matout');");
disp(data)
chk = fetch(db, 'select * from matout');
disp(chk)
;;;;
%utl_mend;

vec1(val1);
vec2(val2);


T = table(pairs(:,1), pairs(:,2) ,'VariableNames', {'Col1', 'Col2'});
disp(T)

vec1 = 1:4;
vec2 = 1:3;


%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("have.db", "create");
# create table (if it does not exist) and then insert 2 rows
t = dbtable([1;2],['Name1';'Name2'], 'VariableNames', {'Id','Name'});
disp(t)
# insert table data
execute(db, 'drop table if exists Test');
sqlwrite(db, "Test", t, 'ColumnType', {'numeric', 'text'});
data = fetch(db, "PRAGMA table_info('Test');");
disp(data)
dbtable_test = fetch(db, 'select * from Test');
disp(dbtable_test)
close(db);
;;;;
%utl_mend;



How do i convert then

vec1 = 1:4;
class(vec1)
disp(vec1)


why am i getting the following err when creating a two columns and 12 row dbtablefilled with zeros using matlab

octave:1043> T = table('Size', [12 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'Col1', 'Col2'});
error: Unknown property 'Size'



vec1 = dbtable([1:4],'VariableNames', {'vec'});
vec2 = dbtable([1:3],'VariableNames', {'vec'});


vec1 = dbtable([1,2]), 'VariableNames', {'vec1','vec2'});
vec1 = dbtable([1,2,3,4]);
disp(vec1)

                                disp(pairs.pair1(1))




options
  validvarname=v7;
libname sd1 "d:/sd1";
data sd1.vec1 sd1.vec2;
  do vec=1 to 4;
    output sd1.vec1;
    if vec ne 4 then output sd1.vec2;
  end;
run;quit;



patient_id = [101; 102; 103; 104];
name = {"Alice Smith"; "Bob Johnson"; "Carol Williams"; "David Brown"};
age = [35; 42; 28; 51];
temperature = [36.7; 37.1; 38.3; 37.5];
status = categorical({"Stable"; "Critical"; "Improving"; "Stable"}, ...
                    {"Stable", "Improving", "Critical"});

%% Create table
patients = table(patient_id, name, age, temperature, status, ...
                'VariableNames', {"ID", "Name", "Age", "Temp", "Status"}, ...
                'RowNames', string(patient_id));





octave:24> patient_id = [101; 102; 103; 104];
octave:25> name = {"Alice Smith"; "Bob Johnson"; "Carol Williams"; "David Brown"};
octave:26> age = [35; 42; 28; 51];
octave:27> temperature = [36.7; 37.1; 38.3; 37.5];
octave:28> status = categorical({"Stable"; "Critical"; "Improving"; "Stable"}, ...
>                     {"Stable", "Improving", "Critical"});


vtable = table(vec1,'VariableNames', {"vec"});


                'VariableNames', {"ID", "Name", "Age", "Temp", "Status"}, ...
                'RowNames', string(patient_id));

patients = table(patient_id, name, age, temperature, status, ...
                'VariableNames', {"ID", "Name", "Age", "Temp", "Status"}, ...
                'RowNames', string(patient_id));




exec(conn, 'SELECT load_extension("path/to/sqlean.dll")');




  set sashelp.class
   (keep=
     name age weight
   obs=5);
run;quit;












                            =======

SAS DATASET
SD1.HAVE total obs=5

  Name   Age    Weight

 Alfred   14     112.5
 Alice    13      84.0
 Barbara  13      98.0
 Carol    14     102.5
 Henry    14     102.5


SQLITE TABLE 'HAVE' CONTENTS

     Name Age Weight
1  Alfred  14  112.5
2   Alice  13   84.0
3 Barbara  13   98.0
4   Carol  14  102.5
5   Henry  14  102.5

+ ,SELECT
+   *
+  FROM
+   pragma_table_info('have')

SQLITE COLUMN TYPES

   name type null def pk

   Name TEXT  0    NA  0
    Age REAL  0    NA  0
 Weight REAL  0    NA  0


options
  validvarname=v7;
libname sd1 "d:/sd1";
data sd1.have;
  set sashelp.class
   (keep=
     name age weight
   obs=5);
run;quit;

%utlfkil("d:/sqlite/have.db");

%utl_rbeginx;
parmcards4;
library(haven)
library(DBI)
library(RSQLite)
have<-read_sas(
 "d:/sd1/have.sas7bdat")
have
con <- dbConnect(
    RSQLite::SQLite()
   ,"d:/sqlite/have.db")
dbWriteTable(
    con
  ,"have"
  ,have)
dbListTables(con)
dbGetQuery(
   con
 ,"SELECT
     *
   FROM
     have")
dbGetQuery(con
  ,"SELECT
      *
   FROM
      pragma_table_info('have')")
dbDisconnect(con)
;;;;
%utl_rendx;












db = sqlite("have.db");
data = fetch(db, "PRAGMA table_info('have');");
disp(data)

 cid  name  type  notnull  dflt_value  pk
  ___  ____  ____  _______  __________  __

  0    keyx  REAL  0                    0
  1    id    REAL  0                    0
  2    name  TEXT  0                    0

db = sqlite("have.db");
tbl=tbl = fetch(db, 'select * from have');
close(db)













Mutiple issues with this post, reworking.

Sqlite can input a local dbtable and output a sqlite table

%utl_mbegin;
parmcards4;
pkg load database
pkg load sqlite
pkg load io
pkg load tablicious
db = sqlite("have.db", "create");
# create table (if it does not exist) and then insert 2 rows
t = dbtable([1;2],['Name1';'Name2'], 'VariableNames', {'Id','Name'});
disp(t)
# insert table data
execute(db, 'drop table if exists Test');
sqlwrite(db, "Test", t, 'ColumnType', {'numeric', 'text'});
data = fetch(db, "PRAGMA table_info('Test');");
disp(data)
dbtable_test = fetch(db, 'select * from Test');
disp(dbtable_test)
close(db);
;;;;
%utl_mend;

INPUT LOAC DBTABEL

  2x2 table

  Id  Name
  __  _____

  1   Name1
  2   Name2


OUTPUT SQLItE DBTABLE

octave:719> disp(data)
  2x6 table

  cid  name  type     notnull  dflt_value  pk
  ___  ____  _______  _______  __________  __

  0    Id    numeric  0                    0
  1    Name  TEXT     0                    0

octave:770> disp(dbtable_test)
  2x2 table

  Id  Name
  __  _____

  1   Name1
  2   Name2














filename ft15f001 "c:/oto/mbegin.sas";
parmcards4;
%macro utl_mbegin;
%utl_close;
%utlfkil(c:/temp/m_pgm.m);
%utlfkil(c:/temp/m_pgm.log);
filename ft15f001 "c:/temp/m_pgm.m";
%mend utl_mbegin;
;;;;
run;quit;

filename ft15f001 "c:/oto/mend.sas";
parmcards4;
%macro utl_mend(returnvar=N);
options noxwait noxsync;
filename rut pipe  "octave-cli c:/temp/m_pgm.m > c:/temp/m_pgm.log";
run;quit;
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename ft15f001 clear;
  * use the clipboard to create macro variable;
  %if %upcase(%substr(&returnVar.,1,1)) ne N %then %do;
    filename clp clipbrd ;
    data _null_;
     length txt $200;
     infile clp;
     input;
     putlog "macro variable &returnVar = " _infile_;
     call symputx("&returnVar.",_infile_,"G");
    run;quit;
  %end;
 data _null_;
  file print;
  infile "c:/temp/m_pgm.log" ;
  input;
  put _infile_;
  putlog _infile_;
run;quit;
filename ft15f001 clear;
%mend utl_mend;
;;;;
run;quit;
