class CentroDeDistribucion{
	const vendedores = []
	const property ciudadDondeEsta
	
	method agregarVendedor(vendedor) {
		if (vendedores.contains(vendedor)) self.error("El vendedor ya está registrado")
		vendedores.add(vendedor)
	}
	method vendedorEstrella() = vendedores.max{ v => v.puntajeTotal() }
	method puedeCubrir(ciudad) = vendedores.any{ v => v.puedeTrabajarEn(ciudad) }
	method vendedoresGenericos() = vendedores.filter{ v => v.esGenerico() }
	method esRobusto() = vendedores.count{ v => v.esFirme() } >= 3
	
	method repartirCertificacion(certificacion) {
		vendedores.forEach{ v => v.otorgarCertificacion(certificacion)}
	}
}

class Vendedor {
	const property certificaciones = []

	method otorgarCertificacion(certificacion) { certificaciones.add(certificacion) }
	method otorgarCertificaciones(certificacionesNuevas) { certificaciones.addAll(certificacionesNuevas) }
	method quitarCertificacion(certificacion) { certificaciones.remove(certificacion)}
	
	method puedeTrabajarEn(unaCiudad)
	method esVersatil() = 
		certificaciones.size() >= 3 && 
		certificaciones.any{ c => c.esSobreProducto()} &&
		certificaciones.any{ c => !c.esSobreProducto()}
	method esFirme() = certificaciones.sum{ c => c.puntosQueOtorga()} >= 30
	
	method esInfluyente()
	
	method puntajeTotal() = certificaciones.sum{ c => c.puntosQueOtorga() }
	method esGenerico() = certificaciones.any{ c => !c.esSobreProducto()}
	
	method tieneAfinidadCon(centro) = self.puedeTrabajarEn(centro.ciudadDondeEsta())
	method esCandidatoPara(centro) = self.esVersatil() && self.tieneAfinidadCon(centro)
	
	method esPersonaFisica() = true
}

class VendedorFijo inherits Vendedor {
	const ciudadDondeVive
	
	override method puedeTrabajarEn(unaCiudad) = unaCiudad == ciudadDondeVive
	
	override method esInfluyente() = false
}

class Viajante inherits Vendedor {
	const provinciasHabilitado = []
	
	method habilitarEnProvincias(provNuevas) { provinciasHabilitado.addAll(provNuevas) }
	method deshabilitarEnProvincia(provQuitada) { provinciasHabilitado.remove(provQuitada)}
	
	override method puedeTrabajarEn(unaCiudad) = provinciasHabilitado.contains(unaCiudad.estaEnProvincia())

	override method esInfluyente() = provinciasHabilitado.sum{ p => p.poblacion()} >= 10
}

class ComercioCorresponsal inherits Vendedor {
	const ciudadesConSucursal = #{}
	
	method crearSucursalEn(ciudades) { ciudadesConSucursal.addAll(ciudades) }
	method demolerSucursalDe(ciudad) { ciudadesConSucursal.remove(ciudad)}
	
	override method puedeTrabajarEn(unaCiudad) = ciudadesConSucursal.contains(unaCiudad)

	override method esInfluyente() =
		ciudadesConSucursal.size() >= 5 ||
		self.provinciasConSucursal().size() >= 3
	method provinciasConSucursal() = ciudadesConSucursal.map({ c => c.estaEnProvincia() }).asSet()
	
	override method tieneAfinidadCon(centro) = super(centro) && ciudadesConSucursal.any{ c => !centro.puedeCubrir(c)}

	override method esPersonaFisica() = false
}

class Ciudad {
	const nombre
	const property estaEnProvincia
}

class Provincia {
	const nombre
	var property poblacion // en millones
}

class Certificacion {
	const property nombre
	const property puntosQueOtorga
	const property esSobreProducto
}

class Cliente {
	method puedeSerAtendidoPor(vendedor)
}

class Inseguro inherits Cliente {
	override method puedeSerAtendidoPor(vendedor) = vendedor.esVersatil() && vendedor.esFirme()
}

class Detallista inherits Cliente {
	override method puedeSerAtendidoPor(vendedor) = vendedor.certificaciones().count{ c => c.esSobreProducto() } >= 3
}

class Humanista inherits Cliente {
	override method puedeSerAtendidoPor(vendedor) = vendedor.esPersonaFisica()
}