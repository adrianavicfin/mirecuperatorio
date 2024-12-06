object reserva {

    // Existe una Reserva Natural cuyo objetivo es cuidar la fauna. La reserva está dividida en áreas

    const property areas = []

    var property valorComunDebilidad = 50

    method todosLosAnimalesVigorosos() = areas.map({area => area.animalVigoroso()})// ver

    method expandirReserva() {
        const nuevaArea = new Area(agua=1000, refugios=800, animales=self.todosLosAnimalesVigorosos())
        areas.add(nuevaArea)
    }

}

class Area {

    // áreas donde habitan animales y cada área cuenta con agua y refugios que se miden en unidades.

    var property agua
    var property refugios
    const property animales = []

    method animalesDebiles() =
    animales.filter({animal => animal.nivelDeEnergia() < reserva.valorComunDebilidad()})

    method esHabitable() = agua >= 700 and refugios.between(200, 300)

    method modoRecuperacion() {
        animales.forEach({animal => animal.accederARecursos(self)})
    }

    method animalVigoroso() = animales.max({animal => animal.nivelDeEnergia()})

    method sufrirIncendio() {
        animales.forEach({animal => animal.reaccionarAAmenaza()})
        agua = (agua - agua * 0.1).max(0)
    }

    method valorEnergeticoDebil() {
        return self.animalesDebiles().sum({animal => animal.nivelDeEnergia()})
    }

    method todosLosAnimalesEstanSatisfechos() = animales.all({animal => animal.estaSatisfecho(self)})

    method estaEnEquilibrio() =
    self.esHabitable() and self.todosLosAnimalesEstanSatisfechos()

}


class Animal {

    //Los animales son de diferentes especies, cada uno con un nivel de energía que varía según sus características. Cuando los animales perciben una amenaza, reaccionan de diferentes maneras para protegerse.
    
    method nivelDeEnergia()
    method reaccionarAAmenaza()
    method accederARecursos(unArea) {} // el ave y el felino de manchas no hacen nada, pero entienden el mensaje
    method estaSatisfecho(unArea) = unArea.agua() > self.nivelDeEnergia() * 3 or self.condicionExtra(unArea)
    method condicionExtra(unArea) = false

}

class Ciervo inherits Animal {

    var nivelDeAlerta = 20
    
    override method nivelDeEnergia() = if (nivelDeAlerta <= 30) 300 else nivelDeAlerta * 2

    override method reaccionarAAmenaza() {
        nivelDeAlerta = nivelDeAlerta * 2
    }

    method consumirAgua(unArea) {
        unArea.agua((unArea.agua() - 4).max(0))
    }

    override method accederARecursos(unArea) {
        self.consumirAgua(unArea)
        nivelDeAlerta += 20
    }

    override method condicionExtra(unArea) = unArea.agua() >= 10

}

class Felino inherits Animal {

    var peso
    var ferocidad

    
    override method nivelDeEnergia() = if (peso < 90) ferocidad else ferocidad / 2

    override method reaccionarAAmenaza() {
        peso += 20
    }

    method afilarGarras() {
        peso = (peso - 10).max(0)
        ferocidad += 10
    }

    method ocuparRefugio(unArea) {
        unArea.refugios((unArea.refugios() - 8).max(0))
    }

    override method accederARecursos(unArea) {
        self.ocuparRefugio(unArea)
        peso += 5
        ferocidad += 15
    }

    override method condicionExtra(unArea) = unArea.animales().any({animal => animal.nivelDeEnergia() < self.nivelDeEnergia()})

}

class Ave inherits Animal {

    var alturaDeVuelo
    
    override method nivelDeEnergia() = alturaDeVuelo * 3

    override method reaccionarAAmenaza() {
        alturaDeVuelo += 50
    }

    method vueloDeReconocimiento() {
        alturaDeVuelo = 5
    }

}

class CiervoDeMontana inherits Ciervo {
    
    override method nivelDeEnergia() = super() + 15

    override method accederARecursos(unArea) {
        super(unArea)
        nivelDeAlerta += 1
    }

}

class FelinoDeManchas inherits Felino {

    var cantidadDeManchas
    
    override method nivelDeEnergia() = super() + 2 * cantidadDeManchas

    override method reaccionarAAmenaza() {
        super()
        cantidadDeManchas += 1
    }

    override method condicionExtra(unArea) = unArea.agua() >= cantidadDeManchas

}
