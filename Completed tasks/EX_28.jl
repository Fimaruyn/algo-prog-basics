#=
Написать функцию, возвращающую значение n-го члена
 последовательности Фибоначчи (1, 1, 2, 3, 5, 8, ...)
 а) без использования рекурсии;
 б) с использованием рекурсии;
практически убедиться, что наивная рекурсивная реализация такой функции
 будет крайне неэффективна в вычислительном отношении.
 в) с использованием рекурсии и с мемоизацией;
 убедиться, что полученный алгоритм будет достаточно эффективен в
 вычислительном отношении
=#

function fibonacci_a(n)
    (n < 2) && return n
    prev, curr = 0, 1
    for _ in 2:n
        next = prev + curr
        prev, curr = curr, next
    end
    return curr
end

function fibonacci_b(n)
    (n < 2) && return n
    return fibonacci_b(n - 1) + fibonacci_b(n - 2)
end

function fibonacci_c(n, memo=Dict())
    if n in keys(memo)
        return memo[n]
    elseif n <= 0
        return 0
    elseif n == 1 || n == 2
        return 1
    else
        memo[n] = fibonacci_с(n - 1, memo) + fibonacci_с(n - 2, memo)
        return memo[n]
    end
end
