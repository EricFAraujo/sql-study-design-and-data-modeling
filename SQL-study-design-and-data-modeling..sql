create database ecommerce;
use ecommerce;

create table client(
    idClient int auto_increment primary key,
    Fname varchar(11),
    Minit char(4),
    Lname varchar(30),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

create table product(
    idproduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    Category enum('Eletrônico','Vestimenta','Brinquedo','Alimento','Móveis') not null,
    Avaliation float default 0,
    Size varchar(12)
);

create table payment(
    idPayment int auto_increment primary key,
    idClient int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    constraint fk_payment_client foreign key (idClient) references client(idClient)
);

create table orders(
    idorder int auto_increment primary key,
    idorderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    SendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idorderClient) references client(idClient)
);

create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
    idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact varchar(11) not null,
    constraint unique_supplier unique(CNPJ)
);

create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstrateName varchar(255),
    CNPJ char(15),
    CPF char(9),
    Location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_seller unique(CPF)
);

create table productSeller(
    idSeller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idSeller, idProduct),
    constraint fk_product_seller foreign key (idSeller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idproduct)
);

create table productOrder(
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_product_seller foreign key (idPOproduct) references product(idproduct),
    constraint fk_product_order foreign key (idPOorder) references orders(idorder)
);

create table storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_location_product foreign key (idLproduct) references product(idproduct),
    constraint fk_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier,idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idproduct)
);


SELECT * FROM client;

SELECT * FROM product WHERE Category = 'Eletrônico';

SELECT idClient, Fname, Lname, CONCAT(Fname, ' ', Lname) AS FullName FROM client;

SELECT * FROM orders ORDER BY orderStatus;

SELECT idorderClient, COUNT(*) AS TotalPedidos
FROM orders
GROUP BY idorderClient;

SELECT s.SocialName AS NomeVendedor, IFNULL(supplier.socialName, 'Não é fornecedor') AS NomeFornecedor
FROM seller s
LEFT JOIN supplier ON s.CNPJ = supplier.CNPJ;

SELECT ps.idPsProduct AS idProdutoFornecedor, ps.idPsSupplier AS idFornecedor, ps.quantity AS QuantidadeEstoque
FROM productSupplier ps
INNER JOIN productStorage ps ON ps.idPsProduct = ps.idProdStorage;

SELECT s.socialName AS NomeFornecedor, p.Pname AS NomeProduto
FROM productSupplier ps
INNER JOIN supplier s ON ps.idPsSupplier = s.idSupplier
INNER JOIN product p ON ps.idPsProduct = p.idproduct;
