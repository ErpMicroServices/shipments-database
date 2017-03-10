create table if not exists shipment_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT shipment_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT shipment_type_pk PRIMARY key(id)
);

create table if not exists shipment(
  id uuid DEFAULT uuid_generate_v4(),
  estimated_ship_date date,
  estiamted_ready_date date,
  estimated_arrival_date date,
  estimated_ship_cost double precision,
  actual_ship_cost double precision,
  latest_cancel_date date,
  handling_instructions text,
  last_update date,
  described_by uuid not null references shipment_type(id),
  shipped_from_party_id uuid not null,
  shipped_to_party_id uuid not null,
  shipped_from_postal_addres_id uuid not null,
  shipped_to_postal_address_id uuid not null,
  inquired_about_via_contact_mechanism_id uuid not null,
  CONSTRAINT shipment_pk PRIMARY key(id)
);

create table if not exists shipment_item(
  id uuid DEFAULT uuid_generate_v4(),
  sequence bigint not null,
  quantity bigint default 1,
  content_description text,
  generating uuid references shipment_item(id),
  response_to uuid references shipment_item(id),
  shipment_of_good_id uuid not null,
  CONSTRAINT shipment_item_pk PRIMARY key(id)
);

create table if not exists shipment_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT shipment_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT shipment_status_type_pk PRIMARY key(id)
);

create table if not exists shipment_status(
  id uuid DEFAULT uuid_generate_v4(),
  status_date date not null default current_date,
  shipment_id uuid not null references shipment(id),
  described_by uuid not null references shipment_status_type(id),
  CONSTRAINT shipment_status_pk PRIMARY key(id)
);

create table if not exists shipment_item_feature(
  id uuid DEFAULT uuid_generate_v4(),
  shipment_item_id uuid not null references shipment_item(id),
  product_feature_id uuid not null,
  CONSTRAINT shipment_item_feature_pk PRIMARY key(id)
);

create table if not exists order_shipment(
  id uuid DEFAULT uuid_generate_v4(),
  quantity bigint not null default 1,
  shipment_item_id uuid not null references shipment_item(id),
  order_item_id uuid not null,
  CONSTRAINT order_shipment_pk PRIMARY key(id)
);

create table if not exists shipment_package(
  id uuid DEFAULT uuid_generate_v4(),
  date_created date not null default current_date,
  CONSTRAINT shipment_package_pk PRIMARY key(id)
);

create table if not exists packaging_content(
  id uuid DEFAULT uuid_generate_v4(),
  quantity bigint not null default 1,
  shipment_package_id uuid not null references shipment_package(id),
  shipment_item_id uuid not null references shipment_item(id),
  CONSTRAINT packaging_content_pk PRIMARY key(id)
);

create table if not exists rejection_reason(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT rejection_reason_description_not_empty CHECK (description <> ''),
  CONSTRAINT rejection_reason_pk PRIMARY key(id)
);

create table if not exists shipment_receipt(
  id uuid DEFAULT uuid_generate_v4(),
  recieved_at timestamp not null default current_timestamp,
  description text,
  quantity_accepted bigint not null default 1,
  quantity_rejected bigint not null default 0,
  good_id uuid not null,
  inventory_item_id uuid not null,
  shipment_package_id uuid not null references shipment_package(id),
  order_item_id uuid not null,
  rejection_reason_id uuid not null references rejection_reason(id),
  CONSTRAINT shipment_receipt_pk PRIMARY key(id)
);
