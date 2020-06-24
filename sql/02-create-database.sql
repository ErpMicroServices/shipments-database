create table if not exists shipment_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT shipment_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES shipment_type (id),
    CONSTRAINT shipment_type_pk PRIMARY key (id)
);

create table if not exists shipment
(
    id                                      uuid DEFAULT uuid_generate_v4(),
    estimated_ship_date                     date,
    estimated_ready_date                    date,
    estimated_arrival_date                  date,
    estimated_ship_cost                     numeric(12, 3),
    actual_ship_cost                        numeric(12, 3),
    latest_cancel_date                      date,
    handling_instructions                   text,
    last_update                             date,
    type_id                                 uuid not null references shipment_type (id),
    shipped_from_party_id                   uuid not null,
    shipped_to_party_id                     uuid not null,
    shipped_from_contact_mechanism_id       uuid not null,
    shipped_to_contact_mechanism_id         uuid not null,
    inquired_about_via_contact_mechanism_id uuid not null,
    CONSTRAINT shipment_pk PRIMARY key (id)
);

create table if not exists shipment_item
(
    id                  uuid   DEFAULT uuid_generate_v4(),
    shipment_id         uuid   not null references shipment (id),
    sequence            bigint not null,
    quantity            bigint default 1,
    content_description text,
    parent_id           uuid references shipment_item (id),
    shipment_of_good_id uuid   not null,
    CONSTRAINT shipment_item_pk PRIMARY key (id)
);

create table if not exists shipment_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT shipment_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES shipment_status_type (id),
    CONSTRAINT shipment_status_type_pk PRIMARY key (id)
);

create table if not exists shipment_status
(
    id          uuid          DEFAULT uuid_generate_v4(),
    status_date date not null default current_date,
    shipment_id uuid not null references shipment (id),
    type_id     uuid not null references shipment_status_type (id),
    CONSTRAINT shipment_status_pk PRIMARY key (id)
);

create table if not exists shipment_item_feature
(
    id                 uuid DEFAULT uuid_generate_v4(),
    shipment_item_id   uuid not null references shipment_item (id),
    product_feature_id uuid not null,
    CONSTRAINT shipment_item_feature_pk PRIMARY key (id)
);

create table if not exists order_shipment
(
    id               uuid            DEFAULT uuid_generate_v4(),
    quantity         bigint not null default 1,
    shipment_item_id uuid   not null references shipment_item (id),
    order_item_id    uuid   not null,
    CONSTRAINT order_shipment_pk PRIMARY key (id)
);

create table if not exists shipment_package
(
    id           uuid          DEFAULT uuid_generate_v4(),
    date_created date not null default current_date,
    CONSTRAINT shipment_package_pk PRIMARY key (id)
);

create table if not exists packaging_content
(
    id                  uuid            DEFAULT uuid_generate_v4(),
    quantity            bigint not null default 1,
    shipment_package_id uuid   not null references shipment_package (id),
    shipment_item_id    uuid   not null references shipment_item (id),
    CONSTRAINT packaging_content_pk PRIMARY key (id)
);

create table if not exists rejection_reason
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT rejection_reason_description_not_empty CHECK (description <> ''),
    CONSTRAINT rejection_reason_pk PRIMARY key (id)
);

create table if not exists shipment_receipt
(
    id                  uuid               DEFAULT uuid_generate_v4(),
    received_at         timestamp not null default current_timestamp,
    description         text,
    quantity_accepted   bigint    not null default 1,
    quantity_rejected   bigint    not null default 0,
    good_id             uuid      not null,
    inventory_item_id   uuid      not null,
    shipment_package_id uuid      not null references shipment_package (id),
    order_item_id       uuid      not null,
    rejection_reason_id uuid      not null references rejection_reason (id),
    CONSTRAINT shipment_receipt_pk PRIMARY key (id)
);

create table if not exists picklist
(
    id          uuid          DEFAULT uuid_generate_v4(),
    date_create date not null default current_date,
    CONSTRAINT _pk PRIMARY key (id)
);

create table if not exists picklist_item
(
    id                         uuid            DEFAULT uuid_generate_v4(),
    quantity                   bigint not null default 1,
    picklist_id                uuid   not null references picklist (id),
    issued_form_inventory_item uuid   not null,
    CONSTRAINT picklist_item_pk PRIMARY key (id)
);
create table if not exists item_issuance
(
    id                            uuid               DEFAULT uuid_generate_v4(),
    issued                        timestamp not null default current_timestamp,
    quantity                      bigint    not null default 1,
    issued_for                    uuid      not null references shipment_item (id),
    issued_from_inventory_item_id uuid      not null,
    issued_according_to           uuid      not null references picklist_item (id),
    CONSTRAINT item_issuance_pk PRIMARY key (id)
);
create table if not exists item_issuance_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT item_issuance_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES item_issuance_role_type (id),
    CONSTRAINT item_issuance_role_type_pk PRIMARY key (id)
);

create table if not exists item_issuance_role
(
    id               uuid DEFAULT uuid_generate_v4(),
    item_issuance_id uuid not null references item_issuance (id),
    party_id         uuid not null,
    type_id          uuid not null references item_issuance_role_type (id),
    CONSTRAINT item_issuance_role_pk PRIMARY key (id)
);

create table if not exists document_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT _type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES document_type (id),
    CONSTRAINT _type_pk PRIMARY key (id)
);

create table if not exists document
(
    id                  uuid DEFAULT uuid_generate_v4(),
    type_id             uuid not null references document_type (id),
    shipment_package_id uuid not null references shipment_package (id),
    shipment_item_id    uuid not null references shipment_item (id),
    shipment_id         uuid not null references shipment (id),
    CONSTRAINT document_pk PRIMARY key (id)
);

create table if not exists shipment_method_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT shipment_method_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES shipment_method_type (id),
    CONSTRAINT shipment_method_type_pk PRIMARY key (id)
);

create table if not exists shipment_route_segment
(
    id                uuid               DEFAULT uuid_generate_v4(),
    actual_start      timestamp not null default current_timestamp,
    actual_arrival    timestamp not null default current_timestamp,
    estimated_start   timestamp not null default current_timestamp,
    estimated_arrival timestamp not null default current_timestamp,
    start_mileage     bigint,
    end_mileage       bigint,
    fuel_used         numeric(12, 3),
    shipment_id       uuid      not null references shipment (id),
    shipped_via       uuid      not null references shipment_method_type (id),
    fixed_asset_id    uuid,
    from_facility_id  uuid,
    to_facility_id    uuid,
    shipped_by        uuid,
    CONSTRAINT shipment_route_segment_pk PRIMARY key (id)
);

create table if not exists shipment_receipt_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT shipment_receipt_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES shipment_receipt_role_type (id),
    CONSTRAINT shipment_receipt_role_type_pk PRIMARY key (id)
);

create table if not exists shipment_receipt_role
(
    id                            uuid DEFAULT uuid_generate_v4(),
    shipment_receipt_id           uuid not null references shipment_receipt (id),
    shipment_receipt_role_type_id uuid not null references shipment_receipt_role_type (id),
    party_id                      uuid not null,
    CONSTRAINT shipment_receipt_role_pk PRIMARY key (id)
);
