//(1)
class Persona {
    var property nombre
    var property salarioMensual
    var property efectivo = 0
    var formasDePago = []
    var property formaPreferida
    var bienes = []

    method comprar(bien, monto) {
        if (formaPreferida.pagar(self.nombre, monto)) {
            bienes.add(bien)
        }
    }
}

class FormaDePago {
    method pagar(persona, monto)
}

class Efectivo inherits FormaDePago {
    override method pagar(persona, monto) {
        if (persona.efectivo >= monto) {
            persona.efectivo -= monto
        }
        else
        self.error("NO PUEDE PAGAR")
    }
}

class Debito inherits FormaDePago {
    var cuenta

    override method pagar(persona, monto) {
        if (cuenta.saldo >= monto) {
            cuenta.saldo -= monto
        }
        else
        self.error("NO PUEDE PAGAR")
    }
}

class CuentaBancaria {
    var saldo = 0
}

class Cuotas inherits FormaDePago {
    var tarjeta
    var bancoCentral

    override method pagar(persona, monto) {
        if (monto <= tarjeta.maximoPermitido) {
            tarjeta.agregarDeuda(monto, bancoCentral.tasaInteres)
        }
        else
        self.error("NO PUEDE PAGAR")     
    }
}

class Tarjeta {
    var maximoPermitido
    var cuotasPendientes = []

    method agregarDeuda(monto, tasaInteres) {
        cuotasPendientes.add({ monto: monto, tasaInteres: tasaInteres, mesesRestantes: 12 })
    }

    method pagarCuotas(persona) {
        cuotasPendientes.forEach(cuota => {
            if (persona.efectivo >= cuota.monto) {
                persona.efectivo -= cuota.monto
                cuota.mesesRestantes--
            }
        })
    }
}

class BancoCentral {
    var tasaInteres = 0.02
}

//(2)
method cambiarFormaPreferida(nuevaForma) {
    formaPreferida = nuevaForma
}

//(3)
method avanzarUnMes() {
    formasDePago.forEach(forma => {
        if (forma instanceof Cuotas) {
            forma.tarjeta.pagarCuotas(this)
        }
    })
    efectivo += salarioMensual
}

//(4)
method cuotasImpagasVencidas() {
    return formasDePago
        .filter(forma => forma instanceof Cuotas)
        .map(forma => forma.tarjeta.cuotasPendientes)
        .flatten()
        .filter(cuota => cuota.mesesRestantes > 0)
        .sum(cuota => cuota.monto)
}

//(5)
class PagoACredito inherits FormaDePago {
    var maximo
    var deudaPendiente = 0

    override method pagar(persona, monto) {
        if (deudaPendiente + monto <= maximo) {
            deudaPendiente += monto
        }
        else
        self.error("NO PUEDE PAGAR")    }
}

//(6)
method personasConMasBienes(personas) {
    return personas.sort((a, b) => b.bienes.size() - a.bienes.size()).first()
}

//COMPRADORES COMPULSIVOS
class CompradorCompulsivo inherits Persona {
    comprar(bien, monto) {
        if (!formaPreferida.pagar(self, monto)) {
            formasDePago.find(forma => forma.pagar(self, monto))
        }
    }
}

//PAGADORES COMPULSIVOS
    //TODO

