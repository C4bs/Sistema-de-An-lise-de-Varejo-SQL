-- Sistema de Análise de Varejo SQL
CREATE DATABASE sql_projeto_1;

-- Criação da tabela VENDAS
CREATE TABLE vendas (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Analisando se existe algum produto com algum campo nulo, ou seja, não preenchido
SELECT * FROM vendas WHERE transactions_id IS NULL
						OR sale_date IS NULL
						OR sale_time IS NULL
						OR customer_id IS NULL
						OR gender IS NULL
						OR age IS NULL
						OR category IS NULL
						OR quantity IS NULL
						OR price_per_unit IS NULL
						OR cogs IS NULL
						OR total_sale IS NULL

-- Deletando todos as vendas que possuem campos nulos
DELETE FROM vendas WHERE transactions_id IS NULL
						OR sale_date IS NULL
						OR sale_time IS NULL
						OR customer_id IS NULL
						OR gender IS NULL
						OR age IS NULL
						OR category IS NULL
						OR quantity IS NULL
						OR price_per_unit IS NULL
						OR cogs IS NULL
						OR total_sale IS NULL;

-- Quantas vendas foram feitas?
SELECT COUNT(*) AS total_sale FROM vendas

-- Quantos clientes o varejo tem?
SELECT COUNT(*) AS customer_id FROM vendas

-- Quantos clientes únicos tem o varejo?
SELECT COUNT(DISTINCT customer_id) AS customer_id FROM vendas

-- Quantas vendas foram feitas na data de '2022-11-05'?
SELECT * FROM vendas WHERE sale_date='2022-11-05'

-- Quantaos clientes realizaram 4 vendas ou mais, na categoria roupas em novembro de 2022?
SELECT * FROM vendas WHERE category='Clothing' 
						AND quantity >= 4
						AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

-- Qual é o número total de vendas em cada categoria?
SELECT category, 
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM vendas
GROUP BY 1

-- Qual é a idade média dos clientes que compraram na categoria "Beauty (Beleza)"?
SELECT ROUND(AVG(age), 2) AS avg_age
	FROM vendas
	WHERE category='Beauty'

-- Quantas transações tiveram vendas totais acima de 1000?
SELECT * FROM vendas WHERE total_sale >1000

-- Qual é a quantidade total de transações feitas cada gênero em cada categoria?
SELECT category, gender,
COUNT(*) as total_trans
FROM vendas
GROUP BY
	category, gender
ORDER BY 1

-- Qual foi o melhor mês de vendas em cada registrado?
SELECT year, month, avg_sale FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM vendas
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Quais os 5 clientes que mais realizaram compras?
SELECT customer_id,
	SUM(total_sale) AS total_sales
FROM vendas
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Quantos clientes únicos compraram em cada categoria?
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM vendas
GROUP BY category

-- Quantas vendas foram realizadas em cada turno?
WITH hourly_sale
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Manhã'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 12 THEN 'Tarde'
		ELSE 'Noite'
	END AS turno
FROM vendas
)
SELECT
	turno,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY turno