function registracija() {
	let klaida = false;
	let klaidos_tekstas = '';
	
	// VARDO LAUKELIS
	let vardas = document.forms.forma.elements.vardas;
	if (vardas.value.length >= 1) {
		vardas.style.borderColor = 'black';
	} else {
		klaida = true;
		klaidos_tekstas += 'Prašome įrašyti Jūsų vardą.<br />';
		vardas.style.borderColor = 'red';
	}
	
	// PAVARDĖS LAUKELIS
	let pavarde = document.forms.forma.elements.pavarde;
	if (pavarde.value.length >= 1) {
		pavarde.style.borderColor = 'black';
	} else {
		klaida = true;
		klaidos_tekstas += 'Prašome įrašyti Jūsų pavardę.<br />';
		pavarde.style.borderColor = 'red';
	}

	// EL. PAŠTO LAUKELIS
	let el_pastas = document.forms.forma.elements.el_pastas;
	if (el_pastas.value.length >= 1) {
		el_pastas.style.borderColor = 'black';
	} else {
		klaida = true;
		klaidos_tekstas += 'Prašome įrašyti Jūsų el. pašto adresą.<br />';
		el_pastas.style.borderColor = 'red';
	}
	let geras_pastas = el_pastas.value.match(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
	if (geras_pastas == null) {
		klaida = true;
		klaidos_tekstas += 'Prašome įrašyti Jūsų el. pašto adresą reikiamu formatu.<br />';
		el_pastas.style.borderColor = 'red';
	} else {
		el_pastas.style.borderColor = 'black';
	}

	// TELEFONO LAUKELIS
	let tel_nr = document.forms.forma.elements.telefonas;
	if (tel_nr.value.length >= 1) {
		let geras_numeris = tel_nr.value.match(/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/);
		if (geras_numeris == null) {
			klaida = true;
			klaidos_tekstas += 'Prašome įrašyti Jūsų telefono numeri reikiamu formatu.<br />';
			tel_nr.style.borderColor = 'red';
		}
	} else {
		tel_nr.style.borderColor = 'black';
	}

	// SLAPTAŽODŽIO LAUKELIS
	let slaptazodis = document.forms.forma.elements.slaptazodis;
	if (slaptazodis.value.length >= 1) {
		slaptazodis.style.borderColor = 'black';
	} else {
		klaida = true;
		klaidos_tekstas += 'Prašome įrašyti slaptažodį.<br />';
		slaptazodis.style.borderColor = 'red';
	}
	let slaptazodis_skaitmuo = slaptazodis.value.match(/[0-9]/);
	if(slaptazodis_skaitmuo == null) {
		klaida = true;
		klaidos_tekstas += 'Prašome slaptažodyje panaudoti bent vieną skaitmenį.<br />';
		slaptazodis.style.borderColor = 'red';
	} else {
		slaptazodis.style.borderColor = 'black';
	}
	let slaptazodis_mazoji_raide = slaptazodis.value.match(/[a-z]/);
	if(slaptazodis_mazoji_raide == null) {
		klaida = true;
		klaidos_tekstas += 'Prašome slaptažodyje panaudoti bent vieną mažają raidę.<br />';
		slaptazodis.style.borderColor = 'red';
	} else {
		slaptazodis.style.borderColor = 'black';
	}
	let slaptazodis_didzioji_raide = slaptazodis.value.match(/[A-Z]/);
	if(slaptazodis_didzioji_raide == null) {
		klaida = true;
		klaidos_tekstas += 'Prašome slaptažodyje panaudoti bent vieną didžiają raidę.<br />';
		slaptazodis.style.borderColor = 'red';
	} else {
		slaptazodis.style.borderColor = 'black';
	}
	let slaptazodis_simbolis = slaptazodis.value.match(/[^0-9a-zA-Z]/);
	if(slaptazodis_simbolis == null) {
		klaida = true;
		klaidos_tekstas += 'Prašome slaptažodyje panaudoti bent vieną simbolį.<br />';
		slaptazodis.style.borderColor = 'red';
	} else {
		slaptazodis.style.borderColor = 'black';
	}
	if (slaptazodis.value.length < 5 || slaptazodis.value.length > 16) {
		klaida = true;
		klaidos_tekstas += 'Slaptažodis turi būti ne trumpesnis nei 5 simboliai ir ne ilgesnins negu 16.<br />';
		slaptazodis.style.borderColor = 'red';
	} else {
		slaptazodis.style.borderColor = 'black';
	}
	let pakartoti_slaptazodi = document.forms.forma.elements.pakartoti_slaptazodi;
	if (slaptazodis.value != pakartoti_slaptazodi.value) {
		klaida = true;
		klaidos_tekstas += 'Jūsų slaptažodžiai nesutampa.<br />';
		pakartoti_slaptazodi.style.borderColor = 'red';
	} else {
		pakartoti_slaptazodi.style.borderColor = 'black';	
	}
	
	if(klaida==true) {
		document.getElementById('pranesimas').innerHTML = klaidos_tekstas;
		return false;
	} else {
		return true;
	}
}