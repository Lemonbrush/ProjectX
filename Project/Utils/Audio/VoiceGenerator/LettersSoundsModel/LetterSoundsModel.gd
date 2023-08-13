extends Resource
class_name LetterSoundsModel

export (AudioStreamSample) var a_letter_sample
export (AudioStreamSample) var b_letter_sample
export (AudioStreamSample) var v_letter_sample
export (AudioStreamSample) var g_letter_sample
export (AudioStreamSample) var d_letter_sample
export (AudioStreamSample) var e_letter_sample
export (AudioStreamSample) var io_letter_sample
export (AudioStreamSample) var j_letter_sample
export (AudioStreamSample) var z_letter_sample
export (AudioStreamSample) var i_letter_sample
export (AudioStreamSample) var ii_letter_sample
export (AudioStreamSample) var k_letter_sample
export (AudioStreamSample) var l_letter_sample
export (AudioStreamSample) var m_letter_sample
export (AudioStreamSample) var n_letter_sample
export (AudioStreamSample) var o_letter_sample
export (AudioStreamSample) var p_letter_sample
export (AudioStreamSample) var r_letter_sample
export (AudioStreamSample) var s_letter_sample
export (AudioStreamSample) var t_letter_sample
export (AudioStreamSample) var y_letter_sample
export (AudioStreamSample) var f_letter_sample
export (AudioStreamSample) var h_letter_sample
export (AudioStreamSample) var c_letter_sample
export (AudioStreamSample) var ch_letter_sample
export (AudioStreamSample) var sh_letter_sample
export (AudioStreamSample) var shh_letter_sample
export (AudioStreamSample) var ih_letter_sample
export (AudioStreamSample) var ia_letter_sample
export (AudioStreamSample) var iy_letter_sample
export (AudioStreamSample) var ya_letter_sample
export (AudioStreamSample) var blank_letter_sample
export (AudioStreamSample) var long_blank_letter_sample
export (AudioStreamSample) var default_letter_sample

var sounds = {}

func load_sounds_dictionary():
	sounds = {
	'а': a_letter_sample,
	'б': b_letter_sample,
	'в': v_letter_sample,
	'г': g_letter_sample,
	'д': d_letter_sample,
	'е': e_letter_sample,
	'ё': io_letter_sample,
	'ж': j_letter_sample,
	'з': z_letter_sample,
	'и': i_letter_sample,
	'й': ii_letter_sample,
	'к': k_letter_sample,
	'л': l_letter_sample,
	'м': m_letter_sample,
	'н': n_letter_sample,
	'о': o_letter_sample,
	'п': p_letter_sample,
	'р': r_letter_sample,
	'с': s_letter_sample,
	'т': t_letter_sample,
	'у': y_letter_sample,
	'ф': f_letter_sample,
	'х': h_letter_sample,
	'ц': c_letter_sample,
	'ч': ch_letter_sample,
	'ш': sh_letter_sample,
	'щ': shh_letter_sample,
	'ы': ih_letter_sample,
	'э': ia_letter_sample,
	'ю': iy_letter_sample,
	'я': ya_letter_sample,
	' ': blank_letter_sample,
	'.': long_blank_letter_sample
}

func get_sound_for_letter(letter):
	var sound = sounds[letter]
	
	var capital_letter = letter.to_upper()
	if sound == null and sounds.has(capital_letter):
		sound = sounds[capital_letter]
	
	if sound == null:
		sound = default_letter_sample
	
	return sound
