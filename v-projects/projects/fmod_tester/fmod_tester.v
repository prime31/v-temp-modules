import prime31.fmod
import time

fn main() {
	sys := voidptr(0)
	FMOD_System_Create(&sys)
	FMOD_System_Init(sys, 32, 0, C.NULL)

	snd := voidptr(0)
	FMOD_System_CreateSound(sys, "skid.wav", C.FMOD_DEBUG_MODE_FILE, C.NULL, &snd)

	len := u32(0)
	FMOD_Sound_GetLength(snd, &len, C.FMOD_TIMEUNIT_RAWBYTES)
	println("snd: got len: $len")

	FMOD_System_GetVersion(sys, &len)
	println("version: $len")

	channel := voidptr(0)
	FMOD_System_PlaySound(sys, snd, C.NULL, 0, &channel)
	FMOD_Channel_SetPitch(channel, 1.5)


	println('tick')
	time.sleep_ms(5000)
}