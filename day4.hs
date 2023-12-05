import qualified Data.Set as Set

customSplit :: Eq a => a -> [a] -> [[a]]
customSplit delimiter list =
  let (first, rest) = break (== delimiter) list
  in first : case rest of
              [] -> []
              (_:xs) -> customSplit delimiter xs

partOne :: [String] -> Int
partOne cards = sum $ map calculatePoints cards
  where
    calculatePoints card =
      let [_, cardDetails] = customSplit ':' card
          [winningStr, cardStr] = customSplit '|' cardDetails
          cardNums = Set.fromList $ map (read :: String -> Int) $ words cardStr
          winningNums = Set.fromList $ map (read :: String -> Int) $ words winningStr
          n = Set.size $ Set.intersection cardNums winningNums
      in if n > 0 then round (2 ** fromIntegral (n - 1)) else 0

incrementAtIndexBy :: [Int] -> Int -> Int -> [Int]
incrementAtIndexBy ls idx n = take idx ls ++ [(ls !! idx) + n] ++ drop (idx + 1) ls

updateCounts :: [String] -> Int -> [Int] -> Int -> [Int]
updateCounts cards index counts n
  | n == 0 = counts
  | otherwise = updateCounts cards index updatedCounts (n - 1)
  where
    updatedCounts = incrementAtIndexBy counts (index + n) (counts !! index)

countWinningCombinations :: [String] -> Int -> [Int] -> Int
countWinningCombinations cards index counts
  | index == length cards = sum counts
  | otherwise = countWinningCombinations cards (index + 1) updatedCounts
  where
    [_, cardAndWinningStr] = customSplit ':' $ cards !! index
    [cardStr, winningStr] = customSplit '|' cardAndWinningStr
    incrementedCounts = incrementAtIndexBy counts index 1
    cardNums = Set.fromList (words cardStr)
    winningNums = Set.fromList (words winningStr)
    n = Set.size (Set.intersection cardNums winningNums)
    updatedCounts = updateCounts cards index incrementedCounts n

partTwo :: [String] -> Int
partTwo cards = countWinningCombinations cards 0 (replicate (length cards) 0)


main :: IO ()
main = do
  inputText <- readFile "day4input.txt"
  let cards = lines inputText
  putStrLn $ "Part One: " ++ show (partOne cards)
  putStrLn $ "Part One: " ++ show (partTwo cards)
