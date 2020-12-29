import numpy as np
import scipy.integrate as integrate
import matplotlib.pyplot as plt
import seaborn as sns

w= integrate.quad(lambda x: np.e**(-(x**2)/2)*(0.5*np.sin(8*x)**2+2*np.cos(2*x)**2*np.sin(4*x)**2+0.5), -np.inf,np.inf)

def f(x):
    return (np.e**(-(x**2)/2)*(0.5*np.sin(8*x)**2+2*np.cos(2*x)**2*np.sin(4*x)**2+0.5))/w[0]

def g(x):
    return(1/np.sqrt(2*np.pi))*np.e**(-(x**2)/2)

def aceptacion_rechazo(U,N,f,g,M):
    if(U <= f(N)/(M*g(N))):
        return True
    else:
        return False

if __name__ == "__main__":
    np.random.seed(0)

    sample=10000
    N = np.random.normal(0,1,sample)
    U = np.random.uniform(0,1,sample)
    x = np.linspace(-4,4,sample)
    acceptedN=[]
    nAcceptedN=[]
    acceptedU=[]
    nAcceptedU=[]

    for i in range(sample):
        z=aceptacion_rechazo(U[i],N[i],f,g,3)
        if(z):
            acceptedN.append(N[i])
            acceptedU.append(U[i])
        else:
            nAcceptedN.append(N[i])
            nAcceptedU.append(U[i])
        
    acceptedN=np.array(acceptedN)
    nAcceptedN=np.array(nAcceptedN)
    acceptedU=np.array(acceptedU)
    nAcceptedU=np.array(nAcceptedU)

    plt.plot(acceptedN,acceptedU*3*g(acceptedN),"o",c="green",label="Aceptados")
    plt.plot(nAcceptedN,nAcceptedU*3*g(nAcceptedN),"o",c="red",label="No acceptados")
    plt.plot(x,f(x),c="blue")
    plt.plot(x,3*g(x),c='black')
    plt.legend()
    plt.show()

    sns.color_palette("hls", 8)
    sns.displot(acceptedN,kind="kde",bw_adjust=.25)
    plt.plot(x,f(x),c="red")
    plt.legend(labels=['Densidad simulada', 'Densidad teorica'])
    plt.show()