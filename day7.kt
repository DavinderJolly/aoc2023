import java.io.File

fun strengthP1(hand: String): Pair<Int, List<Int>> {
    val strengths = "23456789TJQKA"
    val cardStrengths = mutableListOf<Int>()
    val counter = mutableMapOf<Char, Int>()

    for (card in hand) {
        cardStrengths.add(strengths.indexOf(card))
        counter[card] = counter.getOrDefault(card, 0) + 1
    }

    val cardCounts = counter.values.sorted()
    return when {
        cardCounts.equals(listOf(5)) -> Pair(7, cardStrengths)
        cardCounts.equals(listOf(1, 4)) -> Pair(6, cardStrengths)
        cardCounts.equals(listOf(2, 3)) -> Pair(5, cardStrengths)
        cardCounts.equals(listOf(1, 1, 3)) -> Pair(4, cardStrengths)
        cardCounts.equals(listOf(1, 2, 2)) -> Pair(3, cardStrengths)
        cardCounts.equals(listOf(1, 1, 1, 2)) -> Pair(2, cardStrengths)
        cardCounts.equals(listOf(1, 1, 1, 1, 1)) -> Pair(1, cardStrengths)
        else -> throw IllegalArgumentException("Invalid Hand $hand")
    }
}

fun partOne(handsAndBids: List<Pair<String, Int>>): Int {
    val sortedHandsAndBids =
        handsAndBids.sortedWith(
            compareBy(
                { strengthP1(it.first).first },
                { strengthP1(it.first).second[0] },
                { strengthP1(it.first).second[1] },
                { strengthP1(it.first).second[2] },
                { strengthP1(it.first).second[3] },
                { strengthP1(it.first).second[4] }
            )
        )

    var total = 0
    for ((i, pair) in sortedHandsAndBids.withIndex()) {
        val (_, bid) = pair
        total += (i + 1) * bid
    }

    return total
}

fun strengthP2(hand: String): Pair<Int, List<Int>> {
    val strengths = "J23456789TQKA"
    val cardStrengths = mutableListOf<Int>()
    val counter = mutableMapOf<Char, Int>()

    for (card in hand) {
        cardStrengths.add(strengths.indexOf(card))
        counter[card] = counter.getOrDefault(card, 0) + 1
    }

    if ('J' in counter && counter.size > 1) {
        val jCount = counter.remove('J')!!
        val maxKey = counter.maxByOrNull { it.value }!!.key
        counter[maxKey] = counter.getOrDefault(maxKey, 0) + jCount
    }

    val cardCounts = counter.values.sorted()
    return when {
        cardCounts.equals(listOf(5)) -> Pair(7, cardStrengths)
        cardCounts.equals(listOf(1, 4)) -> Pair(6, cardStrengths)
        cardCounts.equals(listOf(2, 3)) -> Pair(5, cardStrengths)
        cardCounts.equals(listOf(1, 1, 3)) -> Pair(4, cardStrengths)
        cardCounts.equals(listOf(1, 2, 2)) -> Pair(3, cardStrengths)
        cardCounts.equals(listOf(1, 1, 1, 2)) -> Pair(2, cardStrengths)
        cardCounts.equals(listOf(1, 1, 1, 1, 1)) -> Pair(1, cardStrengths)
        else -> throw IllegalArgumentException("Invalid Hand $hand")
    }
}

fun partTwo(handsAndBids: List<Pair<String, Int>>): Int {
    val sortedHandsAndBids =
        handsAndBids.sortedWith(
            compareBy(
                { strengthP2(it.first).first },
                { strengthP2(it.first).second[0] },
                { strengthP2(it.first).second[1] },
                { strengthP2(it.first).second[2] },
                { strengthP2(it.first).second[3] },
                { strengthP2(it.first).second[4] }
            )
        )

    var total = 0
    for ((i, pair) in sortedHandsAndBids.withIndex()) {
        val (_, bid) = pair
        total += (i + 1) * bid
    }

    return total
}

fun main() {
    val inputText = File("day7input.txt").readText().trim().lines()

    val handsAndBids =
        inputText.map { line ->
            val (hand, bid) = line.split(" ")
            hand to bid.toInt()
        }

    println(partOne(handsAndBids))
    println(partTwo(handsAndBids))
}
