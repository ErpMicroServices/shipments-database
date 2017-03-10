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
