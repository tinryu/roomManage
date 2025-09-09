create or replace view room_full_view as
select
    r.id as room_id,
    r.name as room_name,
    r.is_occupied,
    r.image_url as room_image,
    t.id as tenant_id,
    t.name as tenant_name,
    t.phone,
    t.email,
    t.checkin,
    t.checkout,
    a.id as asset_ids,
    a.name as asset_name,
    a.quantity,
    a.condition
from rooms r
left join tenants t on t.room_id = r.id
left join assets a on a.room_id = r.id;
