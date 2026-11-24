
let fatal reason =
  prerr_endline reason;
  exit 1

type cppVersion = Cpp26 | Cpp23 | Cpp20 | Cpp17 | Cpp14 | Cpp11
module StringMap = Map.Make(String)

let cpp_version_map = StringMap.of_list [
  ("Cpp26", Cpp26);
  ("Cpp23", Cpp23);
  ("Cpp20", Cpp20);
  ("Cpp17", Cpp17);
  ("Cpp14", Cpp14);
  ("Cpp11", Cpp11)
]

let keys_to_string
    key_to_string
    map
    (seperator: string) =
  map
  |> StringMap.bindings
  |> List.map (fun (k, _) -> key_to_string k)
  |> String.concat seperator

let cpp_version_keys =
keys_to_string Fun.id cpp_version_map ", "

let defaultCppVersion = Cpp23
let parse_cpp_version str = StringMap.find_opt str cpp_version_map

type options = {
  name: string;
  version: cppVersion;
}
let () =
  let args = Sys.argv in
  let _options =
    match args with
    | [| _; name; version |] -> (
        match parse_cpp_version version with
        | Some v -> { name; version = v }
        | None ->
            Printf.sprintf "Invalid Version\nValid versions are: %s" cpp_version_keys
            |> fatal)

    | [| _; name |] -> { name; version = defaultCppVersion }
    | _ -> fatal "Invalid Arguments; Usage: ./create_cpp <name> <cppversion>"
  in
  print_endline "hello world"
