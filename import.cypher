
// Neo4j import / schema setup and sample imports
// Constraints
CREATE CONSTRAINT IF NOT EXISTS FOR (u:User) REQUIRE u.userId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (c:Content) REQUIRE c.contentId IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:Person) REQUIRE p.personId IS UNIQUE;
CREATE INDEX IF NOT EXISTS FOR (g:Genre) ON (g.name);

// Load users
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///users.csv' AS row
MERGE (u:User {userId: row.userId})
SET u.email = row.email, u.country = row.country, u.createdAt = datetime(row.createdAt), u.signupSource = row.signupSource;

// Load contents
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///contents.csv' AS row
MERGE (c:Content {contentId: row.contentId})
SET c.title = row.title, c.type = row.type, c.duration = toInteger(row.duration), c.releaseDate = date(row.releaseDate), c.language = row.language, c.popularityScore = toFloat(row.popularityScore);

// Load genres and relationships
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///genres.csv' AS row
MERGE (g:Genre {name: row.genre})
MATCH (c:Content {contentId: row.contentId})
MERGE (c)-[:IN_GENRE]->(g);

// Load persons and credits
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///persons.csv' AS row
MERGE (p:Person {personId: row.personId})
SET p.name = row.name, p.role = row.role;

USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///person_credits.csv' AS row
MATCH (p:Person {personId: row.personId})
MATCH (c:Content {contentId: row.contentId})
MERGE (p)-[r:ACTED_IN]->(c)
SET r.role = row.relation;

// Load watch events as relationships
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///watchevents.csv' AS row
MATCH (u:User {userId: row.userId})
MATCH (c:Content {contentId: row.contentId})
MERGE (u)-[w:WATCHED {watchedAt: datetime(row.watchedAt), device: row.device}]->(c)
SET w.duration = toInteger(row.duration), w.position = toInteger(row.position), w.percent = toFloat(row.percent), w.completed = (row.completed = 'True' OR row.completed = 'true' OR row.completed = '1');
