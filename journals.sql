SELECT m.journal,
       count(distinct(cm.paper_id)) as paper_count
FROM "covid-19".alleninstitute_metadata m
JOIN "covid-19".alleninstitute_comprehend_medical cm
    ON (contains(split(m.sha, '; '), cm.paper_id))
WHERE contains(generic_name, 'IL-6')
GROUP BY  m.journal
ORDER BY paper_count desc