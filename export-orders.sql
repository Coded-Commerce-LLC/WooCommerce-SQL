SELECT

	-- Order Meta
	p.ID AS order_id,
	p.post_status AS order_status,
	p.post_date AS order_date,
	max( CASE WHEN pm.meta_key = '_order_total' AND p.ID = pm.post_id THEN pm.meta_value END ) AS order_total,
	max( CASE WHEN pm.meta_key = '_order_tax' AND p.ID = pm.post_id THEN pm.meta_value END ) AS order_tax,

	-- Payment
	max( CASE WHEN pm.meta_key = '_paid_date' AND p.ID = pm.post_id THEN pm.meta_value END ) AS paid_date,
	max( CASE WHEN pm.meta_key = '_payment_method' AND p.ID = pm.post_id THEN pm.meta_value END ) AS payment_method,
	max( CASE WHEN pm.meta_key = '_transaction_id' AND p.ID = pm.post_id THEN pm.meta_value END ) AS transaction_id,

	-- Order Items
	(
		SELECT group_concat( order_item_name SEPARATOR '\n' )
		FROM wp_woocommerce_order_items oi
		WHERE order_id = p.ID
		AND oi.order_item_type = 'line_item'
	) AS line_items,
	(
		SELECT group_concat( CASE WHEN oim.meta_key = '_qty' AND oi.order_item_id = oim.order_item_id THEN oim.meta_value END SEPARATOR '\n' )
		FROM wp_woocommerce_order_items oi
		LEFT JOIN wp_woocommerce_order_itemmeta oim ON oi.order_item_id = oim.order_item_id
		WHERE order_id = p.ID
		AND oi.order_item_type = 'line_item'
	) AS line_items_qtys,
	(
		SELECT group_concat(
			format(
				CASE WHEN oim.meta_key = '_line_subtotal' AND oi.order_item_id = oim.order_item_id THEN oim.meta_value END
			, 2 )
		SEPARATOR '\n' )
		FROM wp_woocommerce_order_items oi
		LEFT JOIN wp_woocommerce_order_itemmeta oim ON oi.order_item_id = oim.order_item_id
		WHERE order_id = p.ID
		AND oi.order_item_type = 'line_item'
	) AS line_items_subtotals,
	(
		SELECT group_concat(
			format(
				CASE WHEN oim.meta_key = 'cost' AND oi.order_item_id = oim.order_item_id THEN oim.meta_value END
			, 2 )
		SEPARATOR '\n' )
		FROM wp_woocommerce_order_items oi
		LEFT JOIN wp_woocommerce_order_itemmeta oim ON oi.order_item_id = oim.order_item_id
		WHERE order_id = p.ID
		AND oi.order_item_type = 'shipping'
	) AS shipping_cost,

	-- Contact Info
	max( CASE WHEN pm.meta_key = '_billing_email' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_email,
	max( CASE WHEN pm.meta_key = '_billing_phone' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_phone,

	-- Customer Data Example
	-- max( CASE WHEN pm.meta_key = '_customer_user' AND p.ID = pm.post_id THEN pm.meta_value END ) AS user_id,
	-- max( CASE WHEN um.meta_key = 'nickname' THEN um.meta_value END ) AS user_nickname,

	-- Billing
	max( CASE WHEN pm.meta_key = '_billing_first_name' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_first_name,
	max( CASE WHEN pm.meta_key = '_billing_last_name' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_last_name,
	max( CASE WHEN pm.meta_key = '_billing_address_1' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_address_1,
	max( CASE WHEN pm.meta_key = '_billing_address_2' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_address_2,
	max( CASE WHEN pm.meta_key = '_billing_city' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_city,
	max( CASE WHEN pm.meta_key = '_billing_state' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_state,
	max( CASE WHEN pm.meta_key = '_billing_postcode' AND p.ID = pm.post_id THEN pm.meta_value END ) AS billing_postcode,

	-- Shipping
	max( CASE WHEN pm.meta_key = '_shipping_first_name' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_first_name,
	max( CASE WHEN pm.meta_key = '_shipping_last_name' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_last_name,
	max( CASE WHEN pm.meta_key = '_shipping_address_1' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_address_1,
	max( CASE WHEN pm.meta_key = '_shipping_address_2' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_address_2,
	max( CASE WHEN pm.meta_key = '_shipping_city' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_city,
	max( CASE WHEN pm.meta_key = '_shipping_state' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_state,
	max( CASE WHEN pm.meta_key = '_shipping_postcode' AND p.ID = pm.post_id THEN pm.meta_value END ) AS shipping_postcode

FROM wp_posts p
	LEFT JOIN wp_postmeta pm ON p.ID = pm.post_id
	LEFT JOIN wp_woocommerce_order_items oi ON p.ID = oi.order_id
	
	-- Customer Data Example
	-- LEFT JOIN wp_users u ON u.ID = pm.meta_value AND pm.meta_key = '_customer_user'
	-- LEFT JOIN wp_usermeta um ON um.user_id = u.ID

WHERE post_type = 'shop_order'

GROUP BY p.ID;
