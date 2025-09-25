-- Drop existing function if it exists
DROP FUNCTION IF EXISTS public.add_room_with_tenant;

-- Create or replace the function with proper type handling
CREATE OR REPLACE FUNCTION public.add_room_with_tenant(
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
  new_room_id bigint;
  result jsonb;
BEGIN
  -- Start transaction
  BEGIN
    -- Insert the new room with proper type casting for asset_ids
    INSERT INTO public.rooms (
      name, 
      is_occupied, 
      asset_ids, 
      image_url, 
      tenant_id,
      check_in,
      check_out
    )
    VALUES (
      p_name, 
      p_is_occupied, 
      CASE WHEN p_asset_ids IS NULL THEN NULL ELSE p_asset_ids::jsonb END,
      p_image_url, 
      p_tenant_id,
      p_check_in,
      p_check_out
    )
    RETURNING id INTO new_room_id;

    -- If tenant_id is provided, update the tenant's room_id
    IF p_tenant_id IS NOT NULL THEN
      UPDATE public.tenants
      SET room_id = new_room_id
      WHERE id = p_tenant_id;
    END IF;

    -- Get the newly created room
    SELECT to_jsonb(rooms.*) INTO result
    FROM public.rooms
    WHERE id = new_room_id;

    -- Commit the transaction
    RETURN result;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      RAISE EXCEPTION 'Error in add_room_with_tenant: %', SQLERRM;
  END;
END;
$$;
