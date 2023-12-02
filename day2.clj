(ns day2
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn find-id [input]
  (let [game-pattern #"Game (\d+):.*"
        matcher (re-matcher game-pattern input)]
    (when (re-find matcher)
      (.group matcher 1))))

(defn find-red [input]
  (let [red-pattern #"\b(\d+)\s*red\b"
        matches (re-seq red-pattern input)]
    (reduce + (map #(Integer. %) (map second matches)))))

(defn find-green [input]
  (let [green-pattern #"\b(\d+)\s*green\b"
        matches (re-seq green-pattern input)]
    (reduce + (map #(Integer. %) (map second matches)))))

(defn find-blue [input]
  (let [blue-pattern #"\b(\d+)\s*blue\b"
        matches (re-seq blue-pattern input)]
    (reduce + (map #(Integer. %) (map second matches)))))

(defn part_one [file-path]
  (with-open [reader (io/reader file-path)]
    (let [sum (atom 0)]
      (doseq [line (line-seq reader)]
        (let [games (map str/trim (str/split (second (str/split (str/trim line) #":")) #";")), failed (atom false)]
          (doseq [game games]
            (when (or (> (find-red game) 12) (> (find-green game) 13) (> (find-blue game) 14))
              (swap! failed (fn [_] (atom true)))))
          (when (not @failed)
            (swap! sum + (Integer/parseInt (find-id line))))))
      @sum)))

(defn part_two [file-path]
  (with-open [reader (io/reader file-path)]
    (let [sum (atom 0)]
      (doseq [line (line-seq reader)]
        (let [games (map str/trim (str/split (second (str/split (str/trim line) #":")) #";")),
              max-red (atom 0), max-green (atom 0), max-blue (atom 0)]
          (doseq [game games]
            (let [red-val (find-red game), green-val (find-green game), blue-val (find-blue game)]
              (when (> red-val @max-red)
                (swap! max-red (fn [_] red-val)))
              (when (> green-val @max-green)
                (swap! max-green (fn [_] green-val)))
              (when (> blue-val @max-blue)
                (swap! max-blue (fn [_] blue-val)))))
          (swap! sum + (* @max-red @max-green @max-blue))))
      @sum)))

(println (part_one "day2input.txt"))
(println (part_two "day2input.txt"))
