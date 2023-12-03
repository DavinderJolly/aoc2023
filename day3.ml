module IntSet = Set.Make(struct type t = int * int let compare = compare end)

let read_input filename =
  let input_channel = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line input_channel in
      read_lines (line :: acc)
    with
    | End_of_file -> List.rev acc
  in
  let lines = read_lines [] in
  close_in input_channel;
  String.concat "\n" lines

let input_str = read_input "day3input.txt"

let is_digit ch =
  let code = Char.code ch in
  code >= Char.code '0' && code <= Char.code '9'

let part_one () =
  let grid = Array.of_list (String.split_on_char '\n' input_str) in
  let num_coords = ref (IntSet.empty) in
  for ri = 0 to Array.length grid - 1 do
    let row = grid.(ri) in
    for ci = 0 to String.length row - 1 do
      let ch = row.[ci] in
      if (Char.code ch >= Char.code '0' && Char.code ch <= Char.code '9') || ch = '.' then
        ()
      else
        for cri = ri - 1 to ri + 1 do
          for cci = ci - 1 to ci + 1 do
            if cri < 0 || cri >= Array.length grid || cci < 0 || cci >= String.length grid.(cri) || not (Char.code grid.(cri).[cci] >= Char.code '0' && Char.code grid.(cri).[cci] <= Char.code '9') then
              ()
            else
              let rec find_left cci =
                if cci > 0 && Char.code grid.(cri).[cci - 1] >= Char.code '0' && Char.code grid.(cri).[cci - 1] <= Char.code '9' then
                  find_left (cci - 1)
                else
                  cci
              in
              let cc_left = find_left cci in
              num_coords := IntSet.add (cri, cc_left) !num_coords
          done
        done
    done
  done;
  let nums =
    List.map (fun (cri, cci) ->
      let rec extract_digits cci acc =
        if cci < String.length grid.(cri) && Char.code grid.(cri).[cci] >= Char.code '0' && Char.code grid.(cri).[cci] <= Char.code '9' then
          extract_digits (cci + 1) (acc ^ Char.escaped grid.(cri).[cci])
        else
          int_of_string acc
      in
      extract_digits cci ""
    ) (IntSet.elements !num_coords)
  in
  List.fold_left ( + ) 0 nums

let part_two () =
  let grid = Array.of_list (String.split_on_char '\n' input_str) in
  let total = ref 0 in

  for ri = 0 to Array.length grid - 1 do
    let row = grid.(ri) in
    for ci = 0 to String.length row - 1 do
      let ch = row.[ci] in
      if ch <> '*' then
        ()
      else
        let num_coords = ref IntSet.empty in

        for cri = ri - 1 to ri + 1 do
          for cci = ci - 1 to ci + 1 do
            if cri < 0 || cri >= Array.length grid || cci < 0 || cci >= String.length grid.(cri) || not (is_digit grid.(cri).[cci]) then
              ()
            else
              let rec find_left cci =
                if cci > 0 && is_digit grid.(cri).[cci - 1] then
                  find_left (cci - 1)
                else
                  cci
              in
              let cc_left = find_left cci in
              num_coords := IntSet.add (cri, cc_left) !num_coords
          done
        done;

        if IntSet.cardinal !num_coords <> 2 then
          ()
        else
          let nums =
            List.map (fun (cri, cci) ->
              let s = ref "" in
              let cc_ref = ref cci in
              while !cc_ref < String.length grid.(cri) && is_digit grid.(cri).[!cc_ref] do
                s := !s ^ Char.escaped grid.(cri).[!cc_ref];
                incr cc_ref
              done;
              int_of_string !s
            ) (IntSet.elements !num_coords)
          in
          total := !total + (List.nth nums 0 * List.nth nums 1)
    done
  done;
  !total

let () =
  print_endline ("Part One: " ^ string_of_int (part_one ()));
  print_endline ("Part Two: " ^ string_of_int (part_two ()));
