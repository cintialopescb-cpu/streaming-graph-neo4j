
Modelagem de Dados em Grafos — Serviço de Streaming (exemplo)
Arquivos gerados: users.csv, contents.csv, genres.csv, persons.csv, person_credits.csv, watchevents.csv, import.cypher

Instruções rápidas:
1. Coloque os CSVs na pasta import do Neo4j (geralmente $NEO4J_HOME/import).
2. Abra o Browser e rode o script import.cypher (pode colar no console).
3. Após a importação, crie índices/constraints conforme script.
4. Exemplos de queries úteis:
   - Top conteúdos:
     MATCH (u:User)-[w:WATCHED]->(c:Content)
     RETURN c.title, count(w) AS watches
     ORDER BY watches DESC LIMIT 20;
   - Gêneros preferidos de um usuário:
     MATCH (u:User {userId:'u001'})-[w:WATCHED]->(c:Content)-[:IN_GENRE]->(g:Genre)
     RETURN g.name, count(*) AS vezes ORDER BY vezes DESC;

Notas:
- Os WatchEvents foram importados aqui como relacionamentos com propriedades. Se precisar de eventos como nós (para QoE detalhada), me fala que eu ajusto.
- Os dados são sintéticos e servem para testar modelos e queries. Ajuste volumes conforme necessidade.
