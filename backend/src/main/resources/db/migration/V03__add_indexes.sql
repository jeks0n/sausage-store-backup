ALTER TABLE order_product ADD PRIMARY KEY (order_id, product_id);
ALTER TABLE orders ADD PRIMARY KEY (id, status);
ALTER TABLE product ADD PRIMARY KEY (id);