-- WP Options Report
SELECT
	'Autoload KB' as name, ROUND( SUM( LENGTH( option_value ) ) / 1024 ) as size, null as autoload
	FROM wp_options
	WHERE autoload = 'yes'
UNION
	SELECT 'Autoload count', count( * ), null as autoload
	FROM wp_options
	WHERE autoload = 'yes'
UNION (
	SELECT option_name, length( option_value ), autoload
	FROM wp_options
	WHERE autoload = 'yes'
	ORDER BY length( option_value ) DESC
	LIMIT 20
)
UNION (
	SELECT option_name, length( option_value ), autoload
	FROM wp_options
	WHERE autoload = 'no'
	ORDER BY length( option_value ) DESC
	LIMIT 20
);