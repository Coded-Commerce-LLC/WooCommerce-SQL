-- Post Meta Report
SELECT meta_key, count( meta_key )
FROM wp_postmeta
GROUP BY `meta_key`
ORDER BY count( meta_key ) DESC;