-- Drop existing function if it exists
DROP FUNCTION IF EXISTS public.update_room_with_tenant;

-- Create or replace the function with proper type handling
CREATE OR REPLACE FUNCTION public.update_room_with_tenant(
  p_id bigint,
  p_name text,
  p_is_occupied boolean,
  p_asset_ids jsonb DEFAULT NULL,
  p_image_url text DEFAULT NULL,
  p_tenant_id bigint DEFAULT NULL,
  p_check_in timestamp DEFAULT NULL,
  p_check_out timestamp DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_tenant_id bigint;
  result jsonb;
BEGIN
  -- Start transaction
  BEGIN
    -- Get current tenant_id before update
    SELECT tenant_id INTO current_tenant_id
    FROM public.rooms
    WHERE id = p_id;

    -- If tenant is being changed, clear previous tenant's room_id
    IF current_tenant_id IS NOT NULL AND 
       (p_tenant_id IS NULL OR current_tenant_id != p_tenant_id) THEN
      UPDATE public.tenants
      SET room_id = NULL
      WHERE id = current_tenant_id;
    END IF;

    -- Update the room with proper type casting for asset_ids
    UPDATE public.rooms
    SET 
      name = p_name,
      is_occupied = p_is_occupied,
      asset_ids = CASE 
                   WHEN p_asset_ids IS NULL THEN NULL 
                   ELSE p_asset_ids::jsonb 
                 END,
      image_url = p_image_url,
      tenant_id = p_tenant_id,
      created_at = NOW()
    WHERE id = p_id
    RETURNING to_jsonb(rooms.*) INTO result;

    -- If new tenant_id is provided, update the tenant's room_id
    IF p_tenant_id IS NOT NULL THEN
      UPDATE public.tenants
      SET room_id = p_id
      WHERE id = p_tenant_id;
    END IF;

    -- Return the updated room
    RETURN result;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      RAISE EXCEPTION 'Error in update_room_with_tenant: %', SQLERRM;
  END;
END;
$$;
