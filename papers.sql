SELECT distinct m.url, m.title
FROM "covid-19".alleninstitute_metadata m
JOIN "covid-19".alleninstitute_comprehend_medical cm
    ON (contains(split(m.sha, '; '), cm.paper_id))
WHERE contains(generic_name, 'IL-6')
      AND m.journal = 'Crit Care'