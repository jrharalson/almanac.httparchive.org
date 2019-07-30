#standardSQL

-- counts the local and hosted fonts

WITH
  summary_pages AS (
    SELECT * FROM `httparchive.summary_pages.2019_07_01_desktop`
    UNION ALL
    SELECT * FROM `httparchive.summary_pages.2019_07_01_mobile`
  ),
  summary_requests AS (
    SELECT * FROM `httparchive.summary_requests.2019_07_01_desktop`
    UNION ALL
    SELECT * FROM `httparchive.summary_requests.2019_07_01_mobile`
  ),
  merge_table AS (
    SELECT * FROM summary_requests JOIN (
      SELECT pageid, url AS page_url FROM summary_pages
    ) USING (pageid)
  ),
  processedTable AS (
    SELECT (NET.HOST(url) != NET.HOST(page_url)) as hosted, url, page_url
    FROM merge_table WHERE type = 'font'
  )
SELECT
  COUNTIF(hosted = true) / COUNT(0) AS hosted, COUNTIF(hosted = false) / COUNT(0) AS local
FROM processedTable
