"""
Tarea 4

Carrillo Medina Alexis Adrian (CMAA)

Nombre del programa: Tarea4_Alexis_Carrillo_codigo.jl

"""

#----- Seccion de bibliotecas

using Random, Distributions, KernelDensity, Plots, QuadGK, SpecialFunctions, StatsPlots

#----- Codigo
#-------------- 1 --------------
#----- Metropolis Hastings -----
function MetropolisHastings(f,params1,Q,q,params2,n)
    
    """ 
    Algoritmo de Metropolis-Hastings para f,Q,q generales
    
    f := Distribucion a simular
    params1 := Parametros de f
    Q := Distribucion auxiliar
    q := Funcion de transicion de Q
    params2 := Parametros de Q
    n := Numero movimientos en la cadena
    
    """
    
    # Vector de estados de X
    statesX=[]
    
    # Distribucion Inicial de X
    X=Q(params2,0)
    
    # MetropolisHastings
    for i in 1:n
        
        # Guardamos los estados
        append!(statesX,X)
        
        # U ~ U(0,1)
        U=rand(Uniform())
        
        # X ~ L(Q)
        Xnew=Q(params2,X)
        
        # Aceptacion
        if U<= min(1,f(Xnew,params1)/f(X,params1)*q(Xnew,X,params2)/q(X,Xnew,params2))
            X=Xnew
        end
    end
    
    # Regresamos la cadena despues del quemado
    return statesX[ceil(Int,0.02*n):n*length(X)-1]
    
end

#------------- 1.1 -------------

# Distribucion a simular -----
function f(X,σ=2)
    # Soporte de la funcion
    if (X[1] >= 0) & (X[2] >=0)
        return (X[1]/σ)*(ℯ^(-(X[1]^2/(2*σ))))*(X[2]/σ)*(ℯ^(-(X[2]^2/(2*σ))))
    else
        return 0
    end
end

# Distribucion Marginal a simular -----
function fMarginal(x,σ=2)
    # Soporte de la funcion
    if (x >= 0) 
        return (x/σ)*(ℯ^(-(x^2/(2*σ))))
    else
        return 0
    end
end

# Distribucion auxiliar -----
function Q(params,X)
    return (rand(Uniform(params[1],params[2]),1)[1],rand(Uniform(params[1],params[2]),1)[1])
end

# Funcion de transicion -----
function q(X,Y,params)
    return 1
end

# ---- Grafico de densidad -----
x=range(0,stop=6,length=1000)
y=range(0,stop=6,length=1000)

g(x,y)=(x/2)*(ℯ^(-(x^2/(2*2))))*(y/2)*(ℯ^(-(y^2/(2*2))))

@gif for i in 1:100
    plot(x,y,g,st=:surface,camera=(i,i))
end

# ----- Prueba -----
X=MetropolisHastings(f,2,Q,q,[0,6],100000)

statesX=[]
statesY=[]
for i in range(1,length(X),step=2)
    append!(statesX,X[i])
    append!(statesY,X[i+1])
end

marginalhist(statesX,statesY)

# Marginal 1 ----
histogram(statesX,normed=true,label="Simulacion")
plot!(range(0,6,length=10000),fMarginal,label="Densidad Teorica",lw=3)

# Marginal 2 ----
histogram(statesY,normed=true,label="Simulacion")
plot!(range(0,6,length=10000),fMarginal,label="Densidad Teorica",lw=3)

# ----- Estimacion de Parametros -----
# Numero de Simulaciones
n=[100,1000,10000]

# n=100
X1=MetropolisHastings(f,2,Q,q,[0,6],n[1])
X1=Vector{Float64}(vec(X1))

# n=10000
X2=MetropolisHastings(f,2,Q,q,[0,6],n[2])
X2=Vector{Float64}(vec(X2))

# n=10000
X3=MetropolisHastings(f,2,Q,q,[0,6],n[3])
X3=Vector{Float64}(vec(X3))

# Estimacion
σ1=2/(length(X1)^2*π)*(sum(X1))^2
σ2=2/(length(X2)^2*π)*(sum(X2))^2
σ3=2/(length(X3)^2*π)*(sum(X3))^2

print("La estimacion de σ, con 100, es :")
print(σ1)
print("\n")

print("La estimacion de σ, con 1000, es :")
print(σ2)
print("\n")

print("La estimacion de σ, con 10000, es :")
print(σ3)