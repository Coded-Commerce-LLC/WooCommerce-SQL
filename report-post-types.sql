-- Post Types Report
SELECT post_type, count( post_type )
FROM wp_posts
GROUP BY post_type
ORDER BY count( post_type ) DESC;