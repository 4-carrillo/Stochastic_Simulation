using Plots

#EJERCICIO 1 inciso e)
function logisticMap4(x)
    return  4*x*(1-x)
end

function f_k(x,k)
    iterations=[logisticMap4(x)]
    for i in 1:k
        append!(iterations,logisticMap4(iterations[i]))
    end
    return iterations
end

function squaredf_k(x,k)
    iterations=[(logisticMap4(x))]
    sqr=[iterations[1]^2]
    for i in 1:k
        d=logisticMap4(iterations[i])
        append!(iterations,d)
        append!(sqr,d^2)
    end
    return sqr
end

#Condiciones iniciales
initV=rand(Float64)
erg1=[]
erg2=[]
n=1000

## h(x)=x
for i in 1:n
    append!(erg1,sum(f_k(initV,i)))
end

## h(x)=x^2
for i in 1:n
    append!(erg2,sum(squaredf_k(initV,i)))
end

data=hcat(erg1/n,erg2/n)
p1=plot(data,title="Teorema ergodico",ylims=(0,1),label=["h(x)=x" "h(x)=x^2"])
hline!([1/2],label="E(X)=1/2")
hline!([3/8],label="E(X^2)=3/8")
#Como se puede observar, conforme n aumenta la suma se va acercando a l esperanza o el segundo momento

#EJERCICIO 3 inciso b)
function carpa(x)
    if x<=1/2 
        return 2*x
    else
        return 2*(1-x)
    end
end

function f_ck(x,k)
    iteraciones=[carpa(x)]
    for i in 1:k
        append!(iteraciones,carpa(iteraciones[i]))
    end
    return iteraciones
end

## Condiciones iniciales
initVa1=rand(Float64)
initVa2=1/64
k=100


println("Mapeo carpa con valor inicial 1/2^n")
print(f_ck(initVa2,k))

# Como podemos observar el mapeo carpa nos manda
# Al 0.5 en cualquier caso y ese nos manda al 1
# que posteriormente nos manda al 0 lo cual es un 
# error, esto es debido a que la representacion
# de los numeros en la computadora es finita
# y no continua como los Reales

p2=plot(f_ck(initV,k),title="Mapeo Carpa")
plot(p1,p2,layout=(1,2))
#
