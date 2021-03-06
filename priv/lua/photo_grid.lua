function round(n) return math.floor(n + 0.5) end

function angleRound(angle)
    local remainder = math.abs(angle % 90)
    if remainder > 45 then
        return 90 - remainder
    else
        return remainder
    end
end

-- Returns an integer that we need to subtract from width/height
-- due to camera rotation issues.
function cropAmount(width, height, angle)
    local absAngle = angleRound(angle or 0)
    if (absAngle > 0) then
        local x = (5.61 - 0.095 * math.pow(absAngle, 2) + 9.06 * absAngle)
        local factor = x / 640
        local longEdge = math.max(width, height)
        local result = round(longEdge * factor)
        return result
    end
    return 0
end

function fwe(key)
    local e = env("CAMERA_CALIBRATION_" .. key)
    if e then
        return tonumber(e)
    else
        send_message("error", "You must first run camera calibration", "toast")
        os.exit()
    end
end

local cam_rotation = fwe("total_rotation_angle")
local scale = fwe("coord_scale")
local z = fwe("camera_z")
local raw_img_size_x_px = fwe("center_pixel_location_x") * 2
local raw_img_size_y_px = fwe("center_pixel_location_y") * 2
local raw_img_size_x_mm = raw_img_size_x_px * scale
local raw_img_size_y_mm = raw_img_size_y_px * scale
local margin_mm = cropAmount(raw_img_size_x_px, raw_img_size_y_px, cam_rotation)
local cropped_img_size_x_mm = raw_img_size_x_mm - margin_mm
local cropped_img_size_y_mm = raw_img_size_y_mm - margin_mm
if math.abs(cam_rotation) < 45 then
    x_spacing_mm = cropped_img_size_x_mm
    y_spacing_mm = cropped_img_size_y_mm
else
    x_spacing_mm = cropped_img_size_y_mm
    y_spacing_mm = cropped_img_size_x_mm
end
local grid_size_x_mm = garden_size().x - x_spacing_mm
local y_grid_size_mm = garden_size().y - y_spacing_mm
local x_grid_points = math.ceil(grid_size_x_mm / x_spacing_mm)
local y_grid_points = math.ceil(y_grid_size_mm / y_spacing_mm)
local total = (x_grid_points + 1) * (y_grid_points + 1)
local x_grid_start_mm = (x_spacing_mm / 2)
local y_grid_start_mm = (y_spacing_mm / 2)
local x_offset_mm = fwe("camera_offset_x")
local y_offset_mm = fwe("camera_offset_y")

local each = function(callback)
    local count = 0
    for x_grid_index = 0, x_grid_points do
        for y_grid_index = 0, y_grid_points do
            local y = 0
            count = count + 1
            local y_temp1 = (y_spacing_mm * y_grid_points)
            if (x_grid_index % 2) == 0 then
                y = (y_grid_start_mm + (y_spacing_mm * y_grid_index) -
                        y_offset_mm)
            else
                local reversed_index_y = y_grid_points - y_grid_index
                y = (y_grid_start_mm + (y_spacing_mm * reversed_index_y) -
                        y_offset_mm)
            end
            callback({
                x = (x_grid_start_mm + (x_spacing_mm * x_grid_index) -
                    x_offset_mm),
                y = y,
                z = z,
                count = count
            })
        end
    end
end

return {
    y_spacing_mm = y_spacing_mm,
    y_offset_mm = y_offset_mm,
    y_grid_start_mm = y_grid_start_mm,
    y_grid_size_mm = y_grid_size_mm,
    y_grid_points = y_grid_points,
    x_spacing_mm = x_spacing_mm,
    x_offset_mm = x_offset_mm,
    x_grid_start_mm = x_grid_start_mm,
    x_grid_points = x_grid_points,
    z = z,
    total = total,
    each = each
}
