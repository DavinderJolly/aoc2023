function split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function part_one(seeds, blocks)
    local vals = seeds
    for _, block in ipairs(blocks) do
        local new_vals = {}
        for _, val in ipairs(vals) do
            local added = false
            for _, mapping in ipairs(block) do
                local dest_start, src_start, mapping_length = unpack(mapping)
                if 0 <= val - src_start and val - src_start < mapping_length then
                    table.insert(new_vals, val - src_start + dest_start)
                    added = true
                    break
                end
            end
            if not added then
                table.insert(new_vals, val)
            end
        end
        vals = new_vals
    end
    table.sort(vals)
    return vals[1]
end

function part_two(seeds, blocks)
    local vals = {}
    for i = 1, #seeds, 2 do
        table.insert(vals, {seeds[i], seeds[i] + seeds[i + 1]})
    end

    for _, block in ipairs(blocks) do
        local new_vals = {}
        while #vals > 0 do
            local val_pair = table.remove(vals)
            local val_start, val_end = val_pair[1], val_pair[2]
            local added = false
            for _, mapping in ipairs(block) do
                local dest_start, src_start, mapping_length = unpack(mapping)
                local intersection_start = math.max(src_start, val_start)
                local intersection_end = math.min(src_start + mapping_length, val_end)
                if intersection_start < intersection_end then
                    table.insert(new_vals, {intersection_start - src_start + dest_start, intersection_end - src_start + dest_start})
                    if intersection_start > val_start then
                        table.insert(vals, {val_start, intersection_start})
                    end
                    if intersection_end < val_end then
                        table.insert(vals, {intersection_end, val_end})
                    end
                    added = true
                    break
                end
            end
            if not added then
                table.insert(new_vals, val_pair)
            end
        end
        vals = new_vals
    end
    table.sort(vals, function(a, b) return a[1] < b[1] end)
    return vals[1][1]
end


function main()
    local f = io.open("day5input.txt", "r")
    local data = split(f:read("*all"), "\n\n")
    f:close()

    local seeds = {}
    for _, num in ipairs(split(trim(split(data[1], ":")[2]), " ")) do
        table.insert(seeds, tonumber(num))
    end

    local blocks = {}
    for i = 2, #data do
        local block_data = data[i]
        local block_lists = {}

        local firstLineSkipped = false
        for _, block in ipairs(split(trim(block_data), "\n")) do
            if not firstLineSkipped then
                firstLineSkipped = true
            else
                local num_list = {}
                for _, num in ipairs(split(trim(block), " ")) do
                    table.insert(num_list, tonumber(num))
                end
                table.insert(block_lists, num_list)
            end
        end
        table.insert(blocks, block_lists)
    end

    print(part_one(seeds, blocks))
    print(part_two(seeds, blocks))
end

main()
