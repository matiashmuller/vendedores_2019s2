class CentroDeDistribucion{
	const vendedores = []
	
}

class Vendedor {
	const certificaciones = []

	method otorgarCertificaciones(certificacionesNuevas) { certificaciones.addAll(certificacionesNuevas) }
	method quitarCertificacion(certificacion) { certificaciones.remove(certificacion)}
	
	method puedeTrabajarEn(unaCiudad)
	method esVersatil() = 
		certificaciones.size() >= 3 && 
		certificaciones.any{ c => c.esSobreProducto()} &&
		certificaciones.any{ c => !c.esSobreProducto()}
	method esFirme() = certificaciones.sum{ c => c.puntosQueOtorga()} >= 30
	
	method esInfluyente()
		
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
	const ciudadesConSucursal = []
	
	method crearSucursalEn(ciudades) { ciudadesConSucursal.addAll(ciudades) }
	method demolerSucursalDe(ciudad) { ciudadesConSucursal.remove(ciudad)}
	
	override method puedeTrabajarEn(unaCiudad) = ciudadesConSucursal.contains(unaCiudad)

	override method esInfluyente() =
		ciudadesConSucursal.size() >= 5 ||
		self.provinciasConSucursal().size() >= 3
	method provinciasConSucursal() = ciudadesConSucursal.map({ c => c.estaEnProvincia() }).asSet()
}

class Ciudad {
	const nombre
	const property estaEnProvincia
}

class Provincia {
	const nombre
	var property poblacion
}

class Certificacion {
	const property nombre
	const property puntosQueOtorga
	const property esSobreProducto
}