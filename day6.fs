open System
open System.IO

let parseInt (s: string) =
    match Int32.TryParse(s) with
    | (true, value) -> Some value
    | _ -> None

let partOne (data: string list) =
    let times =
        data.[0].Split([| ':' |]).[1].Trim().Split([| ' ' |], StringSplitOptions.RemoveEmptyEntries)
        |> Array.choose parseInt
    let distances =
        data.[1].Split([| ':' |]).[1].Trim().Split([| ' ' |], StringSplitOptions.RemoveEmptyEntries)
        |> Array.choose parseInt
    let mutable result = 1
    for (raceTime, bestDist) in Array.zip times distances do
        let mutable winningWays = 0
        for i in 1 .. raceTime do
            if i * (raceTime - i) > bestDist then winningWays <- winningWays + 1
        result <- result * winningWays
    result

let partTwo (data: string list) =
    let time =
        int64
            (String.concat ""
                 (data.[0].Split([| ':' |]).[1].Trim().Split([| ' ' |], StringSplitOptions.RemoveEmptyEntries)))
    let distance =
        int64
            (String.concat ""
                 (data.[1].Split([| ':' |]).[1].Trim().Split([| ' ' |], StringSplitOptions.RemoveEmptyEntries)))
    let mutable winningWays = 0L
    for i in 1L .. time do
        if i * (time - i) > distance then winningWays <- winningWays + 1L
    int winningWays

let main() =
    let data = File.ReadAllLines("day6input.txt") |> List.ofArray
    printfn "%d" (partOne data)
    printfn "%d" (partTwo data)

main()
